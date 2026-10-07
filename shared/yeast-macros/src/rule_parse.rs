use proc_macro2::{Delimiter, Ident, Span, TokenStream, TokenTree};
use std::iter::Peekable;

use crate::ast::{Capture, Cardinality, Pattern, Replacement, ReturnAnnotation, Rule};

type Tokens = Peekable<proc_macro2::token_stream::IntoIter>;
type Result<T> = std::result::Result<T, syn::Error>;

pub(crate) fn parse_pattern(input: TokenStream) -> Result<Pattern> {
    let mut tokens = input.into_iter().peekable();
    let pattern = parse_pattern_with_capture(&mut tokens)?;
    if let Some(token) = tokens.next() {
        return Err(syn::Error::new_spanned(
            token,
            "unexpected token after query",
        ));
    }
    Ok(pattern)
}

pub(crate) fn parse_rule(input: TokenStream) -> Result<Rule> {
    let (pattern_and_guard, replacement) = split_arrow(input)?;
    let (pattern, guard) = split_guard(pattern_and_guard)?;
    Ok(Rule {
        pattern: parse_pattern(pattern)?,
        guard,
        replacement: parse_replacement(replacement)?,
    })
}

fn parse_pattern_with_capture(tokens: &mut Tokens) -> Result<Pattern> {
    let pattern = parse_pattern_atom(tokens)?;
    if peek_is_at(tokens) {
        Ok(Pattern::Capture {
            capture: consume_capture(tokens)?,
            pattern: Box::new(pattern),
        })
    } else {
        Ok(pattern)
    }
}

fn parse_pattern_atom(tokens: &mut Tokens) -> Result<Pattern> {
    match tokens.peek() {
        None => Err(syn::Error::new(
            Span::call_site(),
            "unexpected end of query",
        )),
        Some(TokenTree::Group(group)) if group.delimiter() == Delimiter::Parenthesis => {
            let group = expect_group(tokens, Delimiter::Parenthesis)?;
            let mut inner = group.stream().into_iter().peekable();
            let pattern = parse_parenthesized_pattern(&mut inner)?;
            if let Some(token) = inner.next() {
                return Err(syn::Error::new_spanned(
                    token,
                    "unexpected token in query node",
                ));
            }
            Ok(pattern)
        }
        Some(TokenTree::Ident(identifier)) if *identifier == "_" => {
            tokens.next();
            Ok(Pattern::Any {
                match_unnamed: true,
            })
        }
        Some(TokenTree::Literal(_)) => Ok(Pattern::Unnamed(expect_string_literal(tokens)?)),
        Some(token) => Err(syn::Error::new_spanned(
            token.clone(),
            "expected `(`, `_`, or string literal in query",
        )),
    }
}

fn parse_parenthesized_pattern(tokens: &mut Tokens) -> Result<Pattern> {
    match tokens.peek() {
        None => Err(syn::Error::new(
            Span::call_site(),
            "empty parenthesized group in query",
        )),
        Some(TokenTree::Ident(identifier)) if *identifier == "_" => {
            tokens.next();
            Ok(Pattern::Any {
                match_unnamed: false,
            })
        }
        Some(TokenTree::Literal(_)) => Ok(Pattern::Unnamed(expect_string_literal(tokens)?)),
        Some(TokenTree::Ident(_)) => {
            let kind = expect_ident(tokens, "expected node kind")?.to_string();
            Ok(Pattern::Node {
                kind,
                fields: parse_pattern_fields(tokens)?,
            })
        }
        Some(token) => Err(syn::Error::new_spanned(
            token.clone(),
            "expected node kind, `_`, or string literal",
        )),
    }
}

fn parse_pattern_fields(tokens: &mut Tokens) -> Result<Vec<(String, Pattern)>> {
    let mut fields = Vec::new();
    let mut bare_children = Vec::new();

    while tokens.peek().is_some() {
        if peek_is_field(tokens) {
            let name = expect_ident(tokens, "expected field name")?.to_string();
            expect_punct(tokens, ':', "expected `:` after field name")?;
            let atom = if peek_is_at(tokens) {
                Pattern::Any {
                    match_unnamed: true,
                }
            } else {
                parse_pattern_atom(tokens)?
            };
            let pattern = if peek_is_repetition(tokens) {
                let cardinality = expect_cardinality(tokens)?;
                let pattern = capture_repeated_pattern(tokens, atom)?;
                Pattern::Repeated {
                    pattern: Box::new(pattern),
                    cardinality,
                }
            } else {
                maybe_capture(tokens, atom)?
            };
            push_field_pattern(&mut fields, name, pattern);
        } else {
            let patterns = parse_pattern_list(tokens)?;
            if patterns.is_empty() {
                break;
            }
            bare_children.extend(patterns);
        }
    }

    if !bare_children.is_empty() {
        fields.push(("child".to_string(), Pattern::Sequence(bare_children)));
    }
    Ok(fields)
}

fn push_field_pattern(fields: &mut Vec<(String, Pattern)>, name: String, pattern: Pattern) {
    if let Some((_, existing)) = fields.iter_mut().find(|(existing, _)| *existing == name) {
        let Pattern::Sequence(patterns) = existing else {
            unreachable!("field patterns are always sequences");
        };
        patterns.push(pattern);
    } else {
        fields.push((name, Pattern::Sequence(vec![pattern])));
    }
}

fn parse_pattern_list(tokens: &mut Tokens) -> Result<Vec<Pattern>> {
    let mut patterns = Vec::new();
    while tokens.peek().is_some() {
        if peek_is_group(tokens, Delimiter::Parenthesis) {
            let group = expect_group(tokens, Delimiter::Parenthesis)?;
            let mut inner = group.stream().into_iter().peekable();
            if peek_is_repetition(tokens) {
                let cardinality = expect_cardinality(tokens)?;
                let is_single_pattern = matches!(inner.peek(), Some(TokenTree::Ident(_)));
                let repeated = if is_single_pattern {
                    parse_parenthesized_pattern(&mut inner)?
                } else {
                    Pattern::Sequence(parse_pattern_list(&mut inner)?)
                };
                let repeated = capture_repeated_pattern(tokens, repeated)?;
                patterns.push(Pattern::Repeated {
                    pattern: Box::new(repeated),
                    cardinality,
                });
            } else {
                let pattern = parse_parenthesized_pattern(&mut inner)?;
                patterns.push(maybe_capture(tokens, pattern)?);
            }
            continue;
        }

        if matches!(tokens.peek(), Some(TokenTree::Literal(_))) {
            let literal = expect_string_literal(tokens)?;
            let pattern = maybe_capture(tokens, Pattern::Unnamed(literal))?;
            patterns.push(maybe_repeat(tokens, pattern)?);
            continue;
        }

        if matches!(tokens.peek(), Some(TokenTree::Ident(identifier)) if *identifier == "_") {
            tokens.next();
            let pattern = maybe_capture(
                tokens,
                Pattern::Any {
                    match_unnamed: true,
                },
            )?;
            patterns.push(maybe_repeat(tokens, pattern)?);
            continue;
        }

        break;
    }
    Ok(patterns)
}

fn maybe_capture(tokens: &mut Tokens, pattern: Pattern) -> Result<Pattern> {
    if peek_is_at(tokens) {
        Ok(Pattern::Capture {
            capture: consume_capture(tokens)?,
            pattern: Box::new(pattern),
        })
    } else {
        Ok(pattern)
    }
}

fn maybe_repeat(tokens: &mut Tokens, pattern: Pattern) -> Result<Pattern> {
    if !peek_is_repetition(tokens) {
        return Ok(pattern);
    }

    let cardinality = expect_cardinality(tokens)?;
    let pattern = capture_repeated_pattern(tokens, pattern)?;
    Ok(Pattern::Repeated {
        pattern: Box::new(pattern),
        cardinality,
    })
}

fn capture_repeated_pattern(tokens: &mut Tokens, pattern: Pattern) -> Result<Pattern> {
    if !peek_is_at(tokens) {
        return Ok(pattern);
    }

    let capture = consume_capture(tokens)?;
    Ok(match pattern {
        Pattern::Sequence(patterns) => Pattern::Sequence(
            patterns
                .into_iter()
                .map(|pattern| Pattern::Capture {
                    capture: capture.clone(),
                    pattern: Box::new(pattern),
                })
                .collect(),
        ),
        pattern => Pattern::Capture {
            capture,
            pattern: Box::new(pattern),
        },
    })
}

fn parse_replacement(input: TokenStream) -> Result<Replacement> {
    let mut tokens = input.into_iter().peekable();
    if let Some(annotation) = try_consume_return_annotation(&mut tokens)? {
        let body = syn::parse2(TokenStream::from(TokenTree::Group(expect_group(
            &mut tokens,
            Delimiter::Brace,
        )?)))?;
        if let Some(token) = tokens.next() {
            return Err(syn::Error::new_spanned(
                token,
                "unexpected token after annotated rule body",
            ));
        }
        return Ok(Replacement::Rust { annotation, body });
    }

    if let Some(TokenTree::Group(group)) = tokens.peek() {
        if group.delimiter() == Delimiter::Brace {
            return Err(syn::Error::new(
                group.span(),
                "bare `{...}` rule bodies are no longer accepted; \
                 use the annotation form `=> kind [? | *] { ... }` \
                 (where the kind names the output node's schema kind, \
                 optionally suffixed with `?` or `*` for cardinality)",
            ));
        }
    }

    let templates = crate::template_parse::parse_templates(tokens.collect())?;
    Ok(Replacement::Templates(templates))
}

fn try_consume_return_annotation(tokens: &mut Tokens) -> Result<Option<ReturnAnnotation>> {
    let mut lookahead = tokens.clone();
    let Some(TokenTree::Ident(_)) = lookahead.next() else {
        return Ok(None);
    };
    let after_suffix = match lookahead.peek() {
        Some(TokenTree::Punct(punctuation))
            if punctuation.as_char() == '?' || punctuation.as_char() == '*' =>
        {
            lookahead.next();
            lookahead.peek()
        }
        other => other,
    };
    if !matches!(after_suffix, Some(TokenTree::Group(group)) if group.delimiter() == Delimiter::Brace)
    {
        return Ok(None);
    }

    let kind = expect_ident(tokens, "expected output-kind name in annotation")?;
    let cardinality = match tokens.peek() {
        Some(TokenTree::Punct(punctuation)) if punctuation.as_char() == '?' => {
            tokens.next();
            Cardinality::OPTIONAL
        }
        Some(TokenTree::Punct(punctuation)) if punctuation.as_char() == '*' => {
            tokens.next();
            Cardinality::ZERO_OR_MORE
        }
        _ => Cardinality::SINGLE,
    };
    Ok(Some(ReturnAnnotation { kind, cardinality }))
}

fn split_arrow(input: TokenStream) -> Result<(TokenStream, TokenStream)> {
    let mut tokens = input.into_iter().peekable();
    let mut before = Vec::new();
    loop {
        match tokens.next() {
            None => return Err(syn::Error::new(Span::call_site(), "expected `=>` in rule!")),
            Some(TokenTree::Punct(first)) if first.as_char() == '=' => {
                if matches!(tokens.peek(), Some(TokenTree::Punct(second)) if second.as_char() == '>')
                {
                    tokens.next();
                    return Ok((before.into_iter().collect(), tokens.collect()));
                }
                before.push(TokenTree::Punct(first));
            }
            Some(token) => before.push(token),
        }
    }
}

fn split_guard(input: TokenStream) -> Result<(TokenStream, Option<syn::Expr>)> {
    let tokens = input.into_iter().collect::<Vec<_>>();
    let guard_index = tokens
        .iter()
        .position(|token| matches!(token, TokenTree::Ident(identifier) if identifier == "where"));
    let Some(guard_index) = guard_index else {
        return Ok((tokens.into_iter().collect(), None));
    };

    let pattern = tokens[..guard_index].iter().cloned().collect();
    let guard_tokens = tokens[guard_index + 1..]
        .iter()
        .cloned()
        .collect::<TokenStream>();
    if guard_tokens.is_empty() {
        return Err(syn::Error::new(
            Span::call_site(),
            "expected guard expression after `where`",
        ));
    }
    Ok((pattern, Some(syn::parse2(guard_tokens)?)))
}

fn consume_capture(tokens: &mut Tokens) -> Result<Capture> {
    expect_punct(tokens, '@', "expected `@`")?;
    let raw = if peek_is_at(tokens) {
        tokens.next();
        true
    } else {
        false
    };
    Ok(Capture {
        name: expect_ident(tokens, "expected capture name after `@` or `@@`")?,
        raw,
    })
}

fn expect_cardinality(tokens: &mut Tokens) -> Result<Cardinality> {
    match tokens.next() {
        Some(TokenTree::Punct(punctuation)) => match punctuation.as_char() {
            '*' => Ok(Cardinality::ZERO_OR_MORE),
            '+' => Ok(Cardinality::ONE_OR_MORE),
            '?' => Ok(Cardinality::OPTIONAL),
            _ => Err(syn::Error::new(
                punctuation.span(),
                "expected `*`, `+`, or `?`",
            )),
        },
        Some(token) => Err(syn::Error::new_spanned(
            token,
            "expected repetition quantifier",
        )),
        None => Err(syn::Error::new(
            Span::call_site(),
            "expected repetition quantifier",
        )),
    }
}

fn peek_is_at(tokens: &mut Tokens) -> bool {
    matches!(tokens.peek(), Some(TokenTree::Punct(punctuation)) if punctuation.as_char() == '@')
}

fn peek_is_repetition(tokens: &mut Tokens) -> bool {
    matches!(
        tokens.peek(),
        Some(TokenTree::Punct(punctuation))
            if matches!(punctuation.as_char(), '*' | '+' | '?')
    )
}

fn peek_is_field(tokens: &mut Tokens) -> bool {
    matches!(tokens.peek(), Some(TokenTree::Ident(identifier)) if *identifier != "_")
}

fn peek_is_group(tokens: &mut Tokens, delimiter: Delimiter) -> bool {
    matches!(tokens.peek(), Some(TokenTree::Group(group)) if group.delimiter() == delimiter)
}

fn expect_ident(tokens: &mut Tokens, message: &str) -> Result<Ident> {
    match tokens.next() {
        Some(TokenTree::Ident(identifier)) => Ok(identifier),
        Some(token) => Err(syn::Error::new_spanned(token, message)),
        None => Err(syn::Error::new(Span::call_site(), message)),
    }
}

fn expect_literal(tokens: &mut Tokens) -> Result<proc_macro2::Literal> {
    match tokens.next() {
        Some(TokenTree::Literal(literal)) => Ok(literal),
        Some(token) => Err(syn::Error::new_spanned(token, "expected string literal")),
        None => Err(syn::Error::new(
            Span::call_site(),
            "expected string literal",
        )),
    }
}

fn expect_string_literal(tokens: &mut Tokens) -> Result<String> {
    let literal = expect_literal(tokens)?;
    syn::parse2::<syn::LitStr>(TokenStream::from(TokenTree::Literal(literal.clone())))
        .map(|literal| literal.value())
        .map_err(|_| syn::Error::new(literal.span(), "expected string literal"))
}

fn expect_punct(tokens: &mut Tokens, expected: char, message: &str) -> Result<()> {
    match tokens.next() {
        Some(TokenTree::Punct(punctuation)) if punctuation.as_char() == expected => Ok(()),
        Some(token) => Err(syn::Error::new_spanned(token, message)),
        None => Err(syn::Error::new(Span::call_site(), message)),
    }
}

fn expect_group(tokens: &mut Tokens, delimiter: Delimiter) -> Result<proc_macro2::Group> {
    match tokens.next() {
        Some(TokenTree::Group(group)) if group.delimiter() == delimiter => Ok(group),
        Some(token) => Err(syn::Error::new_spanned(
            token,
            format!("expected {delimiter:?} group"),
        )),
        None => Err(syn::Error::new(
            Span::call_site(),
            format!("expected {delimiter:?} group"),
        )),
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use quote::quote;

    #[test]
    fn parses_complete_rule() {
        let rule = parse_rule(quote! {
            (call
                argument: (_)* @args
                method: (identifier) @@name)
            where !args.is_empty()
            =>
            call? {
                Some(tree!((call method: {name} argument: {args})))
            }
        })
        .unwrap();

        assert!(rule.guard.is_some());
        assert!(matches!(
            rule.replacement,
            Replacement::Rust {
                annotation: ReturnAnnotation {
                    cardinality: Cardinality::OPTIONAL,
                    ..
                },
                ..
            }
        ));

        let Pattern::Node { kind, fields } = rule.pattern else {
            panic!("expected root node pattern");
        };
        assert_eq!(kind, "call");
        assert_eq!(fields.len(), 2);
        let (_, argument_pattern) = fields
            .iter()
            .find(|(name, _)| name == "argument")
            .expect("argument field");
        assert!(matches!(
            argument_pattern,
            Pattern::Sequence(patterns)
                if matches!(
                    patterns.as_slice(),
                    [Pattern::Repeated {
                        pattern,
                        cardinality: Cardinality::ZERO_OR_MORE,
                    }] if matches!(pattern.as_ref(), Pattern::Capture { .. })
                )
        ));
    }

    #[test]
    fn parses_template_replacement() {
        let rule = parse_rule(quote! {
            (identifier) @name
            =>
            (identifier #{name})
        })
        .unwrap();

        assert!(rule.guard.is_none());
        assert!(matches!(rule.replacement, Replacement::Templates(_)));
    }
}

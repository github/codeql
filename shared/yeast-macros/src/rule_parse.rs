use proc_macro2::{Delimiter, Ident, Span, TokenStream, TokenTree};
use std::collections::BTreeSet;
use std::iter::Peekable;

use crate::ast::{Cardinality, Pattern, Replacement, ReturnAnnotation, Rule};

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
    validate_unique_capture_names(&pattern, &mut BTreeSet::new())?;
    Ok(pattern)
}

fn validate_unique_capture_names(
    pattern: &Pattern,
    capture_names: &mut BTreeSet<String>,
) -> Result<()> {
    match pattern {
        Pattern::Any { .. } | Pattern::Unnamed(_) => {}
        Pattern::Node { fields, .. } => {
            for (_, pattern) in fields {
                validate_unique_capture_names(pattern, capture_names)?;
            }
        }
        Pattern::Capture { name, pattern, .. } => {
            validate_unique_capture_names(pattern, capture_names)?;
            let name_string = name.to_string();
            if !capture_names.insert(name_string.clone()) {
                return Err(syn::Error::new_spanned(
                    name,
                    format!(
                        "capture `{name_string}` is used more than once; \
                         use a distinct name for each capture site"
                    ),
                ));
            }
        }
        Pattern::Sequence(patterns) => {
            for pattern in patterns {
                validate_unique_capture_names(pattern, capture_names)?;
            }
        }
        Pattern::Repeated { pattern, .. } => {
            validate_unique_capture_names(pattern, capture_names)?;
        }
    }
    Ok(())
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
    maybe_capture(tokens, pattern, Cardinality::SINGLE)
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
            parse_parenthesized_pattern(&mut inner, group.span())
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

fn parse_parenthesized_pattern(tokens: &mut Tokens, span: Span) -> Result<Pattern> {
    match tokens.peek() {
        None => Err(syn::Error::new(span, "empty query groups are not allowed")),
        Some(TokenTree::Ident(identifier)) if *identifier == "_" => {
            tokens.next();
            if tokens.peek().is_none() {
                Ok(Pattern::Any {
                    match_unnamed: false,
                })
            } else {
                let mut patterns = vec![Pattern::Any {
                    match_unnamed: true,
                }];
                patterns.extend(parse_pattern_list(tokens)?);
                finish_sequence(tokens, patterns, span)
            }
        }
        Some(TokenTree::Literal(_)) => {
            let first = Pattern::Unnamed(expect_string_literal(tokens)?);
            if tokens.peek().is_none() {
                Ok(first)
            } else {
                let mut patterns = vec![first];
                patterns.extend(parse_pattern_list(tokens)?);
                finish_sequence(tokens, patterns, span)
            }
        }
        Some(TokenTree::Ident(_)) => {
            let kind = expect_ident(tokens, "expected node kind")?.to_string();
            let pattern = Pattern::Node {
                kind,
                fields: parse_pattern_fields(tokens)?,
            };
            if let Some(token) = tokens.next() {
                Err(syn::Error::new_spanned(
                    token,
                    "unexpected token in query node",
                ))
            } else {
                Ok(pattern)
            }
        }
        Some(TokenTree::Group(group)) if group.delimiter() == Delimiter::Parenthesis => {
            let patterns = parse_pattern_list(tokens)?;
            finish_sequence(tokens, patterns, span)
        }
        Some(token) => Err(syn::Error::new_spanned(
            token.clone(),
            "expected node kind, `_`, or string literal",
        )),
    }
}

fn finish_sequence(tokens: &mut Tokens, patterns: Vec<Pattern>, span: Span) -> Result<Pattern> {
    if let Some(token) = tokens.next() {
        return Err(syn::Error::new_spanned(
            token,
            "unexpected token in query sequence",
        ));
    }
    match patterns.len() {
        0 => Err(syn::Error::new(span, "empty query groups are not allowed")),
        1 => Err(syn::Error::new(
            span,
            "single-pattern query groups are not allowed; remove the redundant parentheses",
        )),
        _ => Ok(Pattern::Sequence(patterns)),
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
            let pattern = maybe_repeat(tokens, atom)?;
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
            let pattern = parse_parenthesized_pattern(&mut inner, group.span())?;
            patterns.push(maybe_repeat(tokens, pattern)?);
            continue;
        }

        if matches!(tokens.peek(), Some(TokenTree::Literal(_))) {
            let literal = expect_string_literal(tokens)?;
            patterns.push(maybe_repeat(tokens, Pattern::Unnamed(literal))?);
            continue;
        }

        if matches!(tokens.peek(), Some(TokenTree::Ident(identifier)) if *identifier == "_") {
            tokens.next();
            patterns.push(maybe_repeat(
                tokens,
                Pattern::Any {
                    match_unnamed: true,
                },
            )?);
            continue;
        }

        break;
    }
    Ok(patterns)
}

fn maybe_capture(
    tokens: &mut Tokens,
    pattern: Pattern,
    cardinality: Cardinality,
) -> Result<Pattern> {
    if peek_is_at(tokens) {
        if !pattern.matches_single_node() {
            return Err(syn::Error::new_spanned(
                tokens.peek().unwrap().clone(),
                "cannot capture a query sequence; capture the desired nodes explicitly",
            ));
        }
        let (name, raw) = consume_capture(tokens)?;
        Ok(Pattern::Capture {
            name,
            raw,
            pattern: Box::new(pattern),
            cardinality,
        })
    } else if cardinality == Cardinality::SINGLE {
        Ok(pattern)
    } else {
        Ok(Pattern::Repeated {
            pattern: Box::new(pattern),
            cardinality,
        })
    }
}

fn maybe_repeat(tokens: &mut Tokens, pattern: Pattern) -> Result<Pattern> {
    let cardinality = if peek_is_repetition(tokens) {
        expect_cardinality(tokens)?
    } else {
        Cardinality::SINGLE
    };
    maybe_capture(tokens, pattern, cardinality)
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

fn consume_capture(tokens: &mut Tokens) -> Result<(Ident, bool)> {
    expect_punct(tokens, '@', "expected `@`")?;
    let raw = if peek_is_at(tokens) {
        tokens.next();
        true
    } else {
        false
    };
    Ok((
        expect_ident(tokens, "expected capture name after `@` or `@@`")?,
        raw,
    ))
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
                    [Pattern::Capture {
                        cardinality: Cardinality::ZERO_OR_MORE,
                        ..
                    }]
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

    #[test]
    fn repeated_capture_owns_its_cardinality() {
        let pattern = parse_pattern(quote!((array (identifier)* @items))).unwrap();

        let Pattern::Node { fields, .. } = pattern else {
            panic!("expected array node pattern");
        };
        let Pattern::Sequence(children) = &fields[0].1 else {
            panic!("expected child sequence");
        };
        let Pattern::Capture {
            name,
            pattern: captured,
            cardinality,
            ..
        } = &children[0]
        else {
            panic!("expected repeated capture");
        };
        assert_eq!(name, "items");
        assert_eq!(*cardinality, Cardinality::ZERO_OR_MORE);
        assert!(matches!(captured.as_ref(), Pattern::Node { .. }));
    }

    #[test]
    fn rejects_one_element_repeated_group() {
        let result = parse_pattern(quote!((array ((identifier))* @items)));
        let Err(error) = result else {
            panic!("expected redundant query group to be rejected");
        };
        assert_eq!(
            error.to_string(),
            "single-pattern query groups are not allowed; remove the redundant parentheses"
        );
    }

    #[test]
    fn rejects_empty_repeated_group() {
        let result = parse_pattern(quote!((array ()*)));
        let Err(error) = result else {
            panic!("expected empty query group to be rejected");
        };
        assert_eq!(error.to_string(), "empty query groups are not allowed");
    }

    #[test]
    fn rejects_capture_of_query_sequence() {
        let result = maybe_capture(
            &mut quote!(@item).into_iter().peekable(),
            Pattern::Sequence(vec![
                Pattern::Node {
                    kind: "identifier".to_string(),
                    fields: Vec::new(),
                },
                Pattern::Node {
                    kind: "integer".to_string(),
                    fields: Vec::new(),
                },
            ]),
            Cardinality::SINGLE,
        );
        let Err(error) = result else {
            panic!("expected multi-node sequence capture to be rejected");
        };
        assert_eq!(
            error.to_string(),
            "cannot capture a query sequence; capture the desired nodes explicitly"
        );
    }

    #[test]
    fn rejects_duplicate_capture_names() {
        let result = parse_pattern(quote! {
            (assignment
                left: (_) @item
                right: (_) @item)
        });
        let Err(error) = result else {
            panic!("expected duplicate capture name to be rejected");
        };
        assert_eq!(
            error.to_string(),
            "capture `item` is used more than once; use a distinct name for each capture site"
        );
    }

    #[test]
    fn parses_literal_led_repeated_sequence() {
        let pattern = parse_pattern(quote!((root ("+" ",")*))).unwrap();
        let Pattern::Node { fields, .. } = pattern else {
            panic!("expected root node");
        };
        let Pattern::Sequence(children) = &fields[0].1 else {
            panic!("expected child sequence");
        };
        let Pattern::Repeated {
            pattern: repeated, ..
        } = &children[0]
        else {
            panic!("expected repetition");
        };
        assert!(matches!(
            repeated.as_ref(),
            Pattern::Sequence(patterns)
                if matches!(
                    patterns.as_slice(),
                    [Pattern::Unnamed(left), Pattern::Unnamed(right)]
                        if left == "+" && right == ","
                )
        ));
    }

    #[test]
    fn parses_wildcard_led_repeated_sequence() {
        let pattern = parse_pattern(quote!((root (_ ",")*))).unwrap();
        let Pattern::Node { fields, .. } = pattern else {
            panic!("expected root node");
        };
        let Pattern::Sequence(children) = &fields[0].1 else {
            panic!("expected child sequence");
        };
        let Pattern::Repeated {
            pattern: repeated, ..
        } = &children[0]
        else {
            panic!("expected repetition");
        };
        assert!(matches!(
            repeated.as_ref(),
            Pattern::Sequence(patterns)
                if matches!(
                    patterns.as_slice(),
                    [
                        Pattern::Any {
                            match_unnamed: true
                        },
                        Pattern::Unnamed(comma)
                    ] if comma == ","
                )
        ));
    }

    #[test]
    fn rejects_unconsumed_node_pattern_tokens() {
        for query in [quote!((root (foo . (bar) @x))), quote!((root(bar @ x)))] {
            let result = parse_pattern(query);
            let Err(error) = result else {
                panic!("expected malformed node pattern to be rejected");
            };
            assert!(error.to_string().starts_with("unexpected token"));
        }
    }
}

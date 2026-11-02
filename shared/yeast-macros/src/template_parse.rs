use proc_macro2::{Delimiter, Ident, Literal, Span, TokenStream, TokenTree};
use std::iter::Peekable;

use crate::ast::{Alternative, Content, Field, Node, Template};

type Tokens = Peekable<proc_macro2::token_stream::IntoIter>;
type Result<T> = std::result::Result<T, syn::Error>;

pub(crate) fn parse_template(input: TokenStream) -> Result<Template> {
    let mut tokens = input.into_iter().peekable();
    let template = parse_one(&mut tokens)?;
    if let Some(token) = tokens.next() {
        return Err(syn::Error::new_spanned(
            token,
            "unexpected tokens after tree! template; use trees! for multiple nodes",
        ));
    }
    Ok(template)
}

pub(crate) fn parse_templates(input: TokenStream) -> Result<Vec<Template>> {
    let mut tokens = input.into_iter().peekable();
    let templates = parse_list(&mut tokens)?;
    if let Some(token) = tokens.next() {
        return Err(syn::Error::new_spanned(
            token,
            "unexpected token after template",
        ));
    }
    Ok(templates)
}

fn parse_one(tokens: &mut Tokens) -> Result<Template> {
    match tokens.peek() {
        Some(TokenTree::Group(group)) if group.delimiter() == Delimiter::Brace => {
            let group = expect_group(tokens, Delimiter::Brace)?;
            Ok(Template::Splice(parse_block(group)?))
        }
        Some(TokenTree::Group(group)) if group.delimiter() == Delimiter::Parenthesis => {
            let group = expect_group(tokens, Delimiter::Parenthesis)?;
            Ok(Template::Node(parse_node(group)?))
        }
        Some(TokenTree::Group(group)) if group.delimiter() == Delimiter::Bracket => {
            let group = expect_group(tokens, Delimiter::Bracket)?;
            Ok(Template::Choice(parse_alternatives(group)?))
        }
        Some(token) => Err(syn::Error::new_spanned(
            token.clone(),
            "expected `(`, `{`, or `[` in tree template",
        )),
        None => Err(syn::Error::new(
            Span::call_site(),
            "unexpected end of tree template",
        )),
    }
}

fn parse_node(group: proc_macro2::Group) -> Result<Node> {
    let mut tokens = group.stream().into_iter().peekable();
    let kind = expect_ident(&mut tokens, "expected node kind")?;
    let content = if peek_is_literal(&mut tokens) {
        Some(Content::Static(expect_literal(&mut tokens)?))
    } else if peek_is_hash(&mut tokens) {
        tokens.next();
        Some(Content::Computed(parse_block(expect_group(
            &mut tokens,
            Delimiter::Brace,
        )?)?))
    } else {
        None
    };

    let mut fields = Vec::new();
    while peek_is_field(&mut tokens) {
        let name = expect_ident(&mut tokens, "expected field name")?;
        let is_location = name == "location";
        if content.is_some() && !is_location {
            return Err(syn::Error::new_spanned(
                name,
                "literal nodes can only have the special `location` field",
            ));
        }
        expect_punct(&mut tokens, ':', "expected `:` after field name")?;
        if is_location {
            if !peek_is_group(&mut tokens, Delimiter::Brace) {
                let error = match tokens.peek() {
                    Some(token) => syn::Error::new_spanned(
                        token.clone(),
                        "`location` field value must be a Rust block",
                    ),
                    None => syn::Error::new(
                        Span::call_site(),
                        "`location` field value must be a Rust block",
                    ),
                };
                return Err(error);
            }
            let block = parse_block(expect_group(&mut tokens, Delimiter::Brace)?)?;
            fields.push(Field::Location { block });
            continue;
        }

        let value = parse_one(&mut tokens)?;
        fields.push(Field::Named { name, value });
    }

    if let Some(token) = tokens.next() {
        return Err(syn::Error::new_spanned(
            token,
            "expected named field (`name:`) or end of node template; \
             output templates do not support unnamed children",
        ));
    }

    Ok(Node {
        kind,
        content,
        fields,
    })
}

fn parse_alternatives(group: proc_macro2::Group) -> Result<Vec<Alternative>> {
    let mut tokens = group.stream().into_iter().peekable();
    let mut alternatives = Vec::new();
    while tokens.peek().is_some() {
        if peek_is_group(&mut tokens, Delimiter::Bracket) {
            let nested = expect_group(&mut tokens, Delimiter::Bracket)?;
            return Err(syn::Error::new(
                nested.span(),
                "a choice cannot be used directly as another choice's alternative; \
                 list its alternatives directly in the enclosing choice",
            ));
        }
        let template = parse_one(&mut tokens)?;
        let guard = if peek_is_ident(&mut tokens, "if") {
            tokens.next();
            let group = expect_group(&mut tokens, Delimiter::Brace).map_err(|error| {
                syn::Error::new(
                    error.span(),
                    "expected `{ ... }` guard condition after `if`",
                )
            })?;
            Some(parse_block(group)?)
        } else {
            None
        };
        alternatives.push(Alternative { template, guard });
    }
    if alternatives.is_empty() {
        return Err(syn::Error::new(
            group.span(),
            "template choices must contain at least one alternative",
        ));
    }
    Ok(alternatives)
}

fn parse_list(tokens: &mut Tokens) -> Result<Vec<Template>> {
    let mut templates = Vec::new();
    while tokens.peek().is_some() {
        if peek_is_group(tokens, Delimiter::Parenthesis) {
            let group = expect_group(tokens, Delimiter::Parenthesis)?;
            if group.stream().is_empty() {
                continue;
            }
            templates.push(Template::Node(parse_node(group)?));
            continue;
        }

        if peek_is_group(tokens, Delimiter::Brace) {
            templates.push(Template::Splice(parse_block(expect_group(
                tokens,
                Delimiter::Brace,
            )?)?));
            continue;
        }

        if peek_is_group(tokens, Delimiter::Bracket) {
            templates.push(Template::Choice(parse_alternatives(expect_group(
                tokens,
                Delimiter::Bracket,
            )?)?));
            continue;
        }

        break;
    }
    Ok(templates)
}

fn parse_block(group: proc_macro2::Group) -> Result<syn::Block> {
    syn::parse2(TokenStream::from(TokenTree::Group(group)))
}

fn peek_is_literal(tokens: &mut Tokens) -> bool {
    matches!(tokens.peek(), Some(TokenTree::Literal(_)))
}

fn peek_is_hash(tokens: &mut Tokens) -> bool {
    matches!(tokens.peek(), Some(TokenTree::Punct(punctuation)) if punctuation.as_char() == '#')
}

fn peek_is_field(tokens: &mut Tokens) -> bool {
    matches!(tokens.peek(), Some(TokenTree::Ident(identifier)) if *identifier != "_")
}

fn peek_is_group(tokens: &mut Tokens, delimiter: Delimiter) -> bool {
    matches!(tokens.peek(), Some(TokenTree::Group(group)) if group.delimiter() == delimiter)
}

fn peek_is_ident(tokens: &mut Tokens, expected: &str) -> bool {
    matches!(tokens.peek(), Some(TokenTree::Ident(identifier)) if identifier == expected)
}

fn expect_ident(tokens: &mut Tokens, message: &str) -> Result<Ident> {
    match tokens.next() {
        Some(TokenTree::Ident(identifier)) => Ok(identifier),
        Some(token) => Err(syn::Error::new_spanned(token, message)),
        None => Err(syn::Error::new(Span::call_site(), message)),
    }
}

fn expect_literal(tokens: &mut Tokens) -> Result<Literal> {
    match tokens.next() {
        Some(TokenTree::Literal(literal)) => Ok(literal),
        Some(token) => Err(syn::Error::new_spanned(token, "expected string literal")),
        None => Err(syn::Error::new(
            Span::call_site(),
            "expected string literal",
        )),
    }
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
    fn parses_node_fields() {
        let template = parse_template(quote! {
            (call
                argument: {args}
                method: [(identifier #{name})])
        })
        .unwrap();

        let Template::Node(node) = template else {
            panic!("expected node template");
        };
        assert_eq!(node.kind, "call");
        assert!(node.content.is_none());
        assert_eq!(node.fields.len(), 2);
    }

    #[test]
    fn parses_location_fields_on_literal_nodes() {
        let template = parse_template(quote! {
            (identifier "name" location: {source})
        })
        .unwrap();

        let Template::Node(node) = template else {
            panic!("expected node template");
        };
        assert_eq!(node.kind, "identifier");
        assert!(node.content.is_some());
        assert!(matches!(node.fields.as_slice(), [Field::Location { .. }]));
    }

    #[test]
    fn rejects_non_block_location_fields() {
        let result = parse_template(quote! {
            (identifier "name" location: (identifier "source"))
        });
        let Err(error) = result else {
            panic!("expected a non-block location value to be rejected");
        };
        assert_eq!(
            error.to_string(),
            "`location` field value must be a Rust block"
        );
    }

    #[test]
    fn parses_choice_guards() {
        let template = parse_template(quote! {
            [
                (parameter type: {ty}) if { in_function_type }
                (argument value: {ty})
            ]
        })
        .unwrap();

        let Template::Choice(alternatives) = template else {
            panic!("expected template choice");
        };
        assert_eq!(alternatives.len(), 2);
        assert!(alternatives[0].guard.is_some());
        assert!(alternatives[1].guard.is_none());
    }

    #[test]
    fn rejects_empty_choices() {
        let result = parse_template(quote! { [] });
        let Err(error) = result else {
            panic!("expected empty choice to be rejected");
        };
        assert_eq!(
            error.to_string(),
            "template choices must contain at least one alternative"
        );
    }

    #[test]
    fn rejects_choice_as_direct_alternative() {
        let result = parse_template(quote! {
            [
                [(identifier "nested")]
                (identifier "fallback")
            ]
        });
        let Err(error) = result else {
            panic!("expected a direct nested choice to be rejected");
        };
        assert_eq!(
            error.to_string(),
            "a choice cannot be used directly as another choice's alternative; \
             list its alternatives directly in the enclosing choice"
        );
    }

    #[test]
    fn parses_lists_and_skips_empty_nodes() {
        let templates = parse_templates(quote! {
            (identifier "name")
            {extra}
            ()
        })
        .unwrap();
        assert_eq!(templates.len(), 2);
        assert!(matches!(templates[0], Template::Node(_)));
        assert!(matches!(templates[1], Template::Splice(_)));
    }

    #[test]
    fn rejects_named_fields_on_literal_nodes() {
        let result = parse_template(quote! {
            (identifier "name" child: (identifier "nested"))
        });
        let Err(error) = result else {
            panic!("expected literal node fields to be rejected");
        };
        assert_eq!(
            error.to_string(),
            "literal nodes can only have the special `location` field"
        );
    }
}

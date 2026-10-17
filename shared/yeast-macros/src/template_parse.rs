use proc_macro2::{Delimiter, Ident, Literal, Span, TokenStream, TokenTree};
use std::iter::Peekable;

use crate::ast::{Content, Field, Node, Template};

type Tokens = Peekable<proc_macro2::token_stream::IntoIter>;
type Result<T> = std::result::Result<T, syn::Error>;

pub(crate) fn parse_template(input: TokenStream) -> Result<Template> {
    let mut tokens = input.into_iter().peekable();
    let template = parse_one(&mut tokens)?;
    reject_stray_optional(&mut tokens, false)?;
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
        Some(token) => Err(syn::Error::new_spanned(
            token.clone(),
            "expected `(` or `{` in tree template",
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
        if content.is_some() {
            return Err(syn::Error::new_spanned(
                name,
                "literal nodes cannot have named fields",
            ));
        }
        expect_punct(&mut tokens, ':', "expected `:` after field name")?;
        let value = parse_one(&mut tokens)?;
        let optional = if matches!(value, Template::Splice(_)) {
            reject_stray_optional(&mut tokens, true)?;
            false
        } else if peek_is_punct(&mut tokens, '?') {
            tokens.next();
            true
        } else {
            false
        };
        fields.push(Field::Named {
            name,
            value,
            optional,
        });
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

fn parse_list(tokens: &mut Tokens) -> Result<Vec<Template>> {
    let mut templates = Vec::new();
    while tokens.peek().is_some() {
        if peek_is_group(tokens, Delimiter::Parenthesis) {
            let group = expect_group(tokens, Delimiter::Parenthesis)?;
            if group.stream().is_empty() {
                continue;
            }
            templates.push(Template::Node(parse_node(group)?));
            reject_stray_optional(tokens, false)?;
            continue;
        }

        if peek_is_group(tokens, Delimiter::Brace) {
            templates.push(Template::Splice(parse_block(expect_group(
                tokens,
                Delimiter::Brace,
            )?)?));
            reject_stray_optional(tokens, true)?;
            continue;
        }

        break;
    }
    Ok(templates)
}

fn reject_stray_optional(tokens: &mut Tokens, after_splice: bool) -> Result<()> {
    let Some(TokenTree::Punct(punctuation)) = tokens.peek() else {
        return Ok(());
    };
    if punctuation.as_char() != '?' {
        return Ok(());
    }
    let message = if after_splice {
        "`?` is not valid on a `{...}` splice; a splice that yields no value \
         already leaves its field unset"
    } else {
        "`?` is only valid on the value of a named field, as in \
         `label: (identifier #{lbl})?`"
    };
    Err(syn::Error::new_spanned(punctuation.clone(), message))
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

fn peek_is_punct(tokens: &mut Tokens, expected: char) -> bool {
    matches!(tokens.peek(), Some(TokenTree::Punct(punctuation)) if punctuation.as_char() == expected)
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
                method: (identifier #{name})?)
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
    fn rejects_fields_on_literal_nodes() {
        let result = parse_template(quote! {
            (identifier "name" child: (identifier "nested"))
        });
        let Err(error) = result else {
            panic!("expected literal node fields to be rejected");
        };
        assert_eq!(error.to_string(), "literal nodes cannot have named fields");
    }
}

use proc_macro2::{Span, TokenStream, TokenTree};
use quote::quote;
use syn::{
    parse::{Parse, ParseStream},
    Expr, Token,
};

type Result<T> = std::result::Result<T, syn::Error>;

pub fn parse_query_top(input: TokenStream) -> Result<TokenStream> {
    let pattern = crate::rule_parse::parse_pattern(input)?.lower();
    Ok(quote! {
        {
            let __pattern: yeast::query::QueryNode = #pattern;
            __pattern
        }
    })
}

pub fn parse_tree_top(input: TokenStream) -> Result<TokenStream> {
    let template = crate::template_parse::parse_template(input)?;
    let template = template.lower_root();
    Ok(quote!({ #template }))
}

pub fn parse_trees_top(input: TokenStream) -> Result<TokenStream> {
    let templates = crate::template_parse::parse_templates(input)?;
    Ok(crate::ast::Template::lower_list(&templates))
}

pub fn parse_tree_at_top(input: TokenStream) -> Result<TokenStream> {
    let LocatedTreeInput { source, template } = syn::parse2(input)?;
    let template = crate::template_parse::parse_template(template)?;
    let node = template.lower_root();
    let ctx = syn::Ident::new("ctx", Span::call_site());

    Ok(quote! {
        {
            let __yeast_source: yeast::Id = { #source };
            let __yeast_source_range = #ctx
                .ast
                .get_node(__yeast_source)
                .and_then(|node| node.source_range());
            let __yeast_node: yeast::Id = #node;
            #ctx.set_node_source_range(__yeast_node, __yeast_source_range)
        }
    })
}

pub fn parse_tree_spanning_top(input: TokenStream) -> Result<TokenStream> {
    let LocatedTreeInput {
        source: sources,
        template,
    } = syn::parse2(input)?;
    let template = crate::template_parse::parse_template(template)?;
    let node = template.lower_root();
    let ctx = syn::Ident::new("ctx", Span::call_site());

    Ok(quote! {
        {
            let __yeast_source_range = ::std::iter::IntoIterator::into_iter({ #sources })
                .filter_map(|source: yeast::Id| {
                    #ctx.ast.get_node(source).and_then(|node| node.source_range())
                })
                .reduce(yeast::Range::union);
            let __yeast_node: yeast::Id = #node;
            #ctx.set_node_source_range(__yeast_node, __yeast_source_range)
        }
    })
}

pub fn parse_rule_top(input: TokenStream) -> Result<TokenStream> {
    Ok(crate::rule_parse::parse_rule(input)?.lower())
}

pub fn parse_rules_top(input: TokenStream) -> Result<TokenStream> {
    let mut tokens = input.into_iter().peekable();
    let input_path = parse_named_string_arg(&mut tokens, "input")?;
    expect_punct(&mut tokens, ',', "expected `,` after input path")?;
    let output_path = parse_named_string_arg(&mut tokens, "output")?;
    expect_punct(&mut tokens, ',', "expected `,` after output path")?;

    let manifest_dir = std::env::var("CARGO_MANIFEST_DIR").map_err(|_| {
        syn::Error::new(
            Span::call_site(),
            "rules!: CARGO_MANIFEST_DIR is not set; cannot resolve schema paths",
        )
    })?;
    let resolve_path = |raw: &str| -> std::path::PathBuf {
        let path = std::path::PathBuf::from(raw);
        if path.is_absolute() {
            path
        } else {
            std::path::PathBuf::from(&manifest_dir).join(path)
        }
    };
    let input_abs = resolve_path(&input_path.value);
    let output_abs = resolve_path(&output_path.value);

    let list = expect_group(&mut tokens, proc_macro2::Delimiter::Bracket)?;
    if let Some(token) = tokens.next() {
        return Err(syn::Error::new_spanned(
            token,
            "unexpected token after `rules!` list",
        ));
    }

    let emitted_items = split_top_level_commas(list.stream())
        .into_iter()
        .map(|item| {
            if has_top_level_arrow(&item) {
                Ok(crate::rule_parse::parse_rule(item)?.lower())
            } else {
                Ok(item)
            }
        })
        .collect::<Result<Vec<_>>>()?;

    let input_lit = proc_macro2::Literal::string(&input_abs.to_string_lossy());
    let output_lit = proc_macro2::Literal::string(&output_abs.to_string_lossy());
    Ok(quote! {
        {
            const _: &::core::primitive::str = ::core::include_str!(#input_lit);
            const _: &::core::primitive::str = ::core::include_str!(#output_lit);
            vec![ #(#emitted_items),* ]
        }
    })
}

struct LocatedTreeInput {
    source: Expr,
    template: TokenStream,
}

impl Parse for LocatedTreeInput {
    fn parse(input: ParseStream<'_>) -> syn::Result<Self> {
        let source = input.parse()?;
        input.parse::<Token![,]>()?;
        let template = input.parse()?;
        Ok(Self { source, template })
    }
}

struct NamedString {
    value: String,
}

fn parse_named_string_arg(
    tokens: &mut std::iter::Peekable<proc_macro2::token_stream::IntoIter>,
    expected_name: &str,
) -> Result<NamedString> {
    let name = expect_ident(tokens, &format!("expected `{expected_name}:` argument"))?;
    if name != expected_name {
        return Err(syn::Error::new_spanned(
            name,
            format!("expected `{expected_name}:` argument"),
        ));
    }
    expect_punct(
        tokens,
        ':',
        &format!("expected `:` after `{expected_name}`"),
    )?;
    let literal = expect_literal(tokens)?;
    let value = string_literal_value(&literal).ok_or_else(|| {
        syn::Error::new(
            literal.span(),
            format!("`{expected_name}` must be a string literal path"),
        )
    })?;
    Ok(NamedString { value })
}

fn string_literal_value(literal: &proc_macro2::Literal) -> Option<String> {
    syn::parse2::<syn::LitStr>(TokenStream::from(TokenTree::Literal(literal.clone())))
        .ok()
        .map(|literal| literal.value())
}

fn split_top_level_commas(stream: TokenStream) -> Vec<TokenStream> {
    let mut items = Vec::new();
    let mut current = Vec::new();
    for token in stream {
        if matches!(&token, TokenTree::Punct(punctuation)
            if punctuation.as_char() == ','
                && punctuation.spacing() == proc_macro2::Spacing::Alone)
        {
            if !current.is_empty() {
                items.push(current.drain(..).collect());
            }
        } else {
            current.push(token);
        }
    }
    if !current.is_empty() {
        items.push(current.into_iter().collect());
    }
    items
}

fn has_top_level_arrow(stream: &TokenStream) -> bool {
    let tokens = stream.clone().into_iter().collect::<Vec<_>>();
    tokens.windows(2).any(|window| {
        matches!(
            window,
            [TokenTree::Punct(first), TokenTree::Punct(second)]
                if first.as_char() == '='
                    && first.spacing() == proc_macro2::Spacing::Joint
                    && second.as_char() == '>'
        )
    })
}

type Tokens = std::iter::Peekable<proc_macro2::token_stream::IntoIter>;

fn expect_ident(tokens: &mut Tokens, message: &str) -> Result<syn::Ident> {
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

fn expect_punct(tokens: &mut Tokens, expected: char, message: &str) -> Result<()> {
    match tokens.next() {
        Some(TokenTree::Punct(punctuation)) if punctuation.as_char() == expected => Ok(()),
        Some(token) => Err(syn::Error::new_spanned(token, message)),
        None => Err(syn::Error::new(Span::call_site(), message)),
    }
}

fn expect_group(
    tokens: &mut Tokens,
    delimiter: proc_macro2::Delimiter,
) -> Result<proc_macro2::Group> {
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
    fn recognizes_only_top_level_arrows() {
        assert!(has_top_level_arrow(&quote! { (a) => (b) }));
        assert!(!has_top_level_arrow(&quote! { rule!((a) => (b)) }));
        assert!(!has_top_level_arrow(&quote! { make_rule() }));
        assert!(!has_top_level_arrow(
            &quote! { { match x { 1 => 2, _ => 3 } } }
        ));
    }
}

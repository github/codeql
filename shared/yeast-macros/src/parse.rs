use proc_macro2::{Ident, Span, TokenStream, TokenTree};
use quote::quote;

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

pub fn parse_tree_with_schema_top(input: TokenStream) -> Result<TokenStream> {
    let mut tokens = input.into_iter().peekable();
    let output_path = parse_named_string_arg(&mut tokens, "output")?;
    expect_punct(&mut tokens, ',', "expected `,` after output schema path")?;
    let template_tokens: TokenStream = tokens.collect();
    let ctx = Ident::new(
        "ctx",
        first_leaf_span(template_tokens.clone()).unwrap_or_else(Span::call_site),
    );
    let template = crate::template_parse::parse_template(template_tokens)?;
    let template = template.lower_root(&ctx);
    let output_lit = proc_macro2::Literal::string(&output_path.value);
    Ok(quote!({
        const _: &::core::primitive::str = ::core::include_str!(#output_lit);
        #template
    }))
}

pub fn parse_trees_top(input: TokenStream) -> Result<TokenStream> {
    let templates = crate::template_parse::parse_templates(input)?;
    Ok(crate::ast::Template::lower_list(&templates))
}

pub fn parse_trees_with_schema_top(input: TokenStream) -> Result<TokenStream> {
    let mut tokens = input.into_iter().peekable();
    let output_path = parse_named_string_arg(&mut tokens, "output")?;
    expect_punct(&mut tokens, ',', "expected `,` after output schema path")?;
    let template_tokens: TokenStream = tokens.collect();
    let ctx = Ident::new(
        "ctx",
        first_leaf_span(template_tokens.clone()).unwrap_or_else(Span::call_site),
    );
    let templates = crate::template_parse::parse_templates(template_tokens)?;
    let templates = crate::ast::Template::lower_list(&templates, &ctx);
    let output_lit = proc_macro2::Literal::string(&output_path.value);
    Ok(quote!({
        const _: &::core::primitive::str = ::core::include_str!(#output_lit);
        #templates
    }))
}

pub fn parse_tree_schema_top(input: TokenStream) -> Result<TokenStream> {
    let mut tokens = input.into_iter().peekable();
    let module = expect_ident(&mut tokens, "expected schema module name")?;
    expect_punct(&mut tokens, ',', "expected `,` after schema module name")?;
    let output_path = parse_string_arg(&mut tokens, "schema")?;
    if tokens.peek().is_some() {
        expect_punct(&mut tokens, ',', "expected trailing `,`")?;
    }
    if let Some(token) = tokens.next() {
        return Err(syn::Error::new_spanned(
            token,
            "unexpected token after tree schema declaration",
        ));
    }

    let output_abs = resolve_manifest_path(&output_path, "tree_schema")?;
    let output_lit = proc_macro2::Literal::string(&output_abs.to_string_lossy());
    Ok(quote! {
        pub(crate) mod #module {
            #[allow(dead_code)]
            pub const SCHEMA: &str = ::core::include_str!(#output_lit);

            macro_rules! tree {
                ($($tokens:tt)*) => {
                    yeast::__tree_with_schema! {
                        output: #output_lit,
                        $($tokens)*
                    }
                };
            }
            pub(crate) use tree;

            macro_rules! trees {
                ($($tokens:tt)*) => {
                    yeast::__trees_with_schema! {
                        output: #output_lit,
                        $($tokens)*
                    }
                };
            }
            pub(crate) use trees;
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
    let output_yaml = std::fs::read_to_string(&output_abs).map_err(|error| {
        syn::Error::new(
            output_path.literal_span,
            format!(
                "rules!: failed to read output schema `{}`: {error}",
                output_abs.display()
            ),
        )
    })?;
    let output_leaf_kinds = yeast_schema::node_types_yaml::leaf_kinds_from_yaml(&output_yaml)
        .map_err(|error| {
            syn::Error::new(
                output_path.literal_span,
                format!(
                    "rules!: failed to parse output schema `{}`: {error}",
                    output_abs.display()
                ),
            )
        })?;

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
            let rule_body = if has_top_level_arrow(&item) {
                Some(item.clone())
            } else {
                explicit_rule_body(&item)
            };
            if let Some(rule_body) = rule_body {
                let mut rule = crate::rule_parse::parse_rule(rule_body)?;
                rule.resolve_bare_leaf_content(&output_leaf_kinds)?;
                Ok(rule.lower())
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

struct NamedString {
    value: String,
    literal_span: Span,
}

fn resolve_manifest_path(path: &NamedString, macro_name: &str) -> Result<std::path::PathBuf> {
    let manifest_dir = std::env::var("CARGO_MANIFEST_DIR").map_err(|_| {
        syn::Error::new(
            Span::call_site(),
            format!("{macro_name}!: CARGO_MANIFEST_DIR is not set; cannot resolve schema path"),
        )
    })?;
    let path = std::path::PathBuf::from(&path.value);
    Ok(if path.is_absolute() {
        path
    } else {
        std::path::PathBuf::from(manifest_dir).join(path)
    })
}

fn first_leaf_span(stream: TokenStream) -> Option<Span> {
    stream.into_iter().find_map(|token| match token {
        TokenTree::Group(group) => first_leaf_span(group.stream()),
        token => Some(token.span()),
    })
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
    parse_string_arg(tokens, expected_name)
}

fn parse_string_arg(
    tokens: &mut std::iter::Peekable<proc_macro2::token_stream::IntoIter>,
    description: &str,
) -> Result<NamedString> {
    let literal = expect_literal(tokens)?;
    let value = string_literal_value(&literal).ok_or_else(|| {
        syn::Error::new(
            literal.span(),
            format!("`{description}` must be a string literal path"),
        )
    })?;
    Ok(NamedString {
        value,
        literal_span: literal.span(),
    })
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

fn explicit_rule_body(stream: &TokenStream) -> Option<TokenStream> {
    let expression = syn::parse2::<syn::ExprMacro>(stream.clone()).ok()?;
    let is_rule = expression
        .mac
        .path
        .segments
        .last()
        .is_some_and(|segment| segment.ident == "rule");
    is_rule.then_some(expression.mac.tokens)
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

    #[test]
    fn recognizes_explicit_rule_macros() {
        assert!(explicit_rule_body(&quote! { rule!((a) => (b)) }).is_some());
        assert!(explicit_rule_body(&quote! { yeast::rule!((a) => (b)) }).is_some());
        assert!(explicit_rule_body(&quote! { other!((a) => (b)) }).is_none());
        assert!(explicit_rule_body(&quote! { make_rule() }).is_none());
    }
}

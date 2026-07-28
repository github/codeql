use proc_macro2::{Delimiter, Ident, Literal, Span, TokenStream, TokenTree};
use quote::quote;
use std::iter::Peekable;

type Tokens = Peekable<proc_macro2::token_stream::IntoIter>;
type Result<T> = std::result::Result<T, syn::Error>;

// ---------------------------------------------------------------------------
// Query parsing
// ---------------------------------------------------------------------------

/// Top-level entry: parse a single query node from the full input.
pub fn parse_query_top(input: TokenStream) -> Result<TokenStream> {
    let mut tokens = input.into_iter().peekable();
    let result = parse_query_node(&mut tokens)?;
    if let Some(tok) = tokens.next() {
        return Err(syn::Error::new_spanned(tok, "unexpected token after query"));
    }
    Ok(result)
}

/// Parse a single query node (possibly with a trailing `@capture`).
fn parse_query_node(tokens: &mut Tokens) -> Result<TokenStream> {
    let base = parse_query_atom(tokens)?;
    // Check for trailing @capture or @@capture
    if peek_is_at(tokens) {
        let capture_name = consume_capture_marker(tokens)?;
        let name_str = capture_name.to_string();
        Ok(quote! {
            yeast::query::QueryNode::Capture {
                capture: #name_str,
                node: Box::new(#base),
            }
        })
    } else {
        Ok(base)
    }
}

/// Parse a query atom: a parenthesized node, a bare `_` (any node), or a
/// bare string literal (unnamed token).
/// Does not handle `@capture` — that's handled by the caller as a postfix.
fn parse_query_atom(tokens: &mut Tokens) -> Result<TokenStream> {
    match tokens.peek() {
        None => Err(syn::Error::new(
            Span::call_site(),
            "unexpected end of query",
        )),
        Some(TokenTree::Group(g)) if g.delimiter() == Delimiter::Parenthesis => {
            let group = expect_group(tokens, Delimiter::Parenthesis)?;
            let mut inner = group.stream().into_iter().peekable();
            let result = parse_query_node_inner(&mut inner)?;
            if let Some(tok) = inner.next() {
                return Err(syn::Error::new_spanned(
                    tok,
                    "unexpected token in query node",
                ));
            }
            Ok(result)
        }
        Some(TokenTree::Ident(id)) if *id == "_" => {
            tokens.next();
            Ok(quote! { yeast::query::QueryNode::Any { match_unnamed: true } })
        }
        Some(TokenTree::Literal(_)) => {
            let lit = expect_literal(tokens)?;
            Ok(quote! { yeast::query::QueryNode::UnnamedNode { kind: #lit } })
        }
        Some(tok) => Err(syn::Error::new_spanned(
            tok.clone(),
            "expected `(`, `_`, or string literal in query",
        )),
    }
}

/// Parse the inside of a parenthesized query node: `kind fields...` or `_` or `"lit"`.
fn parse_query_node_inner(tokens: &mut Tokens) -> Result<TokenStream> {
    match tokens.peek() {
        None => Err(syn::Error::new(
            Span::call_site(),
            "empty parenthesized group in query",
        )),
        Some(TokenTree::Ident(id)) if *id == "_" => {
            tokens.next();
            Ok(quote! { yeast::query::QueryNode::Any { match_unnamed: false } })
        }
        Some(TokenTree::Literal(_)) => {
            let lit = expect_literal(tokens)?;
            Ok(quote! { yeast::query::QueryNode::UnnamedNode { kind: #lit } })
        }
        Some(TokenTree::Ident(_)) => {
            let kind = expect_ident(tokens, "expected node kind")?;
            let kind_str = kind.to_string();
            let fields = parse_query_fields(tokens)?;
            Ok(quote! {
                yeast::query::QueryNode::Node {
                    kind: #kind_str,
                    children: vec![#(#fields),*],
                }
            })
        }
        Some(tok) => Err(syn::Error::new_spanned(
            tok.clone(),
            "expected node kind, `_`, or string literal",
        )),
    }
}

/// Parse zero or more field specifications and bare patterns.
/// Named fields: `name: pattern`. Bare patterns (no field name) become
/// implicit `child` field entries. Named fields and bare patterns may
/// appear in any order; bare patterns are accumulated and emitted as a
/// single `("child", ...)` entry.
fn parse_query_fields(tokens: &mut Tokens) -> Result<Vec<TokenStream>> {
    // Accumulate per-field elems in declaration order; multiple uses of the
    // same field name extend the same list (so e.g. `cond: (foo) cond: (bar)`
    // matches a `cond` field whose first child is `foo` and second is `bar`).
    let mut field_order: Vec<String> = Vec::new();
    let mut field_elems: std::collections::HashMap<String, Vec<TokenStream>> =
        std::collections::HashMap::new();
    let mut bare_children: Vec<TokenStream> = Vec::new();
    let push_field_elem = |order: &mut Vec<String>,
                           map: &mut std::collections::HashMap<String, Vec<TokenStream>>,
                           name: String,
                           elem: TokenStream| {
        if !map.contains_key(&name) {
            order.push(name.clone());
            map.insert(name, vec![elem]);
        } else {
            map.get_mut(&name).unwrap().push(elem);
        }
    };
    while tokens.peek().is_some() {
        if peek_is_field(tokens) {
            let field_name = expect_ident(tokens, "expected field name")?;
            let field_str = field_name.to_string();

            expect_punct(tokens, ':', "expected `:` after field name")?;

            // Parse the field's pattern. To support repetition like
            // `field: (kind)* @cap`, parse the atom first, then check for
            // a quantifier, and lastly handle a trailing `@capture`.
            // `field: @cap` is sugar for `field: _ @cap`.
            let atom = if peek_is_at(tokens) {
                quote! { yeast::query::QueryNode::Any { match_unnamed: true } }
            } else {
                parse_query_atom(tokens)?
            };
            if peek_is_repetition(tokens) {
                let rep = expect_repetition(tokens)?;
                let elem = quote! {
                    yeast::query::QueryListElem::Repeated {
                        children: vec![yeast::query::QueryListElem::SingleNode(#atom)],
                        rep: #rep,
                    }
                };
                let elem = maybe_wrap_list_capture(tokens, elem)?;
                push_field_elem(&mut field_order, &mut field_elems, field_str, elem);
            } else {
                let child = if peek_is_at(tokens) {
                    let capture_name = consume_capture_marker(tokens)?;
                    let name_str = capture_name.to_string();
                    quote! {
                        yeast::query::QueryNode::Capture {
                            capture: #name_str,
                            node: Box::new(#atom),
                        }
                    }
                } else {
                    atom
                };
                let elem = quote! {
                    yeast::query::QueryListElem::SingleNode(#child)
                };
                push_field_elem(&mut field_order, &mut field_elems, field_str, elem);
            }
        } else {
            // Bare patterns — accumulate into the implicit `child` field.
            // We don't break here, so we can interleave with named fields.
            let elems = parse_query_list(tokens)?;
            if elems.is_empty() {
                // Nothing more we can parse at this level.
                break;
            }
            bare_children.extend(elems);
        }
    }
    let mut fields: Vec<TokenStream> = Vec::new();
    for name in field_order {
        let elems = field_elems.remove(&name).unwrap();
        fields.push(quote! {
            (#name, vec![#(#elems),*])
        });
    }
    if !bare_children.is_empty() {
        fields.push(quote! {
            ("child", vec![#(#bare_children),*])
        });
    }
    Ok(fields)
}

/// Parse a list of query elements (bare children).
/// Each element is a node pattern, possibly followed by `*`, `+`, `?`.
fn parse_query_list(tokens: &mut Tokens) -> Result<Vec<TokenStream>> {
    let mut elems = Vec::new();
    while tokens.peek().is_some() {
        // Check for parenthesized group
        if peek_is_group(tokens, Delimiter::Parenthesis) {
            let group = expect_group(tokens, Delimiter::Parenthesis)?;
            let mut inner = group.stream().into_iter().peekable();

            // Check for repetition after the group
            if peek_is_repetition(tokens) {
                let rep = expect_repetition(tokens)?;
                // Determine if the group is a single node pattern or a list
                // of patterns. If it starts with an identifier (node kind) or
                // `_`, treat it as a single repeated node. Otherwise, parse
                // as a repeated list of sub-patterns.
                let is_single_node = matches!(inner.peek(), Some(TokenTree::Ident(_)));
                if is_single_node {
                    let node = parse_query_node_inner(&mut inner)?;
                    let elem = quote! {
                        yeast::query::QueryListElem::Repeated {
                            children: vec![yeast::query::QueryListElem::SingleNode(#node)],
                            rep: #rep,
                        }
                    };
                    let elem = maybe_wrap_list_capture(tokens, elem)?;
                    elems.push(elem);
                } else {
                    let sub_elems = parse_query_list(&mut inner)?;
                    let elem = quote! {
                        yeast::query::QueryListElem::Repeated {
                            children: vec![#(#sub_elems),*],
                            rep: #rep,
                        }
                    };
                    let elem = maybe_wrap_list_capture(tokens, elem)?;
                    elems.push(elem);
                }
            } else {
                // Single parenthesized node, possibly followed by @capture
                let node = parse_query_node_inner(&mut inner)?;
                let node = maybe_wrap_capture(tokens, node)?;
                elems.push(quote! {
                    yeast::query::QueryListElem::SingleNode(#node)
                });
            }
            continue;
        }

        // Check for string literal (unnamed node), optionally followed by @capture
        if peek_is_literal(tokens) {
            let lit = expect_literal(tokens)?;
            let node = quote! { yeast::query::QueryNode::UnnamedNode { kind: #lit } };
            let node = maybe_wrap_capture(tokens, node)?;
            let elem = maybe_wrap_repetition(
                tokens,
                quote! {
                    yeast::query::QueryListElem::SingleNode(#node)
                },
            )?;
            let elem = maybe_wrap_list_capture(tokens, elem)?;
            elems.push(elem);
            continue;
        }

        // Check for bare `_` (any node, named or unnamed), possibly followed by @capture.
        // Distinct from `(_)` which only matches named nodes — this matches
        // tree-sitter query semantics.
        if peek_is_underscore(tokens) {
            tokens.next();
            let node = quote! { yeast::query::QueryNode::Any { match_unnamed: true } };
            let node = maybe_wrap_capture(tokens, node)?;
            let elem = maybe_wrap_repetition(
                tokens,
                quote! {
                    yeast::query::QueryListElem::SingleNode(#node)
                },
            )?;
            let elem = maybe_wrap_list_capture(tokens, elem)?;
            elems.push(elem);
            continue;
        }

        break;
    }
    Ok(elems)
}

// ---------------------------------------------------------------------------
// tree! / trees! parsing — direct code generation against BuildCtx
// ---------------------------------------------------------------------------

const IMPLICIT_CTX: &str = "ctx";

/// Determine the context identifier: either explicit `ctx,` or the implicit
/// `ctx` from an enclosing `rule!`.
fn parse_ctx_or_implicit(tokens: &mut Tokens) -> Ident {
    // Check if first token is an ident followed by a comma
    let mut lookahead = tokens.clone();
    let is_explicit = matches!(lookahead.next(), Some(TokenTree::Ident(_)))
        && matches!(lookahead.next(), Some(TokenTree::Punct(p)) if p.as_char() == ',');

    if is_explicit {
        let ctx = expect_ident(tokens, "unreachable: ident was just peeked")
            .expect("unreachable: ident was just peeked");
        let _ = tokens.next(); // consume comma
        ctx
    } else {
        Ident::new(IMPLICIT_CTX, Span::call_site())
    }
}

/// Parse `tree!(ctx, (template))` or `tree!((template))` — returns single `Id`.
pub fn parse_tree_top(input: TokenStream) -> Result<TokenStream> {
    let mut tokens = input.into_iter().peekable();
    let ctx = parse_ctx_or_implicit(&mut tokens);

    let first = parse_direct_node(&mut tokens, &ctx)?;

    if let Some(tok) = tokens.next() {
        return Err(syn::Error::new_spanned(
            tok,
            "unexpected tokens after tree! template; use trees! for multiple nodes",
        ));
    }

    Ok(quote! { { #first } })
}

/// Parse `trees!(ctx, ...)` or `trees!(...)` — returns `Vec<Id>`.
pub fn parse_trees_top(input: TokenStream) -> Result<TokenStream> {
    let mut tokens = input.into_iter().peekable();
    let ctx = parse_ctx_or_implicit(&mut tokens);
    let items = parse_direct_list(&mut tokens, &ctx)?;
    if let Some(tok) = tokens.next() {
        return Err(syn::Error::new_spanned(
            tok,
            "unexpected token after trees! template",
        ));
    }
    Ok(quote! {
        {
            let mut __nodes: Vec<yeast::Id> = Vec::new();
            #(#items)*
            __nodes
        }
    })
}

/// Parse a single node template and generate code that returns an `Id`.
/// Handles: `(kind fields... children...)` and `{expr}`.
fn parse_direct_node(tokens: &mut Tokens, ctx: &Ident) -> Result<TokenStream> {
    match tokens.peek() {
        Some(TokenTree::Group(g)) if g.delimiter() == Delimiter::Brace => {
            let group = expect_group(tokens, Delimiter::Brace)?;
            let expr = group.stream();
            Ok(quote! { ::std::convert::Into::<yeast::Id>::into({ #expr }) })
        }
        Some(TokenTree::Group(g)) if g.delimiter() == Delimiter::Parenthesis => {
            let group = expect_group(tokens, Delimiter::Parenthesis)?;
            let mut inner = group.stream().into_iter().peekable();
            parse_direct_node_inner(&mut inner, ctx)
        }
        Some(tok) => Err(syn::Error::new_spanned(
            tok.clone(),
            "expected `(` or `{` in tree template",
        )),
        None => Err(syn::Error::new(
            Span::call_site(),
            "unexpected end of tree template",
        )),
    }
}

/// Parse the inside of a parenthesized node: `kind fields... children...`
/// or `kind "literal"` or `kind $fresh`.
fn parse_direct_node_inner(tokens: &mut Tokens, ctx: &Ident) -> Result<TokenStream> {
    let kind = expect_ident(tokens, "expected node kind")?;
    let kind_str = kind.to_string();

    // Check for (kind "literal")
    if peek_is_literal(tokens) {
        let lit = expect_literal(tokens)?;
        return Ok(quote! { #ctx.literal(#kind_str, #lit) });
    }

    // Check for (kind #{expr}) — computed literal, expr converted via YeastDisplay
    if peek_is_hash(tokens) {
        tokens.next(); // consume #
        let group = expect_group(tokens, Delimiter::Brace)?;
        let expr = group.stream();
        return Ok(quote! {
            {
                let __expr = { #expr };
                let __value = yeast::YeastDisplay::yeast_to_string(&__expr, &*#ctx.ast);
                let __source_range = yeast::YeastSourceRange::yeast_source_range(&__expr, &*#ctx.ast);
                #ctx.literal_with_source_range(#kind_str, &__value, __source_range)
            }
        });
    }

    // Check for (kind $fresh)
    if peek_is_dollar(tokens) {
        tokens.next();
        let name = expect_ident(tokens, "expected fresh variable name after $")?;
        let name_str = name.to_string();
        return Ok(quote! { #ctx.fresh(#kind_str, #name_str) });
    }

    // Parse named fields
    let mut stmts = Vec::new();
    let mut field_args = Vec::new();
    let mut field_counter = 0usize;

    // Named fields — compute each value into a temp, then reference it
    while peek_is_field(tokens) {
        let field_name = expect_ident(tokens, "expected field name")?;
        let field_str = field_name
            .to_string()
            .strip_prefix("r#")
            .unwrap_or(&field_name.to_string())
            .to_string();
        expect_punct(tokens, ':', "expected `:` after field name")?;
        let temp = Ident::new(
            &format!("__field_{field_str}_{field_counter}"),
            Span::call_site(),
        );
        field_counter += 1;

        // Plain `field: {expr}` — trait-dispatched extend.
        if peek_is_group(tokens, Delimiter::Brace) {
            let group = expect_group(tokens, Delimiter::Brace)?;
            let expr = group.stream();
            stmts.push(quote! {
                let mut #temp: Vec<yeast::Id> = Vec::new();
                yeast::IntoFieldIds::extend_into({ #expr }, &mut #temp);
            });
            // An empty `{expr}` means the field is absent — skip it
            // entirely rather than emitting an empty named field.
            field_args.push(quote! {
                if !#temp.is_empty() { __fields.push((#field_str, #temp)); }
            });
            continue;
        }

        let value = parse_direct_node(tokens, ctx)?;
        stmts.push(quote! { let #temp: yeast::Id = #value; });
        field_args.push(quote! { __fields.push((#field_str, vec![#temp])); });
    }

    // After all named fields, no other tokens are allowed.
    // Output templates require all children to be in named fields.
    if let Some(tok) = tokens.peek() {
        return Err(syn::Error::new_spanned(
            tok.clone(),
            "expected named field (`name:`) or end of node template; \
             output templates do not support unnamed children",
        ));
    }

    Ok(quote! {
        {
            #(#stmts)*
            let mut __fields: Vec<(&str, Vec<yeast::Id>)> = Vec::new();
            #(#field_args)*
            #ctx.node(#kind_str, __fields)
        }
    })
}

/// Parse the top-level list of a `trees!` template.
/// Each item is a node template or `{expr}` splice.
fn parse_direct_list(tokens: &mut Tokens, ctx: &Ident) -> Result<Vec<TokenStream>> {
    let mut items = Vec::new();
    while tokens.peek().is_some() {
        if peek_is_group(tokens, Delimiter::Parenthesis) {
            let group = expect_group(tokens, Delimiter::Parenthesis)?;
            let mut inner = group.stream().into_iter().peekable();

            // Empty `()` represents an empty sequence — emit nothing.
            if inner.peek().is_none() {
                continue;
            }

            // Regular node
            let node = parse_direct_node_inner(&mut inner, ctx)?;
            items.push(quote! { __nodes.push(#node); });
            continue;
        }

        // `{expr}` — extend `__nodes` via `IntoFieldIds`, which handles
        // single ids and iterables uniformly.
        if peek_is_group(tokens, Delimiter::Brace) {
            let group = expect_group(tokens, Delimiter::Brace)?;
            let expr = group.stream();
            items.push(quote! {
                yeast::IntoFieldIds::extend_into({ #expr }, &mut __nodes);
            });
            continue;
        }

        break;
    }
    Ok(items)
}

// ---------------------------------------------------------------------------
// rule! parsing
// ---------------------------------------------------------------------------

/// A captured variable from a query pattern.
struct CaptureInfo {
    name: String,
    multiplicity: CaptureMultiplicity,
    /// `true` for `@@name` captures: the auto-translate prefix skips them,
    /// so the bound `Id` refers to the raw (input-schema) node.
    raw: bool,
}

#[derive(Clone, Copy, PartialEq)]
enum CaptureMultiplicity {
    /// Exactly one match (bare pattern or after no quantifier)
    Single,
    /// Zero or one match (after `?`)
    Optional,
    /// Zero or more matches (after `*` or `+`, or inside a repeated group)
    Repeated,
}

/// Walk a token stream and extract all `@name` captures, noting whether
/// they appear after `*` or `+` (repeated) or not.
fn extract_captures(stream: &TokenStream) -> Vec<CaptureInfo> {
    let mut captures = Vec::new();
    extract_captures_inner(
        &mut stream.clone().into_iter().peekable(),
        &mut captures,
        CaptureMultiplicity::Single,
    );
    captures
}

fn extract_captures_inner(
    tokens: &mut Tokens,
    captures: &mut Vec<CaptureInfo>,
    parent_mult: CaptureMultiplicity,
) {
    let mut last_mult = CaptureMultiplicity::Single;
    while let Some(tok) = tokens.next() {
        match tok {
            TokenTree::Group(g) => {
                let mut inner = g.stream().into_iter().peekable();
                let group_mult = match tokens.peek() {
                    Some(TokenTree::Punct(p)) if p.as_char() == '*' || p.as_char() == '+' => {
                        CaptureMultiplicity::Repeated
                    }
                    Some(TokenTree::Punct(p)) if p.as_char() == '?' => {
                        CaptureMultiplicity::Optional
                    }
                    _ => CaptureMultiplicity::Single,
                };
                last_mult = group_mult;
                let child_mult = if parent_mult == CaptureMultiplicity::Repeated
                    || group_mult == CaptureMultiplicity::Repeated
                {
                    CaptureMultiplicity::Repeated
                } else if parent_mult == CaptureMultiplicity::Optional
                    || group_mult == CaptureMultiplicity::Optional
                {
                    CaptureMultiplicity::Optional
                } else {
                    CaptureMultiplicity::Single
                };
                extract_captures_inner(&mut inner, captures, child_mult);
            }
            TokenTree::Punct(p) if p.as_char() == '@' => {
                // `@@name` marks the capture as raw (skip auto-translate).
                let raw = matches!(
                    tokens.peek(),
                    Some(TokenTree::Punct(p)) if p.as_char() == '@'
                );
                if raw {
                    tokens.next(); // consume the second `@`
                }
                if let Some(TokenTree::Ident(name)) = tokens.next() {
                    let mult = if parent_mult == CaptureMultiplicity::Repeated
                        || last_mult == CaptureMultiplicity::Repeated
                    {
                        CaptureMultiplicity::Repeated
                    } else if parent_mult == CaptureMultiplicity::Optional
                        || last_mult == CaptureMultiplicity::Optional
                    {
                        CaptureMultiplicity::Optional
                    } else {
                        CaptureMultiplicity::Single
                    };
                    captures.push(CaptureInfo {
                        name: name.to_string(),
                        multiplicity: mult,
                        raw,
                    });
                }
                last_mult = CaptureMultiplicity::Single;
            }
            TokenTree::Punct(p) if p.as_char() == '*' || p.as_char() == '+' => {
                last_mult = CaptureMultiplicity::Repeated;
            }
            TokenTree::Punct(p) if p.as_char() == '?' => {
                last_mult = CaptureMultiplicity::Optional;
            }
            _ => {
                last_mult = CaptureMultiplicity::Single;
            }
        }
    }
}

/// A rule's return-type annotation, when the body is a Rust block. Written
/// between `=>` and the block body using the schema's own vocabulary:
///
/// ```text
///   => kind        { … }   // single node of that kind
///   => kind?       { … }   // Option<KindId> (0 or 1)
///   => kind*       { … }   // Vec<KindId>    (0+)
/// ```
///
/// Template bodies (`=> (kind …)`) never carry an annotation — the
/// output kind is the template root. The shorthand `=> kind` (no
/// body) also carries no annotation. See `parse_rule_top` for dispatch.
#[derive(Clone, Debug)]
struct ReturnAnnotation {
    kind: Ident,
    multiplicity: AnnotationMultiplicity,
}

#[derive(Clone, Copy, Debug, PartialEq)]
enum AnnotationMultiplicity {
    Single,
    Optional,
    Repeated,
}

/// Peek at the token stream to decide whether the transform following
/// `=>` is a **new** annotation form (`kind [? | *] { … }`). If so,
/// consume the annotation and return it, leaving the `{ … }` body in
/// the stream for the caller to parse. Otherwise leave the stream
/// untouched and return `None`.
///
/// The lookahead distinguishes:
///   `kind {`   → annotation (single)
///   `kind? {`  → annotation (optional)
///   `kind* {`  → annotation (repeated)
///   `kind`     → shorthand form (no `{` follows) — NOT an annotation
///   anything else → template or bare block — NOT an annotation
fn try_consume_return_annotation(tokens: &mut Tokens) -> Result<Option<ReturnAnnotation>> {
    // Must start with an identifier (the kind name).
    let mut lookahead = tokens.clone();
    let Some(TokenTree::Ident(_)) = lookahead.next() else {
        return Ok(None);
    };
    // Then optionally `?` or `*`, then a `{` group.
    let after_suffix = match lookahead.peek() {
        Some(TokenTree::Punct(p)) if p.as_char() == '?' || p.as_char() == '*' => {
            lookahead.next();
            lookahead.peek()
        }
        other => other,
    };
    if !matches!(after_suffix, Some(TokenTree::Group(g)) if g.delimiter() == Delimiter::Brace) {
        return Ok(None);
    }
    // Commit: consume the ident + suffix from the real stream.
    let kind = expect_ident(tokens, "expected output-kind name in annotation")?;
    let multiplicity = match tokens.peek() {
        Some(TokenTree::Punct(p)) if p.as_char() == '?' => {
            tokens.next();
            AnnotationMultiplicity::Optional
        }
        Some(TokenTree::Punct(p)) if p.as_char() == '*' => {
            tokens.next();
            AnnotationMultiplicity::Repeated
        }
        _ => AnnotationMultiplicity::Single,
    };
    Ok(Some(ReturnAnnotation { kind, multiplicity }))
}

/// Parse `rule!( query => transform )`.
pub fn parse_rule_top(input: TokenStream) -> Result<TokenStream> {
    let mut tokens = input.into_iter().peekable();

    // Collect query tokens up to `=>`
    let mut query_tokens = Vec::new();
    loop {
        match tokens.peek() {
            None => return Err(syn::Error::new(Span::call_site(), "expected `=>` in rule!")),
            Some(TokenTree::Punct(p)) if p.as_char() == '=' => {
                let eq = tokens.next().unwrap();
                match tokens.peek() {
                    Some(TokenTree::Punct(p)) if p.as_char() == '>' => {
                        tokens.next(); // consume >
                        break;
                    }
                    _ => {
                        query_tokens.push(eq);
                        continue;
                    }
                }
            }
            _ => {
                query_tokens.push(tokens.next().unwrap());
            }
        }
    }

    let query_stream: TokenStream = query_tokens.into_iter().collect();

    // Extract captures from query
    let captures = extract_captures(&query_stream);

    // Parse query
    let query_code = parse_query_top(query_stream.clone())?;

    // Capture names marked `@@name` (raw) — passed to the auto-translate
    // prefix as a skip list so those captures keep their input-schema ids.
    let raw_capture_names: Vec<&str> = captures
        .iter()
        .filter(|c| c.raw)
        .map(|c| c.name.as_str())
        .collect();

    // Generate capture bindings
    let ctx_ident = Ident::new(IMPLICIT_CTX, Span::call_site());
    let bindings: Vec<TokenStream> = captures
        .iter()
        .map(|cap| {
            let name = Ident::new(&cap.name, Span::call_site());
            let name_str = &cap.name;
            match cap.multiplicity {
                CaptureMultiplicity::Repeated => {
                    quote! {
                        let #name: Vec<yeast::Id> = __captures.get_all(#name_str);
                    }
                }
                CaptureMultiplicity::Optional => {
                    quote! {
                        let #name: Option<yeast::Id> = __captures.get_opt(#name_str);
                    }
                }
                CaptureMultiplicity::Single => {
                    quote! {
                        let #name: yeast::Id = __captures.get_var(#name_str).unwrap();
                    }
                }
            }
        })
        .collect();

    // Parse transform: the token(s) after `=>` fall into one of three
    // shapes, dispatched in order:
    //
    //   1. `kind [? | *] { rust_body }` — annotated Rust body (NEW).
    //      Static-analysis-ready: the annotation declares the output
    //      kind and multiplicity in the schema's own vocabulary.
    //   2. `kind` alone — shorthand: emit `(kind field: {@cap})…` from
    //      the query's captures.
    //   3. anything else — full template form (`(kind …)` or bare
    //      `{ … }` splice via `parse_direct_list`).
    let annotation = try_consume_return_annotation(&mut tokens)?;

    let transform_body = if let Some(annotation) = annotation {
        // Annotation form: `=> kind [? | *] { rust_body }`.
        let body_group = expect_group(&mut tokens, Delimiter::Brace)?;
        if let Some(tok) = tokens.next() {
            return Err(syn::Error::new_spanned(
                tok,
                "unexpected token after annotated rule body",
            ));
        }
        let body = body_group.stream();
        // The annotation is not yet consumed by codegen — it will drive
        // typed handles once the schema-driven codegen lands. For now,
        // emit a self-documenting reference to the annotated kind and
        // preserve today's `Vec<yeast::Id>` closure return so behavior
        // is unchanged.
        let kind_str = annotation.kind.to_string();
        let mult_str = match annotation.multiplicity {
            AnnotationMultiplicity::Single => "single",
            AnnotationMultiplicity::Optional => "optional",
            AnnotationMultiplicity::Repeated => "repeated",
        };
        let _ = (kind_str, mult_str); // silence unused warnings until wired

        // For now, adapt the user's typed return value to the framework's
        // `Vec<yeast::Id>` closure result. This uses `IntoFieldIds`, which
        // already accepts a bare `Id`, an iterable of ids, or `Option<Id>`
        // — matching the three annotation multiplicities.
        quote! {
            let __value = { #body };
            let mut __ids: Vec<yeast::Id> = Vec::new();
            yeast::IntoFieldIds::extend_into(__value, &mut __ids);
            __ids
        }
    } else if peek_is_field(&mut tokens) && {
        // Shorthand form: bare identifier = output node kind.
        // Auto-generate template from captures.
        let mut lookahead = tokens.clone();
        lookahead.next(); // skip ident
        lookahead.peek().is_none() // nothing after = shorthand
    } {
        let output_kind = expect_ident(&mut tokens, "expected output node kind")?;
        let output_kind_str = output_kind.to_string();

        // Generate field assignments from captures
        let field_stmts: Vec<TokenStream> = captures
            .iter()
            .map(|cap| {
                let name = Ident::new(&cap.name, Span::call_site());
                let name_str = &cap.name;
                match cap.multiplicity {
                    CaptureMultiplicity::Repeated => quote! {
                        let __field_id = #ctx_ident.ast.field_id_for_name(#name_str)
                            .unwrap_or_else(|| panic!("field '{}' not found", #name_str));
                        __fields.insert(
                            __field_id,
                            #name.into_iter()
                                .map(::std::convert::Into::<yeast::Id>::into)
                                .collect(),
                        );
                    },
                    CaptureMultiplicity::Optional => quote! {
                        let __field_id = #ctx_ident.ast.field_id_for_name(#name_str)
                            .unwrap_or_else(|| panic!("field '{}' not found", #name_str));
                        if let Some(__id) = #name {
                            __fields.entry(__field_id).or_insert_with(Vec::new)
                                .push(::std::convert::Into::<yeast::Id>::into(__id));
                        }
                    },
                    CaptureMultiplicity::Single => quote! {
                        let __field_id = #ctx_ident.ast.field_id_for_name(#name_str)
                            .unwrap_or_else(|| panic!("field '{}' not found", #name_str));
                        __fields.entry(__field_id).or_insert_with(Vec::new)
                            .push(::std::convert::Into::<yeast::Id>::into(#name));
                    },
                }
            })
            .collect();

        quote! {
            let __kind = #ctx_ident.ast.id_for_node_kind(#output_kind_str)
                .unwrap_or_else(|| panic!("node kind '{}' not found", #output_kind_str));
            let mut __fields = std::collections::BTreeMap::new();
            #(#field_stmts)*
            let __id = #ctx_ident.ast.create_node_with_range(
                __kind,
                yeast::NodeContent::DynamicString(String::new()),
                __fields,
                true,
                __source_range,
            );
            vec![__id]
        }
    } else {
        // Reject bare `{ ... }` transforms — they used to be accepted
        // as either a Rust body producing a `Vec<Id>` or a template
        // consisting of a single `{cap}` splice. Both patterns lost
        // static-analysis information (no visible output kind), so we
        // now require rules with block bodies to use the annotation
        // form `=> kind [? | *] { ... }`. Templates must start with a
        // parenthesized node (e.g. `(if_expr ...)`).
        if let Some(TokenTree::Group(g)) = tokens.peek() {
            if g.delimiter() == Delimiter::Brace {
                let span = g.span();
                return Err(syn::Error::new(
                    span,
                    "bare `{...}` rule bodies are no longer accepted; \
                     use the annotation form `=> kind [? | *] { ... }` \
                     (where the kind names the output node's schema kind, \
                     optionally suffixed with `?` or `*` for multiplicity)",
                ));
            }
        }

        // Full template form
        let transform_items = parse_direct_list(&mut tokens, &ctx_ident)?;

        if let Some(tok) = tokens.next() {
            return Err(syn::Error::new_spanned(
                tok,
                "unexpected token after rule! transform",
            ));
        }

        quote! {
            let mut __nodes: Vec<yeast::Id> = Vec::new();
            #(#transform_items)*
            __nodes
        }
    };

    Ok(quote! {
        {
            let __query = #query_code;
            yeast::Rule::new(__query, Box::new(|__ast: &mut yeast::Ast, mut __captures: yeast::captures::Captures, __fresh: &yeast::tree_builder::FreshScope, __source_range: Option<yeast::Range>, __user_ctx: &mut _, __translator: yeast::TranslatorHandle<'_, _>| {
                // Auto-translation prefix: recursively translate every
                // captured node before invoking the user's transform body,
                // except for `@@name` captures listed in `__skip` which the
                // body consumes raw.
                // For OneShot rules this preserves the legacy behaviour
                // (input-schema captures translated to output-schema
                // nodes); for Repeating rules it is a no-op.
                let __skip: &[&str] = &[#(#raw_capture_names),*];
                __translator.auto_translate_captures(&mut __captures, __ast, __user_ctx, __skip)?;
                #(#bindings)*
                let mut #ctx_ident = yeast::build::BuildCtx::with_translator(__ast, &__captures, __fresh, __source_range, __user_ctx, __translator);
                let __result: Vec<yeast::Id> = { #transform_body };
                Ok(__result)
            }))
        }
    })
}

// ---------------------------------------------------------------------------
// Token utilities
// ---------------------------------------------------------------------------

fn peek_is_at(tokens: &mut Tokens) -> bool {
    matches!(tokens.peek(), Some(TokenTree::Punct(p)) if p.as_char() == '@')
}

/// Consume an `@` or `@@` capture marker and the following name ident.
/// Caller has already verified `peek_is_at(tokens)`.
fn consume_capture_marker(tokens: &mut Tokens) -> Result<Ident> {
    tokens.next(); // consume the first `@`
    if peek_is_at(tokens) {
        tokens.next(); // consume the second `@` of `@@`
    }
    expect_ident(tokens, "expected capture name after `@` or `@@`")
}

fn peek_is_literal(tokens: &mut Tokens) -> bool {
    matches!(tokens.peek(), Some(TokenTree::Literal(_)))
}

fn peek_is_dollar(tokens: &mut Tokens) -> bool {
    matches!(tokens.peek(), Some(TokenTree::Punct(p)) if p.as_char() == '$')
}

fn peek_is_hash(tokens: &mut Tokens) -> bool {
    matches!(tokens.peek(), Some(TokenTree::Punct(p)) if p.as_char() == '#')
}

fn peek_is_underscore(tokens: &mut Tokens) -> bool {
    matches!(tokens.peek(), Some(TokenTree::Ident(id)) if *id == "_")
}

/// Check if the next tokens form a field specification (ident followed by `:` or `*:`).
/// A bare identifier (other than `_`) at this position is always a field name, since
/// bare child patterns must start with `(`, `@`, `"literal"`, or `_`.
fn peek_is_field(tokens: &mut Tokens) -> bool {
    matches!(tokens.peek(), Some(TokenTree::Ident(id)) if *id != "_")
}

fn peek_is_group(tokens: &mut Tokens, delim: Delimiter) -> bool {
    matches!(tokens.peek(), Some(TokenTree::Group(g)) if g.delimiter() == delim)
}

fn peek_is_repetition(tokens: &mut Tokens) -> bool {
    matches!(tokens.peek(), Some(TokenTree::Punct(p)) if matches!(p.as_char(), '*' | '+' | '?'))
}

fn expect_ident(tokens: &mut Tokens, msg: &str) -> Result<Ident> {
    match tokens.next() {
        Some(TokenTree::Ident(id)) => Ok(id),
        Some(tok) => Err(syn::Error::new_spanned(tok, msg)),
        None => Err(syn::Error::new(Span::call_site(), msg)),
    }
}

fn expect_literal(tokens: &mut Tokens) -> Result<Literal> {
    match tokens.next() {
        Some(TokenTree::Literal(lit)) => Ok(lit),
        Some(tok) => Err(syn::Error::new_spanned(tok, "expected string literal")),
        None => Err(syn::Error::new(
            Span::call_site(),
            "expected string literal",
        )),
    }
}

fn expect_punct(tokens: &mut Tokens, ch: char, msg: &str) -> Result<()> {
    match tokens.next() {
        Some(TokenTree::Punct(p)) if p.as_char() == ch => Ok(()),
        Some(tok) => Err(syn::Error::new_spanned(tok, msg)),
        None => Err(syn::Error::new(Span::call_site(), msg)),
    }
}

fn expect_group(tokens: &mut Tokens, delim: Delimiter) -> Result<proc_macro2::Group> {
    match tokens.next() {
        Some(TokenTree::Group(g)) if g.delimiter() == delim => Ok(g),
        Some(tok) => Err(syn::Error::new_spanned(
            tok,
            format!("expected {delim:?} group"),
        )),
        None => Err(syn::Error::new(
            Span::call_site(),
            format!("expected {delim:?} group"),
        )),
    }
}

fn expect_repetition(tokens: &mut Tokens) -> Result<TokenStream> {
    match tokens.next() {
        Some(TokenTree::Punct(p)) => match p.as_char() {
            '*' => Ok(quote! { yeast::query::Rep::ZeroOrMore }),
            '+' => Ok(quote! { yeast::query::Rep::OneOrMore }),
            '?' => Ok(quote! { yeast::query::Rep::ZeroOrOne }),
            _ => Err(syn::Error::new(p.span(), "expected `*`, `+`, or `?`")),
        },
        Some(tok) => Err(syn::Error::new_spanned(
            tok,
            "expected repetition quantifier",
        )),
        None => Err(syn::Error::new(
            Span::call_site(),
            "expected repetition quantifier",
        )),
    }
}

// ---------------------------------------------------------------------------
// rules! parsing — bundle a list of rules with input/output schema paths.
//
// The macro accepts both bare rule bodies (`(query) => (template)`) and
// explicit `rule!(...)` invocations. The schema paths are recorded but
// not yet consumed; a later change layers compile-time type-checking on
// top, using these paths to load the input/output schemas.
// ---------------------------------------------------------------------------

/// Parse `rules! { input: "path", output: "path", [ items, ... ] }`.
///
/// Each item in the bracketed list can be:
/// * a **bare rule body** `(query) => (template)` — wrapped implicitly
///   in `yeast::rule! { ... }` for codegen;
/// * an explicit `rule!(...)` (or `rule!(...).repeated()`,
///   `yeast::rule!(...)`, etc.) — passed through verbatim;
/// * any other expression returning a `Rule` (helper-function calls,
///   conditionals) — passed through verbatim.
///
/// Returns a `Vec<Rule>` containing the items in order. The expansion
/// also emits `include_str!` references to the resolved schema paths so
/// Cargo treats them as inputs to the consuming crate; this validates
/// path existence at compile time and prepares the ground for later
/// schema-aware checks.
pub fn parse_rules_top(input: TokenStream) -> Result<TokenStream> {
    let mut tokens = input.into_iter().peekable();

    let input_path = parse_named_string_arg(&mut tokens, "input")?;
    expect_punct(&mut tokens, ',', "expected `,` after input path")?;
    let output_path = parse_named_string_arg(&mut tokens, "output")?;
    expect_punct(&mut tokens, ',', "expected `,` after output path")?;

    // Resolve paths relative to the consuming crate's CARGO_MANIFEST_DIR
    // so callers can write paths like "tree-sitter-swift/node-types.yml"
    // alongside their other workspace-relative includes (e.g. include_str!).
    let manifest_dir = std::env::var("CARGO_MANIFEST_DIR").map_err(|_| {
        syn::Error::new(
            Span::call_site(),
            "rules!: CARGO_MANIFEST_DIR is not set; cannot resolve schema paths",
        )
    })?;
    let resolve_path = |raw: &str| -> std::path::PathBuf {
        let p = std::path::PathBuf::from(raw);
        if p.is_absolute() {
            p
        } else {
            std::path::PathBuf::from(&manifest_dir).join(p)
        }
    };
    let input_abs = resolve_path(&input_path.value);
    let output_abs = resolve_path(&output_path.value);

    let list = expect_group(&mut tokens, Delimiter::Bracket)?;
    if let Some(tok) = tokens.next() {
        return Err(syn::Error::new_spanned(
            tok,
            "unexpected token after `rules!` list",
        ));
    }

    let items = split_top_level_commas(list.stream());
    let emitted_items: Vec<TokenStream> = items
        .into_iter()
        .map(|item| {
            // Bare rule body — wrap in `yeast::rule! { ... }` so the
            // existing rule-construction macro handles codegen. Other
            // items pass through unchanged.
            if has_top_level_arrow(&item) {
                quote! { yeast::rule! { #item } }
            } else {
                item
            }
        })
        .collect();

    // Emit `include_str!` references to both schema files so Cargo
    // treats them as inputs to the consuming crate's compilation. The
    // `const _` bindings are unused; rustc/LLVM drop them after the
    // file-input dependency edge is recorded. Absolute paths are used
    // because `include_str!` resolves relative paths against the source
    // file, while `rules!`'s own paths are relative to
    // `CARGO_MANIFEST_DIR`.
    let input_abs_str = input_abs.to_string_lossy().into_owned();
    let output_abs_str = output_abs.to_string_lossy().into_owned();
    let input_lit = proc_macro2::Literal::string(&input_abs_str);
    let output_lit = proc_macro2::Literal::string(&output_abs_str);

    Ok(quote! {
        {
            const _: &::core::primitive::str = ::core::include_str!(#input_lit);
            const _: &::core::primitive::str = ::core::include_str!(#output_lit);
            vec![ #(#emitted_items),* ]
        }
    })
}

/// True iff `item` contains a `=>` operator at the top level (not nested
/// inside any group). Used to detect bare rule bodies inside `rules!`.
fn has_top_level_arrow(item: &TokenStream) -> bool {
    let toks: Vec<TokenTree> = item.clone().into_iter().collect();
    find_top_level_arrow(&toks).is_some()
}

/// Find the index of the first token of a top-level `=>` operator (the
/// `=`), ignoring `=>` inside any group. Returns `None` if not present.
fn find_top_level_arrow(toks: &[TokenTree]) -> Option<usize> {
    let mut i = 0;
    while i + 1 < toks.len() {
        if let (TokenTree::Punct(p1), TokenTree::Punct(p2)) = (&toks[i], &toks[i + 1]) {
            if p1.as_char() == '='
                && p1.spacing() == proc_macro2::Spacing::Joint
                && p2.as_char() == '>'
            {
                return Some(i);
            }
        }
        i += 1;
    }
    None
}

/// A string literal argument named `expected_name` parsed from `name: "value"`.
struct NamedString {
    value: String,
    #[allow(dead_code)]
    span: Span,
}

fn parse_named_string_arg(tokens: &mut Tokens, expected_name: &str) -> Result<NamedString> {
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
    let lit = expect_literal(tokens)?;
    let span = lit.span();
    let value = string_literal_value(&lit).ok_or_else(|| {
        syn::Error::new(
            span,
            format!("`{expected_name}` must be a string literal path"),
        )
    })?;
    Ok(NamedString { value, span })
}

/// Read a literal as a plain Rust string, respecting Rust's own escape
/// rules (via `syn::LitStr`). Falls back to `None` if the literal
/// isn't a string.
fn string_literal_value(lit: &Literal) -> Option<String> {
    let tokens = TokenStream::from(TokenTree::Literal(lit.clone()));
    syn::parse2::<syn::LitStr>(tokens).ok().map(|s| s.value())
}

/// Split a token stream into top-level comma-separated items. Commas inside
/// any group token (parens, brackets, braces) are ignored so that things
/// like `rule!(a, b)` aren't accidentally split.
fn split_top_level_commas(stream: TokenStream) -> Vec<TokenStream> {
    let mut items = Vec::new();
    let mut current: Vec<TokenTree> = Vec::new();
    for tt in stream {
        if let TokenTree::Punct(p) = &tt {
            if p.as_char() == ',' && p.spacing() == proc_macro2::Spacing::Alone {
                if !current.is_empty() {
                    items.push(current.drain(..).collect());
                }
                continue;
            }
        }
        current.push(tt);
    }
    if !current.is_empty() {
        items.push(current.into_iter().collect());
    }
    items
}

fn maybe_wrap_capture(tokens: &mut Tokens, base: TokenStream) -> Result<TokenStream> {
    if peek_is_at(tokens) {
        let name = consume_capture_marker(tokens)?;
        let name_str = name.to_string();
        Ok(quote! {
            yeast::query::QueryNode::Capture {
                capture: #name_str,
                node: Box::new(#base),
            }
        })
    } else {
        Ok(base)
    }
}

fn maybe_wrap_repetition(tokens: &mut Tokens, single: TokenStream) -> Result<TokenStream> {
    if peek_is_repetition(tokens) {
        let rep = expect_repetition(tokens)?;
        Ok(quote! {
            yeast::query::QueryListElem::Repeated {
                children: vec![#single],
                rep: #rep,
            }
        })
    } else {
        Ok(single)
    }
}

/// If `@name` (or `@@name`) follows a Repeated list element, wrap each
/// child SingleNode inside the repetition with a Capture. This matches
/// tree-sitter semantics where `(_)* @name` captures each matched node.
fn maybe_wrap_list_capture(tokens: &mut Tokens, elem: TokenStream) -> Result<TokenStream> {
    if peek_is_at(tokens) {
        let name = consume_capture_marker(tokens)?;
        let name_str = name.to_string();
        // Re-parse the element isn't practical, so we generate a wrapper
        // that creates a new Repeated with each child wrapped in a capture.
        // The simplest approach: generate code that the runtime can interpret.
        // Actually, the capture annotation on repeated elements is best handled
        // by re-generating the Repeated with captures injected.
        // For now, assume the common case: the repetition contains a single
        // SingleNode child, and we wrap that node in a capture.
        Ok(quote! {
            {
                let __rep = #elem;
                match __rep {
                    yeast::query::QueryListElem::Repeated { children, rep } => {
                        yeast::query::QueryListElem::Repeated {
                            children: children.into_iter().map(|child| {
                                match child {
                                    yeast::query::QueryListElem::SingleNode(node) => {
                                        yeast::query::QueryListElem::SingleNode(
                                            yeast::query::QueryNode::Capture {
                                                capture: #name_str,
                                                node: Box::new(node),
                                            }
                                        )
                                    }
                                    other => other,
                                }
                            }).collect(),
                            rep,
                        }
                    }
                    other => other,
                }
            }
        })
    } else {
        Ok(elem)
    }
}

// ---------------------------------------------------------------------------
// Internal unit tests for the rules! macro shape. Type-checking tests
// land in the follow-up that wires schema validation in.
// ---------------------------------------------------------------------------
#[cfg(test)]
mod rules_tests {
    use super::*;
    use quote::quote;

    #[test]
    fn has_top_level_arrow_distinguishes_bare_rules() {
        // Bare rule body: top-level `=>` is present.
        let toks = quote! { (a) => (b) };
        assert!(has_top_level_arrow(&toks));
        // `rule!((a) => (b))`: the `=>` is INSIDE the macro group, so
        // it's not at top level. Must NOT be detected as a bare body.
        let toks = quote! { rule!((a) => (b)) };
        assert!(!has_top_level_arrow(&toks));
        // Helper call: no `=>` anywhere.
        let toks = quote! { make_rule() };
        assert!(!has_top_level_arrow(&toks));
        // Match expressions inside a block: `=>` is inside braces.
        let toks = quote! { { match x { 1 => 2, _ => 3 } } };
        assert!(!has_top_level_arrow(&toks));
        // Bare shorthand form: top-level `=>` followed by a bare ident.
        let toks = quote! { (a) => kind };
        assert!(has_top_level_arrow(&toks));
    }
}

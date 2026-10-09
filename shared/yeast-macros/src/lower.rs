use proc_macro2::{Ident, Span, TokenStream};
use quote::quote;
use std::sync::atomic::{AtomicUsize, Ordering};
use syn::Lifetime;

use crate::ast::{
    Capture, Cardinality, Content, Field, Node, Pattern, Replacement, Rule, Template,
};

struct LoweringContext<'a> {
    /// Enclosing optional-field label to exit when a computed value is absent.
    fallible_scope: Option<&'a Lifetime>,
}

fn fresh_fallible_label() -> Lifetime {
    static COUNTER: AtomicUsize = AtomicUsize::new(0);
    let n = COUNTER.fetch_add(1, Ordering::Relaxed);
    Lifetime::new(&format!("'__yeast_field_{n}"), Span::call_site())
}

#[derive(Clone)]
struct BoundCapture {
    capture: Capture,
    cardinality: Cardinality,
}

impl Rule {
    pub(crate) fn lower(&self) -> TokenStream {
        let query = self.pattern.lower();
        let captures = self.pattern.captures();
        let (raw_captures, translated_captures): (Vec<_>, Vec<_>) =
            captures.iter().partition(|capture| capture.capture.raw);
        let raw_capture_names = raw_captures
            .iter()
            .map(|capture| capture.capture.name.to_string())
            .collect::<Vec<_>>();
        let raw_bindings = capture_bindings(raw_captures.into_iter());
        let translated_bindings = capture_bindings(translated_captures.into_iter());
        let replacement = self.replacement.lower();
        let guard = self
            .guard
            .clone()
            .unwrap_or_else(|| syn::parse_quote!(true));
        let ctx = Ident::new("ctx", Span::call_site());

        quote! {
            {
                let __query = #query;
                yeast::Rule::guarded(
                    __query,
                    Box::new(|__ast: &yeast::Ast, __captures: &yeast::captures::Captures, __user_ctx: &mut _| {
                        #(#raw_bindings)*
                        #(#translated_bindings)*
                        let ast = __ast;
                        let #ctx = __user_ctx;
                        Ok(#guard)
                    }),
                    Box::new(|__ast: &mut yeast::Ast, mut __captures: yeast::captures::Captures, __source_range: Option<yeast::Range>, __user_ctx: &mut _, __translator: yeast::TranslatorHandle<'_, _>| {
                        let __skip: &[&str] = &[#(#raw_capture_names),*];
                        __translator.auto_translate_captures(&mut __captures, __ast, __user_ctx, __skip)?;
                        #(#raw_bindings)*
                        #(#translated_bindings)*
                        let mut #ctx = yeast::build::BuildCtx::with_translator(__ast, &__captures, __source_range, __user_ctx, __translator);
                        let __result: Vec<yeast::Id> = { #replacement };
                        let __result = #ctx.finish_rule(__result);
                        Ok(__result)
                    }),
                )
            }
        }
    }
}

impl Replacement {
    fn lower(&self) -> TokenStream {
        match self {
            Replacement::Templates(templates) => Template::lower_list(templates),
            Replacement::Rust { body, .. } => {
                let body = rust_block(body);
                quote! {
                    let __value = #body;
                    let mut __ids: Vec<yeast::Id> = Vec::new();
                    yeast::IntoFieldIds::extend_into(__value, &mut __ids);
                    __ids
                }
            }
        }
    }
}

impl Pattern {
    pub(crate) fn lower(&self) -> TokenStream {
        match self {
            Pattern::Any { match_unnamed } => {
                quote! { yeast::query::QueryNode::Any { match_unnamed: #match_unnamed } }
            }
            Pattern::Node { kind, fields } => {
                let fields = fields.iter().map(|(name, pattern)| {
                    let elements = pattern.lower_list();
                    quote! { (#name, vec![#(#elements),*]) }
                });
                quote! {
                    yeast::query::QueryNode::Node {
                        kind: #kind,
                        children: vec![#(#fields),*],
                    }
                }
            }
            Pattern::Unnamed(kind) => {
                quote! { yeast::query::QueryNode::UnnamedNode { kind: #kind } }
            }
            Pattern::Capture { capture, pattern } => {
                let name = capture.name.to_string();
                let pattern = pattern.lower();
                quote! {
                    yeast::query::QueryNode::Capture {
                        capture: #name,
                        node: Box::new(#pattern),
                    }
                }
            }
            Pattern::Sequence(_) | Pattern::Repeated { .. } => {
                unreachable!("sequence and repeated patterns cannot match a single node")
            }
        }
    }

    fn lower_list(&self) -> Vec<TokenStream> {
        match self {
            Pattern::Sequence(patterns) => patterns.iter().flat_map(Pattern::lower_list).collect(),
            Pattern::Capture { capture, pattern }
                if matches!(pattern.as_ref(), Pattern::Repeated { .. }) =>
            {
                pattern.lower_list_with_capture(&capture.name.to_string())
            }
            Pattern::Repeated {
                pattern,
                cardinality,
            } => {
                let children = pattern.lower_list();
                let repetition = match (cardinality.multiple, cardinality.required) {
                    (true, false) => quote! { yeast::query::Rep::ZeroOrMore },
                    (true, true) => quote! { yeast::query::Rep::OneOrMore },
                    (false, false) => quote! { yeast::query::Rep::ZeroOrOne },
                    (false, true) => unreachable!("single patterns are not wrapped as repeated"),
                };
                vec![quote! {
                    yeast::query::QueryListElem::Repeated {
                        children: vec![#(#children),*],
                        rep: #repetition,
                    }
                }]
            }
            pattern => {
                let pattern = pattern.lower();
                vec![quote! { yeast::query::QueryListElem::SingleNode(#pattern) }]
            }
        }
    }

    fn lower_list_with_capture(&self, capture: &str) -> Vec<TokenStream> {
        match self {
            Pattern::Repeated {
                pattern,
                cardinality,
            } => {
                let children = pattern.lower_list_with_capture(capture);
                let repetition = match (cardinality.multiple, cardinality.required) {
                    (true, false) => quote! { yeast::query::Rep::ZeroOrMore },
                    (true, true) => quote! { yeast::query::Rep::OneOrMore },
                    (false, false) => quote! { yeast::query::Rep::ZeroOrOne },
                    (false, true) => unreachable!("single patterns are not wrapped as repeated"),
                };
                vec![quote! {
                    yeast::query::QueryListElem::Repeated {
                        children: vec![#(#children),*],
                        rep: #repetition,
                    }
                }]
            }
            pattern => {
                let pattern = pattern.lower();
                vec![quote! {
                    yeast::query::QueryListElem::SingleNode(
                        yeast::query::QueryNode::Capture {
                            capture: #capture,
                            node: Box::new(#pattern),
                        }
                    )
                }]
            }
        }
    }

    fn captures(&self) -> Vec<BoundCapture> {
        let mut captures = Vec::new();
        self.collect_captures(Cardinality::SINGLE, &mut captures);
        captures
    }

    fn collect_captures(&self, cardinality: Cardinality, captures: &mut Vec<BoundCapture>) {
        match self {
            Pattern::Any { .. } | Pattern::Unnamed(_) => {}
            Pattern::Node { fields, .. } => {
                for (_, pattern) in fields {
                    pattern.collect_captures(cardinality, captures);
                }
            }
            Pattern::Capture { capture, pattern } => {
                pattern.collect_captures(cardinality, captures);
                let captured = pattern
                    .capture_cardinality()
                    .expect("capture patterns are validated during parsing");
                captures.push(BoundCapture {
                    capture: capture.clone(),
                    cardinality: combine_cardinality(cardinality, captured),
                });
            }
            Pattern::Sequence(patterns) => {
                for pattern in patterns {
                    pattern.collect_captures(cardinality, captures);
                }
            }
            Pattern::Repeated {
                pattern,
                cardinality: repeated,
            } => {
                pattern.collect_captures(combine_cardinality(cardinality, *repeated), captures);
            }
        }
    }
}

fn combine_cardinality(parent: Cardinality, child: Cardinality) -> Cardinality {
    Cardinality {
        multiple: parent.multiple || child.multiple,
        required: parent.required && child.required,
    }
}

fn capture_bindings<'a>(captures: impl Iterator<Item = &'a BoundCapture>) -> Vec<TokenStream> {
    captures
        .map(|capture| {
            let name_string = capture.capture.name.to_string();
            let name = Ident::new(&name_string, Span::call_site());
            match (capture.cardinality.multiple, capture.cardinality.required) {
                (true, _) => {
                    quote! {
                        let #name: Vec<yeast::Id> = __captures.get_all(#name_string);
                    }
                }
                (false, false) => {
                    quote! {
                        let #name: Option<yeast::Id> = __captures.get_opt(#name_string);
                    }
                }
                (false, true) => {
                    quote! {
                        let #name: yeast::Id = __captures.get_var(#name_string).unwrap();
                    }
                }
            }
        })
        .collect()
}

impl Template {
    pub(crate) fn lower_root(&self) -> TokenStream {
        self.lower(&LoweringContext {
            fallible_scope: None,
        })
    }

    pub(crate) fn lower_list(templates: &[Self]) -> TokenStream {
        let context = LoweringContext {
            fallible_scope: None,
        };
        let items = templates
            .iter()
            .map(|template| match template {
                Template::Node(node) => {
                    let node = node.lower(&context);
                    quote! { __nodes.push(#node); }
                }
                Template::Splice(block) => {
                    let block = rust_block(block);
                    quote! {
                        yeast::IntoFieldIds::extend_into(#block, &mut __nodes);
                    }
                }
            })
            .collect::<Vec<_>>();

        quote! {
            {
                let mut __nodes: Vec<yeast::Id> = Vec::new();
                #(#items)*
                __nodes
            }
        }
    }

    fn lower(&self, context: &LoweringContext<'_>) -> TokenStream {
        match self {
            Template::Node(node) => node.lower(context),
            Template::Splice(block) => {
                let block = rust_block(block);
                quote! { ::std::convert::Into::<yeast::Id>::into(#block) }
            }
        }
    }
}

impl Node {
    fn lower(&self, context: &LoweringContext<'_>) -> TokenStream {
        let ctx = Ident::new("ctx", Span::call_site());
        let kind_str = self.kind.to_string();

        if let Some(content) = &self.content {
            return match content {
                Content::Static(lit) => quote! { #ctx.literal(#kind_str, #lit) },
                Content::Computed(block) => {
                    let block = rust_block(block);
                    if let Some(label) = context.fallible_scope {
                        quote! {
                            {
                                let __expr = #block;
                                let ::std::option::Option::Some(__value_ref) =
                                    yeast::MaybeYeastValue::maybe_yeast_value(&__expr)
                                else {
                                    break #label ::std::option::Option::None;
                                };
                                let __value =
                                    yeast::YeastDisplay::yeast_to_string(__value_ref, &*#ctx.ast);
                                let __source_range =
                                    yeast::YeastSourceRange::yeast_source_range(__value_ref, &*#ctx.ast);
                                #ctx.literal_with_source_range(
                                    #kind_str,
                                    &__value,
                                    __source_range,
                                )
                            }
                        }
                    } else {
                        quote! {
                            {
                                let __expr = #block;
                                let __value =
                                    yeast::YeastDisplay::yeast_to_string(&__expr, &*#ctx.ast);
                                let __source_range =
                                    yeast::YeastSourceRange::yeast_source_range(&__expr, &*#ctx.ast);
                                #ctx.literal_with_source_range(
                                    #kind_str,
                                    &__value,
                                    __source_range,
                                )
                            }
                        }
                    }
                }
            };
        }

        let mut stmts = Vec::new();
        let mut field_args = Vec::new();

        for (field_counter, field) in self.fields.iter().enumerate() {
            let Field::Named {
                name,
                value,
                optional,
            } = field;
            let field_name = name.to_string();
            let field_str = field_name
                .strip_prefix("r#")
                .unwrap_or(&field_name)
                .to_string();
            let temp = Ident::new(
                &format!("__field_{field_str}_{field_counter}"),
                Span::call_site(),
            );

            match value {
                Template::Splice(block) => {
                    debug_assert!(!optional);
                    let block = rust_block(block);
                    stmts.push(quote! {
                        let mut #temp: Vec<yeast::Id> = Vec::new();
                        yeast::IntoFieldIds::extend_into(#block, &mut #temp);
                    });
                    field_args.push(quote! {
                        if !#temp.is_empty() {
                            __fields.push((#field_str, #temp));
                        }
                    });
                }
                Template::Node(child) if *optional => {
                    let label = fresh_fallible_label();
                    let value = child.lower(&LoweringContext {
                        fallible_scope: Some(&label),
                    });
                    stmts.push(quote! {
                        #[allow(unused_labels)]
                        let #temp: ::std::option::Option<yeast::Id> = #label: {
                            ::std::option::Option::Some(#value)
                        };
                    });
                    field_args.push(quote! {
                        if let ::std::option::Option::Some(__id) = #temp {
                            __fields.push((#field_str, vec![__id]));
                        }
                    });
                }
                Template::Node(child) => {
                    let value = child.lower(context);
                    stmts.push(quote! { let #temp: yeast::Id = #value; });
                    field_args.push(quote! {
                        __fields.push((#field_str, vec![#temp]));
                    });
                }
            }
        }

        quote! {
            {
                #(#stmts)*
                let mut __fields: Vec<(&str, Vec<yeast::Id>)> = Vec::new();
                #(#field_args)*
                #ctx.node(#kind_str, __fields)
            }
        }
    }
}

fn rust_block(block: &syn::Block) -> TokenStream {
    let statements = &block.stmts;
    quote!({ #(#statements)* })
}

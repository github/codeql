use proc_macro2::{Ident, Span, TokenStream};
use quote::quote;
use std::sync::atomic::{AtomicUsize, Ordering};
use syn::Lifetime;

use crate::ast::{Content, Field, Node, Template};

struct LoweringContext<'a> {
    /// Enclosing optional-field label to exit when a computed value is absent.
    fallible_scope: Option<&'a Lifetime>,
}

fn fresh_fallible_label() -> Lifetime {
    static COUNTER: AtomicUsize = AtomicUsize::new(0);
    let n = COUNTER.fetch_add(1, Ordering::Relaxed);
    Lifetime::new(&format!("'__yeast_field_{n}"), Span::call_site())
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

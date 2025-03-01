use proc_macro::TokenStream;
use quote::{format_ident, quote};
use syn::{Ident, Type};

fn get_type_tip(t: &Type) -> Option<&Ident> {
    let syn::Type::Path(path) = t else {
        return None;
    };
    let segment = path.path.segments.last()?;
    Some(&segment.ident)
}

/// Allow all fields in the extractor config to be also overrideable by extractor CLI flags
#[proc_macro_attribute]
pub fn extractor_cli_config(attr: TokenStream, item: TokenStream) -> TokenStream {
    if !attr.is_empty() {
        return item;
    }
    let ast = syn::parse_macro_input!(item as syn::ItemStruct);
    let name = &ast.ident;
    let fields = ast
        .fields
        .iter()
        .map(|f| {
            let ty_tip = get_type_tip(&f.ty);
            let mut f = f.clone();
            let default_true_position = f.attrs.iter().position(|a| a.path().is_ident("default_true"));
            if default_true_position.is_some() {
                f.attrs.remove(default_true_position.unwrap());
                f.attrs.push(syn::parse_quote! { #[serde(default="default_true")] });
            } else {
                f.attrs.push(syn::parse_quote! { #[serde(default)] });
            }
            if f.ident.as_ref().is_some_and(|i| i != "inputs")
                && ty_tip.is_some_and(|i| i == "Vec")
            {
                f.attrs.push(syn::parse_quote!(#[serde(deserialize_with="deserialize::deserialize_newline_or_comma_separated_vec")]));
            } else if ty_tip.is_some_and(|i| i == "FxHashMap" || i == "HashMap") {
                f.attrs.push(syn::parse_quote!(#[serde(deserialize_with="deserialize::deserialize_newline_or_comma_separated_map")]));
            }
            quote! { #f }
        })
        .collect::<Vec<_>>();
    let cli_name = format_ident!("Cli{}", name);
    let cli_fields = ast
        .fields
        .iter()
        .map(|f| {
            let id = f.ident.as_ref().unwrap();
            let ty = &f.ty;
            let type_tip = get_type_tip(ty);
            if type_tip.is_some_and(|i| i == "bool") {
                if f.attrs.iter().any(|a| a.path().is_ident("default_true")) {
                    let id_str = format!("no-{}", id).replace("_", "-");
                    quote! {
                        #[arg(long=#id_str, action=clap::ArgAction::SetFalse)]
                        #[serde(skip_serializing_if="is_true")]
                        #id: bool
                    }
                } else {
                    quote! {
                        #[arg(long)]
                        #[serde(skip_serializing_if="is_false")]
                        #id: bool
                    }
                }
            } else if type_tip.is_some_and(|i| i == "Option") {
                quote! {
                    #[arg(long)]
                    #[serde(skip_serializing_if="Option::is_none")]
                    #f
                }
            } else if id == &format_ident!("verbose") {
                quote! {
                    #[arg(long, short, action=clap::ArgAction::Count)]
                    #[serde(skip_serializing_if="u8::is_zero")]
                    #id: u8
                }
            } else if id == &format_ident!("inputs") {
                quote! {
                    #f
                }
            } else if type_tip.is_some_and(|i| i == "Vec" || i == "FxHashMap" || i == "HashMap") {
                quote! {
                    #[arg(long)]
                    #[serde(skip_serializing_if="Option::is_none")]
                    #id: Option<String>
                }
            } else {
                quote! {
                    #[arg(long)]
                    #[serde(skip_serializing_if="Option::is_none")]
                    #id: Option<#ty>
                }
            }
        })
        .collect::<Vec<_>>();
    let debug_fields = ast
        .fields
        .iter()
        .map(|f| {
            let id = f.ident.as_ref().unwrap();
            if id == &format_ident!("inputs") {
                quote! {
                    .field("number of inputs", &self.#id.len())
                }
            } else {
                quote! {
                    .field(stringify!(#id), &self.#id)
                }
            }
        })
        .collect::<Vec<_>>();

    let gen = quote! {
        fn default_true() -> bool {
            true
        }

        fn is_true(cond: &bool) -> bool {
            cond.clone()
        }

        fn is_false(cond: &bool) -> bool {
            !cond
        }

        #[derive(Deserialize, Default)]
        pub struct #name {
            #(#fields),*
        }

        impl Debug for #name {
            fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
                f.debug_struct("configuration:")
                    #(#debug_fields)*
                    .finish()
            }
        }

        #[derive(clap::Parser, Serialize)]
        #[command(about, long_about = None)]
        struct #cli_name {
            #(#cli_fields),*
        }
    };
    gen.into()
}

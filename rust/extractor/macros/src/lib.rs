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
pub fn extractor_cli_config(_attr: TokenStream, item: TokenStream) -> TokenStream {
    let ast = syn::parse_macro_input!(item as syn::ItemStruct);
    let name = &ast.ident;
    let fields = ast
        .fields
        .iter()
        .map(|f| {
            if f.ident.as_ref().is_some_and(|i| i != "inputs")
                && get_type_tip(&f.ty).is_some_and(|i| i == "Vec")
            {
                quote! {
                    #[serde(deserialize_with="deserialize_newline_or_comma_separated")]
                    #f
                }
            } else {
                quote! { #f }
            }
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
                quote! {
                    #[arg(long)]
                    #[serde(skip_serializing_if="<&bool>::not")]
                    #id: bool
                }
            } else if type_tip.is_some_and(|i| i == "Option") {
                quote! {
                    #[arg(long)]
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
            } else if type_tip.is_some_and(|i| i == "Vec") {
                quote! {
                    #[arg(long)]
                    #id: Option<String>
                }
            } else {
                quote! {
                    #[arg(long)]
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
        #[serde_with::apply(_ => #[serde(default)])]
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

        #[serde_with::skip_serializing_none]
        #[derive(clap::Parser, Serialize)]
        #[command(about, long_about = None)]
        struct #cli_name {
            #(#cli_fields),*
        }
    };
    gen.into()
}

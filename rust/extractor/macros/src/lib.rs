use proc_macro::TokenStream;
use quote::{format_ident, quote};

/// Allow all fields in the extractor config to be also overrideable by extractor CLI flags
#[proc_macro_attribute]
pub fn extractor_cli_config(_attr: TokenStream, item: TokenStream) -> TokenStream {
    let ast = syn::parse_macro_input!(item as syn::ItemStruct);
    let name = &ast.ident;
    let new_name = format_ident!("Cli{}", name);
    let fields: Vec<_> = ast
        .fields
        .iter()
        .map(|f| {
            let id = f.ident.as_ref().unwrap();
            let ty = &f.ty;
            if let syn::Type::Path(p) = ty {
                if p.path.is_ident(&format_ident!("bool")) {
                    return quote! {
                        #[arg(long)]
                        #[serde(skip_serializing_if="<&bool>::not")]
                        #id: bool,
                    };
                }
            }
            if id == &format_ident!("verbose") {
                quote! {
                    #[arg(long, short, action=clap::ArgAction::Count)]
                    #[serde(skip_serializing_if="u8::is_zero")]
                    #id: u8,
                }
            } else if id == &format_ident!("inputs") {
                quote! {
                    #id: #ty,
                }
            } else {
                quote! {
                    #[arg(long)]
                    #id: Option<#ty>,
                }
            }
        })
        .collect();
    let gen = quote! {
        #[serde_with::apply(_ => #[serde(default)])]
        #[derive(Debug, Deserialize, Default)]
        #ast

        #[serde_with::skip_serializing_none]
        #[derive(clap::Parser, Serialize)]
        #[command(about, long_about = None)]
        struct #new_name {
            #(#fields)*
        }
    };
    gen.into()
}

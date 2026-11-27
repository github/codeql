use proc_macro::TokenStream;
use quote::quote;

#[proc_macro_attribute]
pub fn add_suffix(attr: TokenStream, item: TokenStream) -> TokenStream {
    let suff = syn::parse_macro_input!(attr as syn::LitStr).value();
    let mut ast = syn::parse_macro_input!(item as syn::ItemFn);
    ast.sig.ident = syn::Ident::new(&format!("{}_{}", ast.sig.ident, suff), ast.sig.ident.span());
    quote! {
        #ast
    }
    .into()
}

#[proc_macro_attribute]
pub fn identity(_attr: TokenStream, item: TokenStream) -> TokenStream {
    item
}

#[proc_macro_derive(GenerateBuilder)]
pub fn generate_builder(input: TokenStream) -> TokenStream {
    let ast = syn::parse_macro_input!(input as syn::DeriveInput);
    let name = &ast.ident;
    let builder_name = syn::Ident::new(&format!("{}Builder", name), name.span());
    quote! {
        pub struct #builder_name;
    }
    .into()
}

#[proc_macro_derive(GenerateBuilderViaMacro)]
pub fn generate_builder_via_macro(_input: TokenStream) -> TokenStream {
    quote! {
        build_via_macro!();
    }
    .into()
}

#[proc_macro_derive(GenerateBuilderViaAttribute)]
pub fn generate_builder_via_attribute(_input: TokenStream) -> TokenStream {
    quote! {
        #[proc_macro::make_struct]
        pub struct AttributeGenerated;
    }
    .into()
}

#[proc_macro_attribute]
pub fn make_struct(_attr: TokenStream, _item: TokenStream) -> TokenStream {
    quote! {
        pub struct AttributeGenerated;
    }
    .into()
}

#[proc_macro_derive(GenerateGlobUse)]
pub fn generate_glob_use(_input: TokenStream) -> TokenStream {
    quote! {
        use helper::*;
    }
    .into()
}

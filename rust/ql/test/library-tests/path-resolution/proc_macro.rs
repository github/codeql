use proc_macro::TokenStream;
use quote::quote;

#[proc_macro_attribute]
pub fn add_suffix(attr: TokenStream, item: TokenStream) -> TokenStream {
    let suff = syn::parse_macro_input!(attr as syn::LitStr).value();
    let mut ast = syn::parse_macro_input!(item as syn::ItemFn);
    ast.sig.ident = syn::Ident::new(&format!("{}_{}", ast.sig.ident, suff), ast.sig.ident.span());
    quote! {
        #ast
    }.into()
}

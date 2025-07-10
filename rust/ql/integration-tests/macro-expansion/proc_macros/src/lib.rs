use proc_macro::TokenStream;
use quote::quote;

#[proc_macro_attribute]
pub fn repeat(attr: TokenStream, item: TokenStream) -> TokenStream {
    let number = syn::parse_macro_input!(attr as syn::LitInt).base10_parse::<usize>().unwrap();
    let ast = syn::parse_macro_input!(item as syn::ItemFn);
    let items = (0..number)
        .map(|i| {
            let mut new_ast = ast.clone();
            new_ast.sig.ident = syn::Ident::new(&format!("{}_{}", ast.sig.ident, i), ast.sig.ident.span());
            new_ast
        })
        .collect::<Vec<_>>();
    quote! {
        #(#items)*
    }.into()
}

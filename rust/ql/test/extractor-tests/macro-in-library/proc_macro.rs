use proc_macro::TokenStream;
use quote::quote;

#[proc_macro_attribute]
pub fn add_one(_attr: TokenStream, item: TokenStream) -> TokenStream {
    let ast = syn::parse_macro_input!(item as syn::ItemFn);
    let mut new_ast = ast.clone();
    new_ast.sig.ident = syn::Ident::new(&format!("{}_new", ast.sig.ident), ast.sig.ident.span());
    quote! {
        #ast
        #new_ast
    }.into()
}


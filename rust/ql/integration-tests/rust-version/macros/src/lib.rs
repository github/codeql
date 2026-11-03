extern crate proc_macro;

#[proc_macro]
pub fn generate(_: proc_macro::TokenStream) -> proc_macro::TokenStream {
    "pub fn from_proc_macro() -> u32 { 43 }".parse().unwrap()
}

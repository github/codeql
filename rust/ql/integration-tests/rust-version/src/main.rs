include!(concat!(env!("OUT_DIR"), "/generated.rs"));

macros::generate!();

fn main() {
    println!("{} {}", from_build_script(), from_proc_macro());
}

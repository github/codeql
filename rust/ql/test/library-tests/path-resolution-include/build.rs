use std::{env, fs, path::PathBuf};

fn main() {
    let root = PathBuf::from(env::var_os("CARGO_MANIFEST_DIR").unwrap());
    let out = PathBuf::from(env::var_os("OUT_DIR").unwrap());
    let included = root.join("foo/nested/more.rs");
    let contents = format!("include!(r###\"{}\"###);\n", included.display());

    fs::write(out.join("absolute.rs"), contents).unwrap();
    fs::write(out.join("nested.rs"), "include!(\"absolute.rs\");\n").unwrap();

    println!("cargo:rerun-if-changed=foo/nested/more.rs");
}

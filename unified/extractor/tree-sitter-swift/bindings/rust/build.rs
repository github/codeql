use std::env;
use std::path::PathBuf;

fn main() {
    // tree-sitter-generate produces parser.c, grammar.json, node-types.json,
    // and src/tree_sitter/*.h headers from grammar.js. We write them into
    // OUT_DIR so the build is sandbox-friendly and we don't litter the source
    // tree.
    let crate_dir: PathBuf = env::var("CARGO_MANIFEST_DIR").unwrap().into();
    let out_dir: PathBuf = env::var("OUT_DIR").unwrap().into();
    let grammar_js = crate_dir.join("grammar.js");

    tree_sitter_generate::generate_parser_in_directory(
        &crate_dir,
        Some(&out_dir),
        Some(&grammar_js),
        tree_sitter_generate::ABI_VERSION_MAX,
        None,
        None,
        true,
        tree_sitter_generate::OptLevel::default(),
    )
    .expect("failed to generate tree-sitter-swift parser");

    let mut c_config = cc::Build::new();
    c_config
        .std("c11")
        .include(&out_dir)
        .include(out_dir.join("tree_sitter"));

    #[cfg(target_env = "msvc")]
    c_config.flag("-utf-8");

    c_config.file(out_dir.join("parser.c"));

    // scanner.c is hand-written and lives in the source tree.
    let scanner_path = crate_dir.join("src").join("scanner.c");
    c_config.include(crate_dir.join("src")).file(&scanner_path);

    println!("cargo:rerun-if-changed={}", grammar_js.to_str().unwrap());
    println!("cargo:rerun-if-changed={}", scanner_path.to_str().unwrap());
    // Re-export OUT_DIR so consumers can include_str! the generated files.
    println!(
        "cargo:rustc-env=TREE_SITTER_SWIFT_OUT_DIR={}",
        out_dir.to_str().unwrap()
    );

    c_config.compile("tree-sitter-swift");
}

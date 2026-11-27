use std::path::Path;

fn main() {
    let src_dir = Path::new("../tsg-python/tsp/src");

    let header_path = src_dir.join("tree_sitter/parser.h");
    println!("cargo:rerun-if-changed={}", header_path.display());

    let parser_path = src_dir.join("parser.c");
    cc::Build::new()
        .include(src_dir)
        .flag_if_supported("-Wno-unused-parameter")
        .flag_if_supported("-Wno-unused-but-set-variable")
        .flag_if_supported("-Wno-trigraphs")
        .file(&parser_path)
        .compile("parser");
    println!("cargo:rerun-if-changed={}", parser_path.display());

    let scanner_path = src_dir.join("scanner.cc");
    cc::Build::new()
        .cpp(true)
        .include(src_dir)
        .flag_if_supported("-Wno-unused-parameter")
        .flag_if_supported("-Wno-unused-but-set-variable")
        .file(&scanner_path)
        .compile("scanner");
    println!("cargo:rerun-if-changed={}", scanner_path.display());
}

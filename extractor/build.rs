use std::path::PathBuf;

fn main() {
    let dir: PathBuf = ["../tree-sitter-ruby", "src"].iter().collect();
    let mut build = cc::Build::new();
    build
        .include(&dir)
        .file(&dir.join("parser.c"))
        .file(&dir.join("scanner.cc"));
    if !cfg!(windows) {
        build.cpp(true).compiler("clang");
    }
    build.compile("tree-sitter-ruby");
}

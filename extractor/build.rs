use std::path::PathBuf;

fn main() {
    let dir: PathBuf = ["../tree-sitter-ruby", "src"].iter().collect();

    cc::Build::new()
        .include(&dir)
        .file(dir.join("parser.c"))
        .file(dir.join("scanner.cc"))
        .compile("tree-sitter-ruby");
}

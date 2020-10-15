use tree_sitter::{Language, Parser};

fn main() {
    let mut parser = Parser::new();

    extern "C" {
        fn tree_sitter_ruby() -> Language;
    }

    let language = unsafe { tree_sitter_ruby() };
    parser.set_language(language).unwrap();

    let src = "def foo\n  puts \"hello\"\nend";
    let tree = parser.parse(src, None).unwrap();
    let root_node = tree.root_node();

    println!("Root: {}", root_node.to_sexp());
}

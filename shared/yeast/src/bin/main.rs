use clap::Parser;

#[derive(Parser)]
#[clap(name = "yeast", about = "yeast elaborates abstract syntax trees")]
struct Cli {
    file: String,
    #[clap(default_value = "ruby")]
    language: String,
}

fn get_language(language: &str) -> tree_sitter::Language {
    match language {
        "ruby" => tree_sitter_ruby::LANGUAGE.into(),
        "python" => tree_sitter_python::LANGUAGE.into(),
        _ => panic!("Unsupported language: {language}"),
    }
}

fn main() {
    let args = Cli::parse();
    let language = get_language(&args.language);
    let source = std::fs::read_to_string(&args.file).unwrap();
    let runner = yeast::Runner::new(language, &[]);
    let ast = runner.run(&source).unwrap();
    println!("{}", ast.print(&source, ast.get_root()));
}

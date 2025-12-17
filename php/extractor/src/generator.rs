use clap::Args;
use std::path::PathBuf;

use codeql_extractor::generator::{generate, language::Language};

#[derive(Args, Debug)]
pub struct Options {
    /// Path of the generated dbscheme file
    #[arg(long)]
    dbscheme: PathBuf,

    /// Path of the generated QLL file
    #[arg(long)]
    library: PathBuf,
}

pub fn run(options: Options) -> std::io::Result<()> {
    let languages = vec![Language {
        name: "PHP".to_owned(),
        node_types: tree_sitter_php::PHP_NODE_TYPES,
    }];

    generate(languages, options.dbscheme, options.library)
}
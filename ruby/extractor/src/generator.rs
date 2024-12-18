use clap::Args;
use std::path::PathBuf;

use codeql_extractor::generator::{generate, language::Language};

#[derive(Args)]
pub struct Options {
    /// Path of the generated dbscheme file
    #[arg(long)]
    dbscheme: PathBuf,

    /// Path of the generated QLL file
    #[arg(long)]
    library: PathBuf,
}

pub fn run(options: Options) -> std::io::Result<()> {
    codeql_extractor::extractor::set_tracing_level("ruby");

    let languages = vec![
        Language {
            name: "Ruby".to_owned(),
            node_types: tree_sitter_ruby::NODE_TYPES,
        },
        Language {
            name: "Erb".to_owned(),
            node_types: tree_sitter_embedded_template::NODE_TYPES,
        },
    ];

    generate(languages, options.dbscheme, options.library)
}

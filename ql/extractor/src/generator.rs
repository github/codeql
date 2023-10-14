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
    tracing_subscriber::fmt()
        .with_target(false)
        .without_time()
        .with_level(true)
        .with_env_filter(tracing_subscriber::EnvFilter::from_default_env())
        .init();

    let languages = vec![
        Language {
            name: "QL".to_owned(),
            node_types: tree_sitter_ql::NODE_TYPES,
        },
        Language {
            name: "Dbscheme".to_owned(),
            node_types: tree_sitter_ql_dbscheme::NODE_TYPES,
        },
        Language {
            name: "Blame".to_owned(),
            node_types: tree_sitter_blame::NODE_TYPES,
        },
        Language {
            name: "JSON".to_owned(),
            node_types: tree_sitter_json::NODE_TYPES,
        },
    ];

    generate(languages, options.dbscheme, options.library)
}

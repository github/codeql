use clap::arg;
use std::path::PathBuf;

use codeql_extractor::generator::{generate, language::Language};

fn main() -> std::io::Result<()> {
    tracing_subscriber::fmt()
        .with_target(false)
        .without_time()
        .with_level(true)
        .with_env_filter(tracing_subscriber::EnvFilter::from_default_env())
        .init();

    let matches = clap::Command::new("Ruby dbscheme generator")
        .version("1.0")
        .author("GitHub")
        .about("CodeQL Ruby dbscheme generator")
        .arg(arg!(--dbscheme <FILE>                  "Path of the generated dbscheme file"))
        .arg(arg!(--library <FILE>                   "Path of the generated QLL file"))
        .get_matches();
    let dbscheme_path = matches
        .get_one::<String>("dbscheme")
        .expect("missing --dbscheme");
    let dbscheme_path = PathBuf::from(dbscheme_path);

    let ql_library_path = matches
        .get_one::<String>("library")
        .expect("missing --library");
    let ql_library_path = PathBuf::from(ql_library_path);

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

    generate(languages, dbscheme_path, ql_library_path)
}

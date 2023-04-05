use std::path::PathBuf;

use codeql_extractor::generator::{generate, language::Language};

fn main() -> std::io::Result<()> {
    tracing_subscriber::fmt()
        .with_target(false)
        .without_time()
        .with_level(true)
        .with_env_filter(tracing_subscriber::EnvFilter::from_default_env())
        .init();

    let matches = clap::App::new("QL dbscheme generator")
        .version("1.0")
        .author("GitHub")
        .about("CodeQL QL dbscheme generator")
        .args_from_usage(
            "--dbscheme=<FILE>                  'Path of the generated dbscheme file'
             --library=<FILE>                   'Path of the generated QLL file'",
        )
        .get_matches();
    let dbscheme_path = matches.value_of("dbscheme").expect("missing --dbscheme");
    let dbscheme_path = PathBuf::from(dbscheme_path);

    let ql_library_path = matches.value_of("library").expect("missing --library");
    let ql_library_path = PathBuf::from(ql_library_path);

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
            name: "Yaml".to_owned(),
            node_types: tree_sitter_ql_yaml::NODE_TYPES,
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

    generate(languages, dbscheme_path, ql_library_path)
}

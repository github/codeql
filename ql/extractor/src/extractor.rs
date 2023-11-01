use clap::Args;
use std::path::PathBuf;

use codeql_extractor::extractor::simple;
use codeql_extractor::trap;

#[derive(Args)]
pub struct Options {
    /// Sets a custom source achive folder
    #[arg(long)]
    source_archive_dir: PathBuf,

    /// Sets a custom trap folder
    #[arg(long)]
    output_dir: PathBuf,

    /// A text file containing the paths of the files to extract
    #[arg(long)]
    file_list: PathBuf,
}

pub fn run(options: Options) -> std::io::Result<()> {
    tracing_subscriber::fmt()
        .with_target(false)
        .without_time()
        .with_level(true)
        .with_env_filter(tracing_subscriber::EnvFilter::from_default_env())
        .init();

    let extractor = simple::Extractor {
        prefix: "ql".to_string(),
        languages: vec![
            simple::LanguageSpec {
                prefix: "ql",
                ts_language: tree_sitter_ql::language(),
                node_types: tree_sitter_ql::NODE_TYPES,
                file_globs: vec!["*.ql".into(), "*.qll".into()],
            },
            simple::LanguageSpec {
                prefix: "dbscheme",
                ts_language: tree_sitter_ql_dbscheme::language(),
                node_types: tree_sitter_ql_dbscheme::NODE_TYPES,
                file_globs: vec!["*.dbscheme".into()],
            },
            simple::LanguageSpec {
                prefix: "json",
                ts_language: tree_sitter_json::language(),
                node_types: tree_sitter_json::NODE_TYPES,
                file_globs: vec!["*.json".into(), "*.jsonl".into(), "*.jsonc".into()],
            },
            simple::LanguageSpec {
                prefix: "blame",
                ts_language: tree_sitter_blame::language(),
                node_types: tree_sitter_blame::NODE_TYPES,
                file_globs: vec!["*.blame".into()],
            },
        ],
        trap_dir: options.output_dir,
        trap_compression: trap::Compression::from_env("CODEQL_QL_TRAP_COMPRESSION"),
        source_archive_dir: options.source_archive_dir,
        file_list: options.file_list,
    };

    extractor.run()
}

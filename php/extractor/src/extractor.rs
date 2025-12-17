use clap::Args;
use std::path::PathBuf;

use codeql_extractor::extractor::simple;
use codeql_extractor::trap;

#[derive(Args, Debug)]
pub struct ExtractOptions {
    /// Sets a custom source archive folder
    #[arg(long)]
    source_archive_dir: PathBuf,

    /// Sets a custom trap folder
    #[arg(long)]
    output_dir: PathBuf,

    /// A text file containing the paths of the files to extract
    #[arg(long)]
    file_list: PathBuf,
}

pub fn extract(options: ExtractOptions) -> std::io::Result<()> {
    let extractor = simple::Extractor {
        prefix: "php".to_string(),
        languages: vec![simple::LanguageSpec {
            prefix: "php",
            ts_language: tree_sitter_php::LANGUAGE_PHP.into(),
            node_types: tree_sitter_php::PHP_NODE_TYPES,
            file_globs: vec!["*.php".into(), "*.phtml".into(), "*.inc".into()],
        }],
        trap_dir: options.output_dir,
        trap_compression: trap::Compression::from_env("CODEQL_PHP_TRAP_COMPRESSION"),
        source_archive_dir: options.source_archive_dir,
        file_lists: vec![options.file_list],
    };

    extractor.run()
}
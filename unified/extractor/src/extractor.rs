use clap::Args;
use std::path::PathBuf;

use codeql_extractor::extractor::simple;
use codeql_extractor::trap;

#[path = "languages/swift/swift.rs"]
mod swift;

#[derive(Args)]
pub struct Options {
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

pub fn run(options: Options) -> std::io::Result<()> {
    codeql_extractor::extractor::set_tracing_level("unified");

    let extractor = simple::Extractor {
        prefix: "unified".to_string(),
        languages: vec![
            swift::language_spec(),
        ],
        trap_dir: options.output_dir,
        trap_compression: trap::Compression::from_env("CODEQL_EXTRACTOR_UNIFIED_OPTION_TRAP_COMPRESSION"),
        source_archive_dir: options.source_archive_dir,
        file_lists: vec![options.file_list],
    };

    extractor.run()
}

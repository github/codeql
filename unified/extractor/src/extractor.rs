use crate::languages;
use clap::Args;
use codeql_extractor::extractor::desugaring;
use codeql_extractor::trap;
use std::path::Path;
use std::path::PathBuf;
use std::{env, fs};
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

    // The generated dbscheme/QL library uses the unified_* relation namespace.
    // Keep per-language specs for parser/rules/file globs, but normalize the
    // extraction table prefix so emitted TRAP relations match the dbscheme.
    let mut languages = languages::all_language_specs();
    for lang in &mut languages {
        lang.prefix = "unified";
    }

    let scratch_dir = std::env::var("CODEQL_EXTRACTOR_UNIFIED_SCRATCH_DIR")
        .expect("failed to read CODEQL_EXTRACTOR_UNIFIED_SCRATCH_DIR environment variable");
    let builtins_path = env::var("CODEQL_EXTRACTOR_UNIFIED_ROOT")
        .map(|path| Path::new(&path).join("tools").join("builtins"))
        .expect("failed to read CODEQL_EXTRACTOR_UNIFIED_ROOT environment variable");
    let builtins_dir = fs::read_dir(builtins_path).expect("failed to read builtins directory");
    let mut builtins_list = PathBuf::new();
    builtins_list.push(scratch_dir.clone());
    builtins_list.push("builtins");
    builtins_list.set_extension("list");

    let mut builtins_list_file = fs::OpenOptions::new()
        .create_new(true)
        .write(true)
        .open(&builtins_list)
        .expect("failed to open file list");
    for entry in builtins_dir {
        let entry = entry.expect("failed to read builtins directory");
        let path = entry.path();
        if path.extension().is_some_and(|ext| ext == "swift") {
            use std::io::Write;
            writeln!(builtins_list_file, "{}", path.display())
                .expect("failed to write to file list");
        }
    }
    drop(builtins_list_file);

    let extractor = desugaring::Extractor {
        prefix: "unified".to_string(),
        languages,
        trap_dir: options.output_dir,
        trap_compression: trap::Compression::from_env(
            "CODEQL_EXTRACTOR_UNIFIED_OPTION_TRAP_COMPRESSION",
        ),
        source_archive_dir: options.source_archive_dir,
        file_lists: vec![options.file_list, builtins_list],
    };

    extractor.run()
}

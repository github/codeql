use clap::Args;
use codeql_extractor::file_paths::PathTransformer;
use rayon::prelude::*;
use std::collections::HashSet;
use std::fs;
use std::io::BufRead;
use std::path::{Path, PathBuf};
use tree_sitter::Language;

use codeql_extractor::{diagnostics, extractor, file_paths, node_types, trap};

#[derive(Args)]
pub struct Options {
    /// Sets a custom source achive folder
    #[arg(long)]
    source_archive_dir: String,

    /// Sets a custom trap folder
    #[arg(long)]
    output_dir: String,

    /// A text file containing the paths of the files to extract
    #[arg(long)]
    file_list: String,
}

pub fn run(options: Options) -> std::io::Result<()> {
    extractor::set_tracing_level("php");
    tracing::info!("Extraction started");

    let diagnostics = diagnostics::DiagnosticLoggers::new("php");
    let mut main_thread_logger = diagnostics.logger();
    let num_threads = match codeql_extractor::options::num_threads() {
        Ok(num) => num,
        Err(e) => {
            main_thread_logger.write(
                main_thread_logger
                    .new_entry("configuration-error", "Configuration error")
                    .message(
                        "{}; defaulting to 1 thread.",
                        &[diagnostics::MessageArg::Code(&e)],
                    )
                    .severity(diagnostics::Severity::Warning),
            );
            1
        }
    };
    drop(main_thread_logger);

    rayon::ThreadPoolBuilder::new()
        .num_threads(num_threads)
        .build_global()
        .unwrap();

    let trap_compression =
        match trap::Compression::from_env("CODEQL_EXTRACTOR_PHP_OPTION_TRAP_COMPRESSION") {
            Ok(x) => x,
            Err(_) => trap::Compression::Gzip,
        };

    let src_archive_dir = file_paths::path_from_string(&options.source_archive_dir);
    let trap_dir = file_paths::path_from_string(&options.output_dir);
    let file_list = fs::File::open(file_paths::path_from_string(&options.file_list))?;

    let overlay_changed_files: Option<HashSet<PathBuf>> = get_overlay_changed_files();
    let path_transformer: Option<PathTransformer> = file_paths::load_path_transformer()?;

    let language: Language = tree_sitter_php::LANGUAGE_PHP.into();
    let schema = node_types::read_node_types_str("php", tree_sitter_php::PHP_NODE_TYPES)?;

    let lines: std::io::Result<Vec<String>> = std::io::BufReader::new(file_list).lines().collect();
    let lines = lines?;

    lines
        .par_iter()
        .try_for_each(|line| {
            let mut diagnostics_writer = diagnostics.logger();
            let path = PathBuf::from(line).canonicalize()?;
            match &overlay_changed_files {
                Some(changed_files) if !changed_files.contains(&path) => {
                    return Result::Ok(());
                }
                _ => {}
            }

            let src_archive_file =
                file_paths::path_for(&src_archive_dir, &path, "", path_transformer.as_ref());

            let source = std::fs::read(&path)?;
            let mut trap_writer = trap::Writer::new();
            extractor::extract(
                &language,
                "php",
                &schema,
                &mut diagnostics_writer,
                &mut trap_writer,
                path_transformer.as_ref(),
                &path,
                &source,
                &[],
            );

            std::fs::create_dir_all(src_archive_file.parent().unwrap())?;
            std::fs::copy(&path, &src_archive_file)?;
            write_trap(
                &trap_dir,
                path,
                &trap_writer,
                trap_compression,
                path_transformer.as_ref(),
            )
        })
        .expect("failed to extract files");

    let path = PathBuf::from("extras");
    let mut trap_writer = trap::Writer::new();
    extractor::populate_empty_location(&mut trap_writer);
    let res = write_trap(
        &trap_dir,
        path,
        &trap_writer,
        trap_compression,
        path_transformer.as_ref(),
    );

    if let Ok(output_path) = std::env::var("CODEQL_EXTRACTOR_PHP_OVERLAY_BASE_METADATA_OUT") {
        std::fs::write(output_path, b"")?;
    }

    tracing::info!("Extraction complete");
    res
}

fn get_overlay_changed_files() -> Option<HashSet<PathBuf>> {
    let changed_files_file = std::env::var("CODEQL_EXTRACTOR_PHP_OVERLAY_CHANGED_FILES").ok()?;
    let lines: std::io::Result<Vec<String>> =
        std::io::BufReader::new(std::fs::File::open(changed_files_file).ok()?)
            .lines()
            .collect();
    let lines = lines.ok()?;
    Some(lines.into_iter().map(PathBuf::from).collect())
}

fn write_trap(
    trap_dir: &Path,
    path: PathBuf,
    trap_writer: &trap::Writer,
    compression: trap::Compression,
    path_transformer: Option<&PathTransformer>,
) -> std::io::Result<()> {
    let output_path = file_paths::path_for(trap_dir, &path, "trap.gz", path_transformer);
    std::fs::create_dir_all(output_path.parent().unwrap())?;
    trap_writer.write_to_file(&output_path, compression)
}

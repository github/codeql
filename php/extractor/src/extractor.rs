use clap::Args;
use codeql_extractor::file_paths;
use rayon::prelude::*;
use std::collections::HashSet;
use std::fs;
use std::io::BufRead;
use std::path::PathBuf;
use tree_sitter::Language;

use codeql_extractor::{diagnostics, extractor, node_types, trap};

#[derive(Args)]
pub struct Options {
    /// Sets a custom source archive folder
    #[arg(long)]
    source_archive_dir: String,

    /// Sets a custom trap folder
    #[arg(long)]
    output_dir: String,

    /// A text file containing the paths of the files to extract
    #[arg(long)]
    file_list: String,
}

fn get_overlay_changed_files() -> Option<HashSet<PathBuf>> {
    let path = std::env::var("CODEQL_EXTRACTOR_PHP_OVERLAY_CHANGED_FILES").ok()?;
    let contents = fs::read_to_string(path).ok()?;
    Some(
        contents
            .lines()
            .filter(|l| !l.is_empty())
            .map(|l| PathBuf::from(l).canonicalize().unwrap_or_else(|_| PathBuf::from(l)))
            .collect(),
    )
}

pub fn run(options: Options) -> std::io::Result<()> {
    extractor::set_tracing_level("php");
    tracing::info!("PHP extraction started");
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
    tracing::info!(
        "Using {} {}",
        num_threads,
        if num_threads == 1 {
            "thread"
        } else {
            "threads"
        }
    );
    let trap_compression =
        match trap::Compression::from_env("CODEQL_EXTRACTOR_PHP_OPTION_TRAP_COMPRESSION") {
            Ok(x) => x,
            Err(e) => {
                main_thread_logger.write(
                    main_thread_logger
                        .new_entry("configuration-error", "Configuration error")
                        .message("{}; using gzip.", &[diagnostics::MessageArg::Code(&e)])
                        .severity(diagnostics::Severity::Warning),
                );
                trap::Compression::Gzip
            }
        };
    drop(main_thread_logger);
    rayon::ThreadPoolBuilder::new()
        .num_threads(num_threads)
        .build_global()
        .unwrap();

    let src_archive_dir = file_paths::path_from_string(&options.source_archive_dir);
    let trap_dir = file_paths::path_from_string(&options.output_dir);
    let file_list = fs::File::open(file_paths::path_from_string(&options.file_list))?;

    let overlay_changed_files: Option<HashSet<PathBuf>> = get_overlay_changed_files();
    let path_transformer = file_paths::load_path_transformer()?;

    let language: Language = tree_sitter_php::LANGUAGE_PHP.into();
    let schema = node_types::read_node_types_str("php", tree_sitter_php::PHP_NODE_TYPES)?;

    let lines: std::io::Result<Vec<String>> = std::io::BufReader::new(file_list).lines().collect();
    let lines = lines?;
    lines
        .par_iter()
        .try_for_each(|line| -> std::io::Result<()> {
            let mut diagnostics_writer = diagnostics.logger();
            let path = PathBuf::from(line).canonicalize()?;
            match &overlay_changed_files {
                Some(changed_files) if !changed_files.contains(&path) => {
                    return Ok(());
                }
                _ => {}
            }
            let src_archive_file =
                file_paths::path_for(&src_archive_dir, &path, "", path_transformer.as_ref());
            let source = std::fs::read(&path)?;
            let mut trap_writer = trap::Writer::new();
            tracing::info!("extracting: {}", path.display());
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

            let trap_ext = format!(".{}", trap_compression.extension());
            let trap_file = file_paths::path_for(&trap_dir, &path, &trap_ext, path_transformer.as_ref());
            std::fs::create_dir_all(trap_file.parent().unwrap())?;
            trap_writer
                .write_to_file(&trap_file, trap_compression)
                .unwrap_or_else(|e| {
                    tracing::error!("Failed to write trap file {}: {}", trap_file.display(), e);
                });

            std::fs::create_dir_all(src_archive_file.parent().unwrap())?;
            std::fs::copy(&path, &src_archive_file)?;
            Ok(())
        })?;
    tracing::info!("PHP extraction completed");
    Ok(())
}

use crate::trap;
use rayon::prelude::*;
use std::collections::HashMap;
use std::ffi::{OsStr, OsString};
use std::fs::File;
use std::io::BufRead;
use std::path::{Path, PathBuf};

use crate::diagnostics;
use crate::node_types;

pub struct LanguageSpec {
    pub prefix: &'static str,
    pub ts_language: tree_sitter::Language,
    pub node_types: &'static str,
    pub file_extensions: Vec<OsString>,
}

pub struct Extractor {
    pub prefix: String,
    pub languages: Vec<LanguageSpec>,
    pub trap_dir: PathBuf,
    pub source_archive_dir: PathBuf,
    pub file_list: PathBuf,
    // Typically constructed via `trap::Compression::from_env`.
    // This allow us to report the error using our diagnostics system
    // without exposing it to consumers.
    pub trap_compression: Result<trap::Compression, String>,
}

impl Extractor {
    pub fn run(&self) -> std::io::Result<()> {
        let diagnostics = diagnostics::DiagnosticLoggers::new(&self.prefix);
        let mut main_thread_logger = diagnostics.logger();
        let num_threads = match crate::options::num_threads() {
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
        let trap_compression = match &self.trap_compression {
            Ok(x) => *x,
            Err(e) => {
                main_thread_logger.write(
                    main_thread_logger
                        .new_entry("configuration-error", "Configuration error")
                        .message("{}; using gzip.", &[diagnostics::MessageArg::Code(e)])
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

        let file_list = File::open(&self.file_list)?;

        let mut schemas = vec![];
        for lang in &self.languages {
            let schema = node_types::read_node_types_str(lang.prefix, lang.node_types)?;
            schemas.push(schema);
        }

        // Construct a map from file extension -> LanguageSpec
        let mut file_extension_language_mapping: HashMap<&OsStr, Vec<usize>> = HashMap::new();
        for (i, lang) in self.languages.iter().enumerate() {
            for (j, _ext) in lang.file_extensions.iter().enumerate() {
                let indexes = file_extension_language_mapping
                    .entry(&lang.file_extensions[j])
                    .or_default();
                indexes.push(i);
            }
        }

        let lines: std::io::Result<Vec<String>> =
            std::io::BufReader::new(file_list).lines().collect();
        let lines = lines?;

        lines
            .par_iter()
            .try_for_each(|line| {
                let mut diagnostics_writer = diagnostics.logger();
                let path = PathBuf::from(line).canonicalize()?;
                let src_archive_file =
                    crate::file_paths::path_for(&self.source_archive_dir, &path, "");
                let source = std::fs::read(&path)?;
                let mut trap_writer = trap::Writer::new();

                match path.extension() {
                    None => {
                        tracing::error!(?path, "No extension found, skipping file.");
                    }
                    Some(ext) => {
                        if let Some(indexes) = file_extension_language_mapping.get(ext) {
                            for i in indexes {
                                let lang = &self.languages[*i];
                                crate::extractor::extract(
                                    lang.ts_language,
                                    lang.prefix,
                                    &schemas[*i],
                                    &mut diagnostics_writer,
                                    &mut trap_writer,
                                    &path,
                                    &source,
                                    &[],
                                );
                                std::fs::create_dir_all(src_archive_file.parent().unwrap())?;
                                std::fs::copy(&path, &src_archive_file)?;
                                write_trap(&self.trap_dir, &path, &trap_writer, trap_compression)?;
                            }
                        } else {
                            tracing::warn!(?path, "No language matches path, skipping file.");
                        }
                    }
                };
                Ok(()) as std::io::Result<()>
            })
            .expect("failed to extract files");

        let path = PathBuf::from("extras");
        let mut trap_writer = trap::Writer::new();
        crate::extractor::populate_empty_location(&mut trap_writer);

        write_trap(&self.trap_dir, &path, &trap_writer, trap_compression)
    }
}

fn write_trap(
    trap_dir: &Path,
    path: &Path,
    trap_writer: &trap::Writer,
    trap_compression: trap::Compression,
) -> std::io::Result<()> {
    let trap_file = crate::file_paths::path_for(trap_dir, path, trap_compression.extension());
    std::fs::create_dir_all(trap_file.parent().unwrap())?;
    trap_writer.write_to_file(&trap_file, trap_compression)
}

use crate::trap;
use globset::{GlobBuilder, GlobSetBuilder};
use rayon::prelude::*;
use std::fs::File;
use std::io::BufRead;
use std::path::{Path, PathBuf};

use crate::diagnostics;
use crate::node_types;

pub struct LanguageSpec {
    pub prefix: &'static str,
    pub ts_language: tree_sitter::Language,
    pub node_types: &'static str,
    pub file_globs: Vec<String>,
}

pub struct Extractor {
    pub prefix: String,
    pub languages: Vec<LanguageSpec>,
    pub trap_dir: PathBuf,
    pub source_archive_dir: PathBuf,
    pub file_lists: Vec<PathBuf>,
    // Typically constructed via `trap::Compression::from_env`.
    // This allow us to report the error using our diagnostics system
    // without exposing it to consumers.
    pub trap_compression: Result<trap::Compression, String>,
}

impl Extractor {
    pub fn run(&self) -> std::io::Result<()> {
        tracing::info!("Extraction started");
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

        let file_lists: Vec<File> = self
            .file_lists
            .iter()
            .map(|file_list| {
                File::open(file_list)
                    .unwrap_or_else(|_| panic!("Unable to open file list at {:?}", file_list))
            })
            .collect();

        let mut schemas = vec![];
        for lang in &self.languages {
            let schema = node_types::read_node_types_str(lang.prefix, lang.node_types)?;
            schemas.push(schema);
        }

        // Construct a single globset containing all language globs,
        // and a mapping from glob index to language index.
        let (globset, glob_language_mapping) = {
            let mut builder = GlobSetBuilder::new();
            let mut glob_lang_mapping = vec![];
            for (i, lang) in self.languages.iter().enumerate() {
                for glob_str in &lang.file_globs {
                    let glob = GlobBuilder::new(glob_str)
                        .literal_separator(true)
                        .build()
                        .expect("invalid glob");
                    builder.add(glob);
                    glob_lang_mapping.push(i);
                }
            }
            (
                builder.build().expect("failed to build globset"),
                glob_lang_mapping,
            )
        };

        let lines: std::io::Result<Vec<String>> = file_lists
            .iter()
            .flat_map(|file_list| std::io::BufReader::new(file_list).lines())
            .collect();
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

                match path.file_name() {
                    None => {
                        tracing::error!(?path, "No file name found, skipping file.");
                    }
                    Some(filename) => {
                        let matches = globset.matches(filename);
                        if matches.is_empty() {
                            tracing::error!(?path, "No matching language found, skipping file.");
                        } else {
                            let mut languages_processed = vec![false; self.languages.len()];

                            for m in matches {
                                let i = glob_language_mapping[m];
                                if languages_processed[i] {
                                    continue;
                                }
                                languages_processed[i] = true;
                                let lang = &self.languages[i];

                                crate::extractor::extract(
                                    &lang.ts_language,
                                    lang.prefix,
                                    &schemas[i],
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
                        }
                    }
                }
                Ok(()) as std::io::Result<()>
            })
            .expect("failed to extract files");

        let path = PathBuf::from("extras");
        let mut trap_writer = trap::Writer::new();
        crate::extractor::populate_empty_location(&mut trap_writer);

        let res = write_trap(&self.trap_dir, &path, &trap_writer, trap_compression);
        tracing::info!("Extraction complete");
        res
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

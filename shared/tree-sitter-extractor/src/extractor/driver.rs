//! Shared multi-file extraction driver.
//!
//! The `simple` (direct tree-sitter) and `desugaring` (parse + desugar)
//! extractors differ only in how a language's schema is built and how a single
//! file is extracted. Everything else — threading, matching files to languages
//! by glob, writing TRAP, and copying into the source archive — is identical
//! and lives here, parameterised over the [`LanguageExtractor`] trait.

use globset::{GlobBuilder, GlobSetBuilder};
use rayon::prelude::*;
use std::fs::File;
use std::io::BufRead;
use std::path::{Path, PathBuf};

use crate::diagnostics;
use crate::file_paths;
use crate::node_types::NodeTypeMap;
use crate::trap;

/// A language that [`run_extractor`] can process: it knows its file globs, its
/// TRAP schema, and how to extract a single file. Implemented by
/// [`super::simple::LanguageSpec`] (direct tree-sitter extraction) and
/// [`super::desugaring::LanguageSpec`] (parse into an AST and desugar it).
pub(crate) trait LanguageExtractor: Sync {
    /// The file-name globs that select files for this language.
    fn file_globs(&self) -> &[String];
    /// Build the TRAP node-type schema used to validate emitted tuples.
    fn build_schema(&self) -> std::io::Result<NodeTypeMap>;
    /// Extract a single file's `source` into `trap_writer`.
    ///
    /// A returned error is logged as a failure of this file only; the driver
    /// archives its source, omits its TRAP, and continues.
    fn extract_file(
        &self,
        schema: &NodeTypeMap,
        diagnostics_writer: &mut diagnostics::LogWriter,
        trap_writer: &mut trap::Writer,
        path: &Path,
        source: &[u8],
    ) -> Result<(), String>;
}

/// Drive extraction over `languages` for every file listed in `file_lists`.
///
/// Sets up the thread pool, builds a combined glob set, and for each input file
/// dispatches to the matching language's [`LanguageExtractor::extract_file`],
/// writing the resulting TRAP and a source-archive copy.
pub(crate) fn run_extractor<L: LanguageExtractor>(
    prefix: &str,
    languages: &[L],
    trap_dir: &Path,
    source_archive_dir: &Path,
    file_lists: &[PathBuf],
    trap_compression: &Result<trap::Compression, String>,
) -> std::io::Result<()> {
    tracing::info!("Extraction started");
    let diagnostics = diagnostics::DiagnosticLoggers::new(prefix);
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
    let trap_compression = match trap_compression {
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

    let file_lists: Vec<File> = file_lists
        .iter()
        .map(|file_list| {
            File::open(file_list)
                .unwrap_or_else(|_| panic!("Unable to open file list at {file_list:?}"))
        })
        .collect();

    let mut schemas = vec![];
    for lang in languages {
        schemas.push(lang.build_schema()?);
    }

    // Construct a single globset containing all language globs,
    // and a mapping from glob index to language index.
    let (globset, glob_language_mapping) = {
        let mut builder = GlobSetBuilder::new();
        let mut glob_lang_mapping = vec![];
        for (i, lang) in languages.iter().enumerate() {
            for glob_str in lang.file_globs() {
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

    let path_transformer = file_paths::load_path_transformer()?;

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
            let src_archive_file = crate::file_paths::path_for(
                source_archive_dir,
                &path,
                "",
                path_transformer.as_ref(),
            );
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
                        let mut languages_processed = vec![false; languages.len()];

                        for m in matches {
                            let i = glob_language_mapping[m];
                            if languages_processed[i] {
                                continue;
                            }
                            languages_processed[i] = true;
                            let lang = &languages[i];

                            let result = lang.extract_file(
                                &schemas[i],
                                &mut diagnostics_writer,
                                &mut trap_writer,
                                &path,
                                &source,
                            );
                            std::fs::create_dir_all(src_archive_file.parent().unwrap())?;
                            std::fs::copy(&path, &src_archive_file)?;
                            match result {
                                Ok(()) => {
                                    write_trap(trap_dir, &path, &trap_writer, trap_compression)?;
                                }
                                Err(error) => {
                                    tracing::error!(
                                        file = %path.display(),
                                        error,
                                        "Failed to extract file"
                                    );
                                }
                            }
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

    let res = write_trap(trap_dir, &path, &trap_writer, trap_compression);
    tracing::info!("Extraction complete");
    res
}

fn write_trap(
    trap_dir: &Path,
    path: &Path,
    trap_writer: &trap::Writer,
    trap_compression: trap::Compression,
) -> std::io::Result<()> {
    let trap_file = crate::file_paths::path_for(trap_dir, path, trap_compression.extension(), None);
    std::fs::create_dir_all(trap_file.parent().unwrap())?;
    trap_writer.write_to_file(&trap_file, trap_compression)
}

#[cfg(test)]
mod tests {
    use super::*;
    use std::io::Write;

    struct TestLanguage {
        file_globs: Vec<String>,
    }

    impl LanguageExtractor for TestLanguage {
        fn file_globs(&self) -> &[String] {
            &self.file_globs
        }

        fn build_schema(&self) -> std::io::Result<NodeTypeMap> {
            Ok(NodeTypeMap::new())
        }

        fn extract_file(
            &self,
            _schema: &NodeTypeMap,
            _diagnostics_writer: &mut diagnostics::LogWriter,
            trap_writer: &mut trap::Writer,
            _path: &Path,
            source: &[u8],
        ) -> Result<(), String> {
            if source == b"bad" {
                Err("invalid parser output".to_string())
            } else {
                trap_writer.comment("success".to_string());
                Ok(())
            }
        }
    }

    #[test]
    fn file_extraction_error_does_not_abort_other_files() {
        let root = std::env::temp_dir().join(format!("codeql-extractor-{}", rand::random::<u64>()));
        let source_dir = root.join("input");
        let source_archive_dir = root.join("source-archive");
        let trap_dir = root.join("trap");
        std::fs::create_dir_all(&source_dir).unwrap();

        let good_path = source_dir.join("good.test");
        let bad_path = source_dir.join("bad.test");
        std::fs::write(&good_path, b"good").unwrap();
        std::fs::write(&bad_path, b"bad").unwrap();

        let file_list = root.join("files.txt");
        let mut file = std::fs::File::create(&file_list).unwrap();
        writeln!(file, "{}", good_path.display()).unwrap();
        writeln!(file, "{}", bad_path.display()).unwrap();

        run_extractor(
            "test",
            &[TestLanguage {
                file_globs: vec!["*.test".to_string()],
            }],
            &trap_dir,
            &source_archive_dir,
            &[file_list],
            &Ok(trap::Compression::Gzip),
        )
        .unwrap();

        let good_trap = file_paths::path_for(&trap_dir, &good_path, "trap.gz", None);
        let bad_trap = file_paths::path_for(&trap_dir, &bad_path, "trap.gz", None);
        assert!(good_trap.is_file());
        assert!(!bad_trap.exists());

        let archived_good = file_paths::path_for(&source_archive_dir, &good_path, "", None);
        let archived_bad = file_paths::path_for(&source_archive_dir, &bad_path, "", None);
        assert!(archived_good.is_file());
        assert!(archived_bad.is_file());

        std::fs::remove_dir_all(root).unwrap();
    }
}

use crate::trap;
use std::path::PathBuf;

use crate::diagnostics;
use crate::extractor::driver::{self, LanguageExtractor};
use crate::node_types::{self, NodeTypeMap};

/// A tree-sitter language extracted directly from its parse tree, with no
/// desugaring. Comments and other `extra` nodes are emitted inline as tokens.
/// Languages that rewrite their syntax tree use
/// [`crate::extractor::desugaring`] instead.
pub struct LanguageSpec {
    pub prefix: &'static str,
    pub ts_language: tree_sitter::Language,
    pub node_types: &'static str,
    pub file_globs: Vec<String>,
}

impl LanguageExtractor for LanguageSpec {
    fn file_globs(&self) -> &[String] {
        &self.file_globs
    }

    fn build_schema(&self) -> std::io::Result<NodeTypeMap> {
        node_types::read_node_types_str(self.prefix, self.node_types)
    }

    fn extract_file(
        &self,
        schema: &NodeTypeMap,
        diagnostics_writer: &mut diagnostics::LogWriter,
        trap_writer: &mut trap::Writer,
        path: &std::path::Path,
        source: &[u8],
    ) {
        crate::extractor::extract(
            &self.ts_language,
            self.prefix,
            schema,
            diagnostics_writer,
            trap_writer,
            None,
            path,
            source,
            &[],
        );
    }
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
        driver::run_extractor(
            &self.prefix,
            &self.languages,
            &self.trap_dir,
            &self.source_archive_dir,
            &self.file_lists,
            &self.trap_compression,
        )
    }
}

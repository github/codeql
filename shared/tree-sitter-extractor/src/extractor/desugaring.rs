//! Extraction for languages that rewrite their syntax tree before extraction.
//!
//! Unlike [`crate::extractor::simple`] (direct tree-sitter extraction), a
//! desugaring language parses source into a [`ParsedTree`] — a `yeast::Ast`
//! plus side-channel `extra` tokens (comments and similar) — and rewrites the
//! AST through a [`yeast::Desugarer`] before emitting TRAP. The parser is a
//! closure, so both tree-sitter grammars (via
//! [`crate::extractor::tree_sitter_parser`]) and fully custom parsers plug in
//! the same way.

use crate::trap;
use std::path::PathBuf;

use crate::diagnostics;
use crate::extractor::ParsedTree;
use crate::extractor::driver::{self, LanguageExtractor};
use crate::node_types::{self, NodeTypeMap};

/// A parser turns source bytes into a [`ParsedTree`]. Tree-sitter grammars plug
/// in via [`crate::extractor::tree_sitter_parser`]; custom (non-tree-sitter)
/// parsers supply their own closure.
pub type Parser = Box<dyn Fn(&[u8]) -> Result<ParsedTree, String> + Send + Sync>;

pub struct LanguageSpec {
    pub prefix: &'static str,
    /// The parser: source -> `yeast::Ast` + `extra` tokens (see [`Parser`]).
    pub parser: Parser,
    /// Fallback TRAP schema, used only when `desugarer` does not supply its own
    /// output schema (via [`yeast::Desugarer::output_node_types_yaml`]). May be
    /// empty for a custom parser whose desugarer always provides the schema.
    pub node_types: &'static str,
    /// The desugarer applied to the parsed AST before extraction. Its
    /// `output_node_types_yaml()` (when set) provides the TRAP schema.
    ///
    /// `Box<dyn yeast::Desugarer>` so the shared extractor is agnostic to the
    /// user-defined context type the desugarer uses internally.
    pub desugarer: Box<dyn yeast::Desugarer>,
    pub file_globs: Vec<String>,
}

impl LanguageExtractor for LanguageSpec {
    fn file_globs(&self) -> &[String] {
        &self.file_globs
    }

    fn build_schema(&self) -> std::io::Result<NodeTypeMap> {
        let effective_node_types: String = match self.desugarer.output_node_types_yaml() {
            Some(yaml) => yeast::node_types_yaml::convert(yaml).map_err(|e| {
                std::io::Error::other(format!(
                    "Failed to convert YAML node-types to JSON for {}: {e}",
                    self.prefix
                ))
            })?,
            None => self.node_types.to_string(),
        };
        node_types::read_node_types_str(self.prefix, &effective_node_types)
    }

    fn extract_file(
        &self,
        schema: &NodeTypeMap,
        diagnostics_writer: &mut diagnostics::LogWriter,
        trap_writer: &mut trap::Writer,
        path: &std::path::Path,
        source: &[u8],
    ) {
        crate::extractor::extract_parsed(
            self.parser.as_ref(),
            self.prefix,
            schema,
            diagnostics_writer,
            trap_writer,
            None,
            path,
            source,
            self.desugarer.as_ref(),
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

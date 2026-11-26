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
use std::collections::BTreeMap;
use std::path::PathBuf;

use crate::diagnostics;
use crate::extractor::ParsedTree;
use crate::extractor::driver::{self, LanguageExtractor};
use crate::node_types::{self, NodeTypeMap};
use extractor_common::file_paths;

/// A parser turns source bytes into a [`ParsedTree`]. Tree-sitter grammars plug
/// in via [`crate::extractor::tree_sitter_parser`]; custom (non-tree-sitter)
/// parsers supply their own closure.
pub type Parser = Box<dyn Fn(&[u8]) -> Result<ParsedTree, String> + Send + Sync>;
pub type OutputLabels = BTreeMap<yeast::OutputId, Vec<trap::Label>>;
pub type PostExtract<C> =
    Box<dyn Fn(&C, &OutputLabels, &mut trap::Writer) -> Result<(), String> + Send + Sync>;

trait LanguagePipeline: Send + Sync {
    fn output_node_types_yaml(&self) -> &'static str;
    fn parse(&self, source: &[u8]) -> Result<ParsedTree, String>;
    fn desugar(&self, ast: yeast::Ast) -> Result<yeast::OutputAst, String>;
    fn extract_file(
        &self,
        language_prefix: &str,
        schema: &NodeTypeMap,
        diagnostics_writer: &mut diagnostics::LogWriter,
        trap_writer: &mut trap::Writer,
        path: &std::path::Path,
        source: &[u8],
    ) -> Result<(), String>;
}

struct DesugaringPipeline<C: Default + Clone + 'static> {
    parser: Parser,
    desugarer: yeast::ConcreteDesugarer<C>,
    output_node_types_yaml: &'static str,
    post_extract: Option<PostExtract<C>>,
}

pub struct LanguageSpec {
    pub prefix: &'static str,
    pipeline: Box<dyn LanguagePipeline>,
    pub file_globs: Vec<String>,
}

pub struct LanguageSpecBuilder<C> {
    pub prefix: &'static str,
    pub parser: Parser,
    pub desugaring: yeast::DesugaringConfig<C>,
    pub file_globs: Vec<String>,
    pub post_extract: Option<PostExtract<C>>,
}

impl<C> LanguageSpecBuilder<C>
where
    C: Default + Clone + 'static,
{
    pub fn build(self) -> Result<LanguageSpec, String> {
        let output_node_types_yaml = self
            .desugaring
            .output_node_types_yaml
            .ok_or("a language-free desugarer requires output_node_types_yaml to be set")?;
        let pipeline = DesugaringPipeline {
            parser: self.parser,
            desugarer: yeast::ConcreteDesugarer::without_language(self.desugaring)?,
            output_node_types_yaml,
            post_extract: self.post_extract,
        };
        Ok(LanguageSpec {
            prefix: self.prefix,
            pipeline: Box::new(pipeline),
            file_globs: self.file_globs,
        })
    }
}

impl<C> LanguagePipeline for DesugaringPipeline<C>
where
    C: Default + Clone + 'static,
{
    fn output_node_types_yaml(&self) -> &'static str {
        self.output_node_types_yaml
    }

    fn parse(&self, source: &[u8]) -> Result<ParsedTree, String> {
        (self.parser)(source)
    }

    fn desugar(&self, ast: yeast::Ast) -> Result<yeast::OutputAst, String> {
        self.desugarer.run_from_ast_with_ctx(ast, &C::default())
    }

    fn extract_file(
        &self,
        language_prefix: &str,
        schema: &NodeTypeMap,
        diagnostics_writer: &mut diagnostics::LogWriter,
        trap_writer: &mut trap::Writer,
        path: &std::path::Path,
        source: &[u8],
    ) -> Result<(), String> {
        let path_str = file_paths::normalize_and_transform_path(path, None);
        let span = tracing::span!(tracing::Level::TRACE, "extract", file = %path_str);
        let _enter = span.enter();
        tracing::debug!("extracting: {}", path_str);

        let parsed = self
            .parse(source)
            .map_err(|error| format!("Parsing failed: {error}"))?;
        let context = C::default();
        let ast = self
            .desugarer
            .run_from_ast_with_ctx(parsed.ast, &context)
            .map_err(|error| format!("Desugaring failed: {error}"))?;
        let labels = crate::extractor::extract_output_ast(
            language_prefix,
            schema,
            diagnostics_writer,
            trap_writer,
            None,
            path,
            source,
            &ast,
            &parsed.extras,
        )?;
        match &self.post_extract {
            Some(post_extract) => post_extract(&context, &labels, trap_writer),
            None => Ok(()),
        }
    }
}

impl LanguageSpec {
    pub fn parse(&self, source: &[u8]) -> Result<ParsedTree, String> {
        self.pipeline.parse(source)
    }

    pub fn desugar(&self, ast: yeast::Ast) -> Result<yeast::OutputAst, String> {
        self.pipeline.desugar(ast)
    }
}

impl LanguageExtractor for LanguageSpec {
    fn file_globs(&self) -> &[String] {
        &self.file_globs
    }

    fn build_schema(&self) -> std::io::Result<NodeTypeMap> {
        let effective_node_types = yeast::node_types_yaml::convert(
            self.pipeline.output_node_types_yaml(),
        )
        .map_err(|e| {
            std::io::Error::other(format!(
                "Failed to convert YAML node-types to JSON for {}: {e}",
                self.prefix
            ))
        })?;
        node_types::read_node_types_str(self.prefix, &effective_node_types)
    }

    fn extract_file(
        &self,
        schema: &NodeTypeMap,
        diagnostics_writer: &mut diagnostics::LogWriter,
        trap_writer: &mut trap::Writer,
        path: &std::path::Path,
        source: &[u8],
    ) -> Result<(), String> {
        self.pipeline.extract_file(
            self.prefix,
            schema,
            diagnostics_writer,
            trap_writer,
            path,
            source,
        )
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

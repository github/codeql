use anyhow::Context;
use ra_ap_ide_db::line_index::LineIndex;
use ra_ap_parser::Edition;
use std::borrow::Cow;
mod archive;
mod config;
pub mod generated;
mod translate;
pub mod trap;
use ra_ap_syntax::ast::SourceFile;
use ra_ap_syntax::{AstNode, SyntaxError, TextRange, TextSize};

fn from_utf8_lossy(v: &[u8]) -> (Cow<'_, str>, Option<SyntaxError>) {
    let mut iter = v.utf8_chunks();
    let (first_valid, first_invalid) = if let Some(chunk) = iter.next() {
        let valid = chunk.valid();
        let invalid = chunk.invalid();
        if invalid.is_empty() {
            debug_assert_eq!(valid.len(), v.len());
            return (Cow::Borrowed(valid), None);
        }
        (valid, invalid)
    } else {
        return (Cow::Borrowed(""), None);
    };

    const REPLACEMENT: &str = "\u{FFFD}";
    let error_start = first_valid.len() as u32;
    let error_end = error_start + first_invalid.len() as u32;
    let error_range = TextRange::new(TextSize::new(error_start), TextSize::new(error_end));
    let error = SyntaxError::new("invalid utf-8 sequence".to_owned(), error_range);
    let mut res = String::with_capacity(v.len());
    res.push_str(first_valid);

    res.push_str(REPLACEMENT);

    for chunk in iter {
        res.push_str(chunk.valid());
        if !chunk.invalid().is_empty() {
            res.push_str(REPLACEMENT);
        }
    }

    (Cow::Owned(res), Some(error))
}

fn extract(
    archiver: &archive::Archiver,
    traps: &trap::TrapFileProvider,
    file: std::path::PathBuf,
) -> anyhow::Result<()> {
    let file = std::path::absolute(&file).unwrap_or(file);
    let file = std::fs::canonicalize(&file).unwrap_or(file);
    archiver.archive(&file);
    let input = std::fs::read(&file)?;
    let (input, err) = from_utf8_lossy(&input);
    let line_index = LineIndex::new(&input);
    let display_path = file.to_string_lossy();
    let mut trap = traps.create("source", &file);
    let label = trap.emit_file(&file);
    let mut translator = translate::Translator::new(trap, label, line_index);
    if let Some(err) = err {
        translator.emit_parse_error(display_path.as_ref(), err);
    }
    let parse = ra_ap_syntax::ast::SourceFile::parse(&input, Edition::CURRENT);
    for err in parse.errors() {
        translator.emit_parse_error(display_path.as_ref(), err);
    }
    if let Some(ast) = SourceFile::cast(parse.syntax_node()) {
        translator.emit_source_file(ast);
    } else {
        log::warn!("Skipped {}", display_path);
    }
    translator.trap.commit()?;
    Ok(())
}
fn main() -> anyhow::Result<()> {
    let cfg = config::Config::extract().context("failed to load configuration")?;
    stderrlog::new()
        .module(module_path!())
        .verbosity(2 + cfg.verbose as usize)
        .init()?;
    log::info!("{cfg:?}");
    let traps = trap::TrapFileProvider::new(&cfg).context("failed to set up trap files")?;
    let archiver = archive::Archiver {
        root: cfg.source_archive_dir,
    };
    for file in cfg.inputs {
        extract(&archiver, &traps, file)?;
    }

    Ok(())
}

use anyhow::Context;
use ra_ap_ide_db::line_index::LineIndex;
use ra_ap_parser::Edition;
mod archive;
mod config;
pub mod generated;
mod translate;
pub mod trap;
use ra_ap_syntax::ast::SourceFile;
use ra_ap_syntax::AstNode;

pub fn extract(
    archiver: &archive::Archiver,
    traps: &trap::TrapFileProvider,
    file: std::path::PathBuf,
) -> anyhow::Result<()> {
    let file = std::path::absolute(&file).unwrap_or(file);
    let file = std::fs::canonicalize(&file).unwrap_or(file);
    archiver.archive(&file);
    let input = std::fs::read(&file)?;
    let input = String::from_utf8(input)?;
    let line_index = LineIndex::new(&input);
    let display_path = file.to_string_lossy();
    let mut trap = traps.create("source", &file);
    let label = trap.emit_file(&file);
    let mut translator = translate::Translator::new(trap, label, line_index);

    let parse = ra_ap_syntax::ast::SourceFile::parse(&input, Edition::CURRENT);
    for err in parse.errors() {
        let (start, _) = translator.location(err.range());
        log::warn!("{}:{}:{}: {}", display_path, start.line, start.col, err);
    }
    if let Some(ast) = SourceFile::cast(parse.syntax_node()) {
        translator.emit_source_file(ast);
        translator.trap.commit()?
    } else {
        log::warn!("Skipped {}", display_path);
    }
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

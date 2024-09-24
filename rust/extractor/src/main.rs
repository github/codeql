use anyhow::Context;
use ra_ap_ide_db::line_index::LineIndex;
mod archive;
mod config;
pub mod generated;
mod rust_analyzer;
mod translate;
pub mod trap;

fn extract(
    rust_analyzer: &rust_analyzer::RustAnalyzer,
    traps: &trap::TrapFileProvider,
    file: std::path::PathBuf,
) -> anyhow::Result<()> {
    let (ast, input, parse_errors, semi) = rust_analyzer.parse(&file);
    let line_index = LineIndex::new(input.as_ref());
    let display_path = file.to_string_lossy();
    let mut trap = traps.create("source", &file);
    let label = trap.emit_file(&file);
    let mut translator = translate::Translator::new(trap, label, line_index, semi);

    for err in parse_errors {
        translator.emit_parse_error(display_path.as_ref(), err);
    }
    translator.emit_source_file(ast);
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
    let rust_analyzer = rust_analyzer::RustAnalyzer::new(&cfg)?;

    let traps = trap::TrapFileProvider::new(&cfg).context("failed to set up trap files")?;
    let archiver = archive::Archiver {
        root: cfg.source_archive_dir,
    };
    for file in cfg.inputs {
        let file = std::path::absolute(&file).unwrap_or(file);
        let file = std::fs::canonicalize(&file).unwrap_or(file);
        archiver.archive(&file);
        extract(&rust_analyzer, &traps, file)?;
    }

    Ok(())
}

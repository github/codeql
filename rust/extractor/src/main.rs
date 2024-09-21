use anyhow::Context;
use ra_ap_ide_db::line_index::LineIndex;
mod archive;
mod config;
pub mod generated;
mod translate;
pub mod trap;

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
        let file = std::path::absolute(&file).unwrap_or(file);
        let file = std::fs::canonicalize(&file).unwrap_or(file);
        archiver.archive(&file);
        let input = std::fs::read(&file)?;
        let input = String::from_utf8(input)?;
        let line_index = LineIndex::new(&input);
        let display_path = file.to_string_lossy();
        let mut trap = traps.create("source", &file);
        let label = trap.emit_file(&file);
        translate::SourceFileTranslator::new(trap, label, line_index)
            .extract(&display_path, &input)
            .context("writing trap file")?;
    }

    Ok(())
}

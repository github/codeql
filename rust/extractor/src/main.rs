use anyhow::Context;
use archive::Archiver;
use log::info;
use ra_ap_ide_db::line_index::{LineCol, LineIndex};
use ra_ap_project_model::ProjectManifest;
use rust_analyzer::{ParseResult, RustAnalyzer};
use std::fs::File;
use std::io::{BufRead, BufReader};
use std::{
    collections::HashMap,
    path::{Path, PathBuf},
};
mod archive;
mod config;
pub mod generated;
mod qltest;
mod rust_analyzer;
mod translate;
pub mod trap;

fn extract(
    rust_analyzer: &mut rust_analyzer::RustAnalyzer,
    archiver: &Archiver,
    traps: &trap::TrapFileProvider,
    file: &std::path::Path,
) {
    archiver.archive(file);

    let ParseResult {
        ast,
        text,
        errors,
        file_id,
        semantics,
    } = rust_analyzer.parse(file);
    let line_index = LineIndex::new(text.as_ref());
    let display_path = file.to_string_lossy();
    let mut trap = traps.create("source", file);
    let label = trap.emit_file(file);
    let mut translator = translate::Translator::new(
        trap,
        display_path.as_ref(),
        label,
        line_index,
        file_id,
        semantics,
    );

    for err in errors {
        translator.emit_parse_error(&ast, &err);
    }
    let no_location = (LineCol { line: 0, col: 0 }, LineCol { line: 0, col: 0 });
    if translator.semantics.is_none() {
        translator.emit_diagnostic(
            trap::DiagnosticSeverity::Warning,
            "semantics".to_owned(),
            "semantic analyzer unavailable".to_owned(),
            "semantic analyzer unavailable: macro expansion, call graph, and type inference will be skipped.".to_owned(),
            no_location,
        );
    }
    translator.emit_source_file(ast);
    translator.trap.commit().unwrap_or_else(|err| {
        log::error!(
            "Failed to write trap file for: {}: {}",
            display_path,
            err.to_string()
        )
    });
}

fn run_extractor(mut cfg: config::Config) -> anyhow::Result<()> {
    stderrlog::new()
        .module(module_path!())
        .verbosity(cfg.verbose as usize)
        .init()?;
    if cfg.qltest {
        qltest::prepare(&mut cfg)?;
    }
    info!("configuration: {cfg:#?}\n");

    let traps = trap::TrapFileProvider::new(&cfg).context("failed to set up trap files")?;
    let archiver = archive::Archiver {
        root: cfg.source_archive_dir.clone(),
    };
    let files: Vec<PathBuf> = cfg
        .inputs
        .iter()
        .map(|file| {
            let file = std::path::absolute(file).unwrap_or(file.to_path_buf());
            std::fs::canonicalize(&file).unwrap_or(file)
        })
        .collect();
    let manifests = rust_analyzer::find_project_manifests(&files)?;
    let mut map: HashMap<&Path, (&ProjectManifest, Vec<&Path>)> = manifests
        .iter()
        .map(|x| (x.manifest_path().parent().as_ref(), (x, Vec::new())))
        .collect();
    let mut other_files = Vec::new();

    'outer: for file in &files {
        let mut p = file.as_path();
        while let Some(parent) = p.parent() {
            p = parent;
            if let Some((_, files)) = map.get_mut(parent) {
                files.push(file);
                continue 'outer;
            }
        }
        other_files.push(file);
    }
    for (manifest, files) in map.values() {
        if files.is_empty() {
            break;
        }
        let mut rust_analyzer = RustAnalyzer::new(manifest, &cfg.scratch_dir);
        for file in files {
            extract(&mut rust_analyzer, &archiver, &traps, file);
        }
    }
    let mut rust_analyzer = RustAnalyzer::WithoutDatabase();
    for file in other_files {
        extract(&mut rust_analyzer, &archiver, &traps, file);
    }

    Ok(())
}

fn main() -> anyhow::Result<()> {
    let cfg = config::Config::extract().context("failed to load configuration")?;
    let qltest = cfg.qltest;
    let qltest_log = cfg.log_dir.join("qltest.log");
    let result = std::panic::catch_unwind(|| run_extractor(cfg));
    if qltest && matches!(result, Err(_) | Ok(Err(_))) {
        // in case of failure, print out the full log
        let log = File::open(qltest_log).context("opening qltest.log")?;
        let reader = BufReader::new(log);
        for line in reader.lines() {
            println!("{}", line.context("reading qltest.log")?);
        }
    }
    result.unwrap()
}

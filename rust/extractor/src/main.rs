use crate::rust_analyzer::path_to_file_id;
use anyhow::Context;
use archive::Archiver;
use log::info;
use ra_ap_hir::Semantics;
use ra_ap_ide_db::line_index::{LineCol, LineIndex};
use ra_ap_ide_db::RootDatabase;
use ra_ap_project_model::ProjectManifest;
use ra_ap_vfs::Vfs;
use rust_analyzer::{ParseResult, RustAnalyzer};
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

struct Extractor<'a> {
    archiver: &'a Archiver,
    traps: &'a trap::TrapFileProvider,
}

impl Extractor<'_> {
    fn extract(&self, rust_analyzer: &rust_analyzer::RustAnalyzer, file: &std::path::Path) {
        self.archiver.archive(file);

        let ParseResult {
            ast,
            text,
            errors,
            semantics_info,
        } = rust_analyzer.parse(file);
        let line_index = LineIndex::new(text.as_ref());
        let display_path = file.to_string_lossy();
        let mut trap = self.traps.create("source", file);
        let label = trap.emit_file(file);
        let mut translator = translate::Translator::new(
            trap,
            display_path.as_ref(),
            label,
            line_index,
            semantics_info.as_ref().ok(),
        );

        for err in errors {
            translator.emit_parse_error(&ast, &err);
        }
        let no_location = (LineCol { line: 0, col: 0 }, LineCol { line: 0, col: 0 });
        if let Err(reason) = semantics_info {
            let message = format!("semantic analyzer unavailable ({reason})");
            let full_message = format!(
                "{message}: macro expansion, call graph, and type inference will be skipped."
            );
            translator.emit_diagnostic(
                trap::DiagnosticSeverity::Warning,
                "semantics".to_owned(),
                message,
                full_message,
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

    pub fn extract_with_semantics(
        &self,
        file: &Path,
        semantics: &Semantics<'_, RootDatabase>,
        vfs: &Vfs,
    ) {
        self.extract(&RustAnalyzer::new(vfs, semantics), file);
    }
    pub fn extract_without_semantics(&self, file: &Path, reason: &str) {
        self.extract(&RustAnalyzer::WithoutSemantics { reason }, file);
    }
}

fn main() -> anyhow::Result<()> {
    let mut cfg = config::Config::extract().context("failed to load configuration")?;
    stderrlog::new()
        .module(module_path!())
        .verbosity(2 + cfg.verbose as usize)
        .init()?;
    if cfg.qltest {
        qltest::prepare(&mut cfg)?;
    }
    info!("{cfg:#?}\n");

    let traps = trap::TrapFileProvider::new(&cfg).context("failed to set up trap files")?;
    let archiver = archive::Archiver {
        root: cfg.source_archive_dir.clone(),
    };
    let extractor = Extractor {
        archiver: &archiver,
        traps: &traps,
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

    'outer: for file in &files {
        for ancestor in file.as_path().ancestors() {
            if let Some((_, files)) = map.get_mut(ancestor) {
                files.push(file);
                continue 'outer;
            }
        }
        extractor.extract_without_semantics(file, "no manifest found");
    }
    let target_dir = &cfg
        .cargo_target_dir
        .unwrap_or_else(|| cfg.scratch_dir.join("target"));
    for (manifest, files) in map.values().filter(|(_, files)| !files.is_empty()) {
        if let Some((ref db, ref vfs)) = RustAnalyzer::load_workspace(manifest, target_dir) {
            let semantics = Semantics::new(db);
            for file in files {
                let Some(id) = path_to_file_id(file, vfs) else {
                    extractor.extract_without_semantics(
                        file,
                        "not included in files loaded from manifest",
                    );
                    continue;
                };
                if semantics.file_to_module_def(id).is_none() {
                    extractor.extract_without_semantics(file, "not included as a module");
                    continue;
                }
                extractor.extract_with_semantics(file, &semantics, vfs);
            }
        } else {
            for file in files {
                extractor.extract_without_semantics(file, "unable to load manifest");
            }
        }
    }

    Ok(())
}

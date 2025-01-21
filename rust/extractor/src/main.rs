use crate::diagnostics::{emit_extraction_diagnostics, ExtractionStep};
use crate::rust_analyzer::path_to_file_id;
use crate::trap::TrapId;
use anyhow::Context;
use archive::Archiver;
use log::{info, warn};
use ra_ap_hir::Semantics;
use ra_ap_ide_db::line_index::{LineCol, LineIndex};
use ra_ap_ide_db::RootDatabase;
use ra_ap_paths::{AbsPathBuf, Utf8PathBuf};
use ra_ap_project_model::{CargoConfig, ProjectManifest};
use ra_ap_vfs::Vfs;
use rust_analyzer::{ParseResult, RustAnalyzer};
use std::time::Instant;
use std::{
    collections::HashMap,
    path::{Path, PathBuf},
};

mod archive;
mod config;
mod diagnostics;
pub mod generated;
mod qltest;
mod rust_analyzer;
mod translate;
pub mod trap;

struct Extractor<'a> {
    archiver: &'a Archiver,
    traps: &'a trap::TrapFileProvider,
    steps: Vec<ExtractionStep>,
}

impl<'a> Extractor<'a> {
    pub fn new(archiver: &'a Archiver, traps: &'a trap::TrapFileProvider) -> Self {
        Self {
            archiver,
            traps,
            steps: Vec::new(),
        }
    }

    fn extract(&mut self, rust_analyzer: &rust_analyzer::RustAnalyzer, file: &std::path::Path) {
        self.archiver.archive(file);

        let before_parse = Instant::now();
        let ParseResult {
            ast,
            text,
            errors,
            semantics_info,
        } = rust_analyzer.parse(file);
        self.steps.push(ExtractionStep::parse(before_parse, file));

        let before_extract = Instant::now();
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
        self.steps
            .push(ExtractionStep::extract(before_extract, file));
    }

    pub fn extract_with_semantics(
        &mut self,
        file: &Path,
        semantics: &Semantics<'_, RootDatabase>,
        vfs: &Vfs,
    ) {
        self.extract(&RustAnalyzer::new(vfs, semantics), file);
    }

    pub fn extract_without_semantics(&mut self, file: &Path, reason: &str) {
        self.extract(&RustAnalyzer::WithoutSemantics { reason }, file);
    }

    pub fn load_manifest(
        &mut self,
        project: &ProjectManifest,
        config: &CargoConfig,
    ) -> Option<(RootDatabase, Vfs)> {
        let before = Instant::now();
        let ret = RustAnalyzer::load_workspace(project, config);
        self.steps
            .push(ExtractionStep::load_manifest(before, project));
        ret
    }

    pub fn load_source(
        &mut self,
        file: &Path,
        semantics: &Semantics<'_, RootDatabase>,
        vfs: &Vfs,
    ) -> Result<(), String> {
        let before = Instant::now();
        let Some(id) = path_to_file_id(file, vfs) else {
            return Err("not included in files loaded from manifest".to_string());
        };
        if semantics.file_to_module_def(id).is_none() {
            return Err("not included as a module".to_string());
        }
        self.steps.push(ExtractionStep::load_source(before, file));
        Ok(())
    }

    pub fn emit_extraction_diagnostics(
        self,
        start: Instant,
        cfg: &config::Config,
    ) -> anyhow::Result<()> {
        emit_extraction_diagnostics(start, cfg, &self.steps)?;
        let mut trap = self.traps.create("diagnostics", "extraction");
        for step in self.steps {
            let file = step.file.as_ref().map(|f| trap.emit_file(f));
            let duration_ms = usize::try_from(step.ms).unwrap_or_else(|_e| {
                warn!("extraction step duration overflowed ({step:?})");
                i32::MAX as usize
            });
            trap.emit(generated::ExtractorStep {
                id: TrapId::Star,
                action: format!("{:?}", step.action),
                file,
                duration_ms,
            });
        }
        trap.commit()?;
        Ok(())
    }

    pub fn find_manifests(&mut self, files: &[PathBuf]) -> anyhow::Result<Vec<ProjectManifest>> {
        let before = Instant::now();
        let ret = rust_analyzer::find_project_manifests(files);
        self.steps.push(ExtractionStep::find_manifests(before));
        ret
    }
}

fn cwd() -> anyhow::Result<AbsPathBuf> {
    let path = std::env::current_dir().context("current directory")?;
    let utf8_path = Utf8PathBuf::from_path_buf(path)
        .map_err(|p| anyhow::anyhow!("{} is not a valid UTF-8 path", p.display()))?;
    let abs_path = AbsPathBuf::try_from(utf8_path)
        .map_err(|p| anyhow::anyhow!("{} is not absolute", p.as_str()))?;
    Ok(abs_path)
}

fn main() -> anyhow::Result<()> {
    let start = Instant::now();
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
    let mut extractor = Extractor::new(&archiver, &traps);
    let files: Vec<PathBuf> = cfg
        .inputs
        .iter()
        .map(|file| {
            let file = std::path::absolute(file).unwrap_or(file.to_path_buf());
            // On Windows, rust analyzer expects non-`//?/` prefixed paths (see [1]), which is what
            // `std::fs::canonicalize` returns. So we use `dunce::canonicalize` instead.
            // [1]: https://github.com/rust-lang/rust-analyzer/issues/18894#issuecomment-2580014730
            dunce::canonicalize(&file).unwrap_or(file)
        })
        .collect();
    let manifests = extractor.find_manifests(&files)?;
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
    let cargo_config = cfg.to_cargo_config(&cwd()?);
    for (manifest, files) in map.values().filter(|(_, files)| !files.is_empty()) {
        if let Some((ref db, ref vfs)) = extractor.load_manifest(manifest, &cargo_config) {
            let semantics = Semantics::new(db);
            for file in files {
                match extractor.load_source(file, &semantics, vfs) {
                    Ok(()) => extractor.extract_with_semantics(file, &semantics, vfs),
                    Err(reason) => extractor.extract_without_semantics(file, &reason),
                };
            }
        } else {
            for file in files {
                extractor.extract_without_semantics(file, "unable to load manifest");
            }
        }
    }

    extractor.emit_extraction_diagnostics(start, &cfg)
}

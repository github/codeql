use crate::diagnostics::{ExtractionStep, emit_extraction_diagnostics};
use crate::rust_analyzer::{RustAnalyzerNoSemantics, path_to_file_id};
use crate::toolchain::log_project_toolchain;
use crate::translate::SourceKind;
use crate::trap::TrapId;
use anyhow::Context;
use archive::Archiver;
use configuration::{DependencyFiles, dependency_files, manifest_parent};
use ra_ap_hir::Semantics;
use ra_ap_ide_db::RootDatabase;
use ra_ap_ide_db::line_index::{LineCol, LineIndex};
use ra_ap_load_cargo::LoadCargoConfig;
use ra_ap_paths::{AbsPathBuf, Utf8PathBuf};
use ra_ap_project_model::{CargoConfig, ProjectManifest};
use ra_ap_vfs::Vfs;
use rust_analyzer::{ParseResult, RustAnalyzer};
use std::collections::{BTreeMap, HashSet};
use std::fs::File;
use std::io::{self, BufRead, BufReader};
use std::path::{Path, PathBuf};
use std::time::Instant;
use std::{env, fs};
use tracing::{error, info, warn};
use tracing_subscriber::layer::SubscriberExt;
use tracing_subscriber::util::SubscriberInitExt;

mod archive;
mod config;
mod configuration;
mod crate_graph;
mod diagnostics;
pub mod generated;
mod qltest;
mod rust_analyzer;
mod toolchain;
mod translate;
pub mod trap;
mod util;

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

    fn extract(&mut self, rust_analyzer: &RustAnalyzer, file: &Path, source_kind: SourceKind) {
        self.archiver.archive(file);
        let before_parse = Instant::now();
        let ParseResult {
            ast,
            text,
            errors,
            semantics_info,
        } = rust_analyzer.parse(file);
        self.steps
            .push(ExtractionStep::parse(before_parse, source_kind, file));

        let before_extract = Instant::now();
        let line_index = LineIndex::new(text.as_ref());
        let mut trap = self.traps.create("source", file);
        let label = trap.emit_file(file);
        let mut translator = translate::Translator::new(
            trap,
            file,
            label,
            line_index,
            semantics_info.as_ref().ok(),
            source_kind,
        );

        for err in errors {
            translator.emit_parse_error(&ast, &err);
        }
        let no_location = (LineCol { line: 0, col: 0 }, LineCol { line: 0, col: 0 });
        if let Err(RustAnalyzerNoSemantics { severity, reason }) = semantics_info
            && !reason.is_empty()
        {
            let message = format!("semantic analyzer unavailable ({reason})");
            let full_message = format!("{message}: macro expansion will be skipped.");
            translator.emit_diagnostic(
                severity,
                "semantics".to_owned(),
                message,
                full_message,
                no_location,
            );
        }
        translator.emit_source_file(&ast);
        translator.emit_truncated_diagnostics_message();
        translator.trap.commit().unwrap_or_else(|err| {
            error!(
                "Failed to write trap file for: {}: {}",
                file.display(),
                err.to_string()
            )
        });
        self.steps
            .push(ExtractionStep::extract(before_extract, source_kind, file));
    }

    pub fn extract_with_semantics<'db>(
        &mut self,
        file: &Path,
        semantics: &'db Semantics<'db, RootDatabase>,
        vfs: &'db Vfs,
        source_kind: SourceKind,
    ) {
        self.extract(&RustAnalyzer::new(vfs, semantics), file, source_kind);
    }

    pub fn extract_without_semantics(
        &mut self,
        file: &Path,
        source_kind: SourceKind,
        err: RustAnalyzerNoSemantics,
    ) {
        self.extract(&RustAnalyzer::from(err), file, source_kind);
    }

    pub fn load_manifest(
        &mut self,
        project: &ProjectManifest,
        config: &CargoConfig,
        load_config: &LoadCargoConfig,
    ) -> Option<(RootDatabase, Vfs)> {
        let before = Instant::now();
        let ret = RustAnalyzer::load_workspace(project, config, load_config);
        self.steps
            .push(ExtractionStep::load_manifest(before, project));
        ret
    }

    pub fn load_source(
        &mut self,
        file: &Path,
        semantics: &Semantics<'_, RootDatabase>,
        vfs: &Vfs,
    ) -> Result<(), RustAnalyzerNoSemantics> {
        let before = Instant::now();
        let Some(id) = path_to_file_id(file, vfs) else {
            return Err(RustAnalyzerNoSemantics::warning(
                "not included in files loaded from manifest",
            ));
        };
        match semantics.file_to_module_def(id) {
            None => {
                return Err(RustAnalyzerNoSemantics::info("not included as a module"));
            }
            Some(module)
                if module
                    .as_source_file_id(semantics.db)
                    .is_none_or(|mod_file_id| mod_file_id.file_id(semantics.db) != id) =>
            {
                return Err(RustAnalyzerNoSemantics::info(
                    "not loaded as its own module, probably included by `!include`",
                ));
            }
            _ => {}
        };
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

    fn group_files<'b>(
        &mut self,
        manifests: &'b [ProjectManifest],
        files: &'b [PathBuf],
    ) -> BTreeMap<&'b Path, (&'b ProjectManifest, Vec<&'b Path>)> {
        let mut workspaces: BTreeMap<&Path, (&ProjectManifest, Vec<&Path>)> = manifests
            .iter()
            .map(|manifest| (manifest_parent(manifest), (manifest, Vec::new())))
            .collect();

        'outer: for file in files {
            for ancestor in file.as_path().ancestors() {
                if let Some((_, files)) = workspaces.get_mut(ancestor) {
                    files.push(file);
                    continue 'outer;
                }
            }
            self.extract_without_semantics(
                file,
                SourceKind::Source,
                RustAnalyzerNoSemantics::warning("no manifest found"),
            );
        }

        workspaces.retain(|_, (_, files)| !files.is_empty());
        workspaces
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
    let config = config::Config::extract().context("failed to load configuration")?;
    let inputs = if config.qltest {
        qltest::prepare(&config)?
    } else if let Some(path) = &config.file_list {
        let file =
            File::open(path).with_context(|| format!("opening file list {}", path.display()))?;
        BufReader::new(file)
            .lines()
            .map(|line| line.map(PathBuf::from))
            .collect::<io::Result<Vec<_>>>()
            .with_context(|| format!("reading file list {}", path.display()))?
    } else {
        Vec::new()
    };
    let (flame_layer, _flush_guard) = if let Some(path) = &config.logging_flamegraph {
        tracing_flame::FlameLayer::with_file(path)
            .ok()
            .map(|(a, b)| (Some(a), Some(b)))
            .unwrap_or((None, None))
    } else {
        (None, None)
    };

    tracing_subscriber::registry()
        .with(codeql_extractor::extractor::default_subscriber_with_level(
            "single_arch",
            &config.logging_verbosity,
        ))
        .with(flame_layer)
        .init();
    info!("{config:#?}\n");
    info!("number of inputs: {}", inputs.len());

    let traps = trap::TrapFileProvider::new(&config).context("failed to set up trap files")?;
    let archiver = archive::Archiver {
        root: config.source_archive_dir.clone(),
    };
    let mut extractor = Extractor::new(&archiver, &traps);
    let files = inputs
        .iter()
        .map(|file| {
            let file = std::path::absolute(file).unwrap_or(file.to_path_buf());
            // On Windows, rust analyzer expects non-`//?/` prefixed paths (see [1]), which is what
            // `std::fs::canonicalize` returns. So we use `dunce::canonicalize` instead.
            // [1]: https://github.com/rust-lang/rust-analyzer/issues/18894#issuecomment-2580014730
            dunce::canonicalize(&file).unwrap_or(file)
        })
        .collect::<Vec<_>>();
    let manifests = extractor.find_manifests(&files)?;
    let workspaces = extractor.group_files(&manifests, &files);
    let cwd = cwd()?;
    log_project_toolchain();
    let (cargo_config, load_cargo_config) = config.to_cargo_config(&cwd);
    let library_mode = if config.extract_dependencies_as_source {
        SourceKind::Source
    } else {
        SourceKind::Library
    };
    let source_mode = if config.force_library_mode {
        library_mode
    } else {
        SourceKind::Source
    };
    let source_files = HashSet::from_iter(files.iter().cloned());

    let mut dependencies = DependencyFiles::default();

    // When there more than one workspace, it's not a priori clear in which
    // workspace a dependency file should be extracted.
    let dependency_extraction_ambiguity = workspaces.len() == 1;

    for (manifest, files) in workspaces.values() {
        if let Some((db, vfs)) =
            extractor.load_manifest(manifest, &cargo_config, &load_cargo_config)
        {
            let before_crate_graph = Instant::now();
            crate_graph::extract_crate_graph(extractor.traps, &db, &vfs);
            extractor
                .steps
                .push(ExtractionStep::crate_graph(before_crate_graph));
            let semantics = Semantics::new(&db);
            for file in files {
                match extractor.load_source(file, &semantics, &vfs) {
                    Ok(()) => extractor.extract_with_semantics(file, &semantics, &vfs, source_mode),
                    Err(e) => extractor.extract_without_semantics(file, source_mode, e),
                };
            }
            // Fast path when there is no ambiguity in dependency extraction.
            if dependency_extraction_ambiguity {
                for (_, file) in dependency_files(&db, &vfs, &source_files) {
                    extractor.extract_with_semantics(file, &semantics, &vfs, library_mode);
                }
            } else {
                dependencies.add_manifest(manifest, &semantics, &vfs, &source_files);
            }
        } else {
            for file in files {
                extractor.extract_without_semantics(
                    file,
                    SourceKind::Source,
                    RustAnalyzerNoSemantics::warning("unable to load manifest"),
                );
            }
        }
    }

    // For each manifest, extract the dependency files for which it is
    // preferred. Note that when `dependency_extraction_ambiguity` is true then
    // `selected` below is empty.
    loop {
        let selected = dependencies.by_manifests();
        if selected.is_empty() {
            break;
        }
        for (manifest, files) in selected {
            if let Some((db, vfs)) =
                extractor.load_manifest(manifest, &cargo_config, &load_cargo_config)
            {
                let semantics = Semantics::new(&db);
                for file in files {
                    // A richer configuration can disable a file when using cfg
                    // options like `#[cfg(not(feature = "foo"))]`. When this is
                    // the case `file_to_module_def` will return `None` for the
                    // file. When this is the case and there are alternatives we
                    // do not extract the file yet. Instead the file will be
                    // considered again in the next iteration of the loop.
                    if !dependencies.has_alternative(&file)
                        || path_to_file_id(&file, &vfs)
                            .and_then(|id| semantics.file_to_module_def(id))
                            .is_some()
                    {
                        extractor.extract_with_semantics(&file, &semantics, &vfs, library_mode);
                        dependencies.extracted(&file);
                    }
                }
            } else {
                for file in files {
                    extractor.extract_without_semantics(
                        &file,
                        library_mode,
                        RustAnalyzerNoSemantics::warning("unable to reload manifest"),
                    );
                    dependencies.extracted(&file);
                }
            }
        }
    }

    let builtins_dir = env::var("CODEQL_EXTRACTOR_RUST_ROOT")
        .map(|path| Path::new(&path).join("tools").join("builtins"))?;
    let builtins = fs::read_dir(builtins_dir).context("failed to read builtins directory")?;
    for entry in builtins {
        let entry = entry.context("failed to read builtins directory")?;
        let path = entry.path();
        if path.extension().is_some_and(|ext| ext == "rs") {
            extractor.extract_without_semantics(&path, SourceKind::Library, Default::default());
        }
    }

    extractor.emit_extraction_diagnostics(start, &config)
}

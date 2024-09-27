use crate::config::Config;
use anyhow::Context;
use itertools::Itertools;
use log::info;
use ra_ap_base_db::SourceDatabase;
use ra_ap_hir::Semantics;
use ra_ap_ide_db::RootDatabase;
use ra_ap_load_cargo::{load_workspace_at, LoadCargoConfig, ProcMacroServerChoice};
use ra_ap_paths::Utf8PathBuf;
use ra_ap_project_model::CargoConfig;
use ra_ap_project_model::RustLibSource;
use ra_ap_span::Edition;
use ra_ap_span::EditionedFileId;
use ra_ap_span::TextRange;
use ra_ap_span::TextSize;
use ra_ap_syntax::SourceFile;
use ra_ap_syntax::SyntaxError;
use ra_ap_vfs::AbsPathBuf;
use ra_ap_vfs::Vfs;
use ra_ap_vfs::VfsPath;
use std::borrow::Cow;
use std::collections::HashMap;
use std::path::{Path, PathBuf};
use triomphe::Arc;
pub struct RustAnalyzer {
    workspace: HashMap<PathBuf, (Vfs, RootDatabase)>,
}

impl RustAnalyzer {
    pub fn new(cfg: &Config) -> anyhow::Result<RustAnalyzer> {
        let mut workspace = HashMap::new();
        let config = CargoConfig {
            sysroot: Some(RustLibSource::Discover),
            target_dir: ra_ap_paths::Utf8PathBuf::from_path_buf(cfg.scratch_dir.to_path_buf())
                .map(|x| x.join("target"))
                .ok(),
            ..Default::default()
        };
        let progress = |t| (log::info!("progress: {}", t));
        let load_config = LoadCargoConfig {
            load_out_dirs_from_check: true,
            with_proc_macro_server: ProcMacroServerChoice::Sysroot,
            prefill_caches: false,
        };
        let projects = find_project_manifests(&cfg.inputs).context("loading inputs")?;
        for project in projects {
            let manifest = project.manifest_path();
            let (db, vfs, _macro_server) =
                load_workspace_at(manifest.as_ref(), &config, &load_config, &progress)?;
            let path: &Path = manifest.parent().as_ref();
            workspace.insert(path.to_path_buf(), (vfs, db));
        }
        Ok(RustAnalyzer { workspace })
    }
    pub fn parse(
        &self,
        path: &PathBuf,
    ) -> (
        SourceFile,
        Arc<str>,
        Vec<SyntaxError>,
        Option<Semantics<'_, RootDatabase>>,
    ) {
        let mut p = path.as_path();
        while let Some(parent) = p.parent() {
            p = parent;
            if let Some((vfs, db)) = self.workspace.get(parent) {
                if let Some(file_id) = Utf8PathBuf::from_path_buf(path.to_path_buf())
                    .ok()
                    .and_then(|x| AbsPathBuf::try_from(x).ok())
                    .map(VfsPath::from)
                    .and_then(|x| vfs.file_id(&x))
                {
                    let semi = Semantics::new(db);
                    let file_id = EditionedFileId::current_edition(file_id);

                    return (
                        semi.parse(file_id),
                        db.file_text(file_id.into()),
                        db.parse_errors(file_id)
                            .map(|x| x.to_vec())
                            .unwrap_or_default(),
                        Some(semi),
                    );
                }
            }
        }
        let mut errors = Vec::new();
        let input = match std::fs::read(path) {
            Ok(data) => data,
            Err(e) => {
                errors.push(SyntaxError::new(
                    format!("Could not read {}: {}", path.to_string_lossy(), e),
                    TextRange::empty(TextSize::default()),
                ));
                vec![]
            }
        };
        let (input, err) = from_utf8_lossy(&input);
        let parse = ra_ap_syntax::ast::SourceFile::parse(&input, Edition::CURRENT);
        errors.extend(parse.errors());
        errors.extend(err);
        (parse.tree(), input.as_ref().into(), errors, None)
    }
}

fn find_project_manifests(
    files: &[PathBuf],
) -> anyhow::Result<Vec<ra_ap_project_model::ProjectManifest>> {
    let current = std::env::current_dir()?;
    let abs_files: Vec<_> = files
        .iter()
        .map(|path| AbsPathBuf::assert_utf8(current.join(path)))
        .collect();
    let ret = ra_ap_project_model::ProjectManifest::discover_all(&abs_files);
    info!(
        "found manifests: {}",
        ret.iter().map(|m| format!("{m}")).join(", ")
    );
    Ok(ret)
}
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

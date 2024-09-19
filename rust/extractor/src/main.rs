use crate::trap::TrapId;
use anyhow::Context;
use itertools::Itertools;
use log::info;
use ra_ap_hir::db::DefDatabase;
use ra_ap_hir::Crate;
use ra_ap_load_cargo::{load_workspace_at, LoadCargoConfig, ProcMacroServerChoice};
use ra_ap_project_model::CargoConfig;
use ra_ap_project_model::RustLibSource;
use ra_ap_vfs::AbsPathBuf;
use std::path::PathBuf;

mod archive;
mod config;
pub mod generated;
mod translate;
pub mod trap;

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

    let config = CargoConfig {
        sysroot: Some(RustLibSource::Discover),
        target_dir: ra_ap_paths::Utf8PathBuf::from_path_buf(cfg.scratch_dir)
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
        let (db, vfs, _macro_server) = load_workspace_at(
            project.manifest_path().as_ref(),
            &config,
            &load_config,
            &progress,
        )?;

        let crates = <dyn DefDatabase>::crate_graph(&db);
        for crate_id in crates.iter() {
            let krate = Crate::from(crate_id);
            if !cfg.extract_dependencies && !krate.origin(&db).is_local() {
                continue;
            }
            let name = krate.display_name(&db);
            let crate_name = name
                .as_ref()
                .map(|n| n.canonical_name().as_str())
                .unwrap_or("");
            let trap = traps.create(
                "crates",
                &PathBuf::from(format!(
                    "/{}_{}",
                    crate_name,
                    crate_id.into_raw().into_u32()
                )),
            );
            translate::CrateTranslator::new(&db, trap, &krate, &vfs, &archiver)
                .emit_crate()
                .context("writing trap file")?;
        }
    }
    Ok(())
}

use crate::trap::TrapId;
use anyhow::Context;
use ra_ap_hir::db::DefDatabase;
use ra_ap_hir::Crate;
use ra_ap_load_cargo::{load_workspace, LoadCargoConfig, ProcMacroServerChoice};
use ra_ap_project_model::CargoConfig;
use ra_ap_project_model::ProjectWorkspace;
use ra_ap_project_model::RustLibSource;
use ra_ap_vfs::AbsPathBuf;
use std::path::PathBuf;

mod archive;
mod config;
pub mod generated;
pub mod path;
mod translate;
pub mod trap;

pub fn find_project_manifests(
    files: &Vec<PathBuf>,
) -> anyhow::Result<Vec<ra_ap_project_model::ProjectManifest>> {
    let current = std::env::current_dir()?;
    let abs_files: Vec<_> = files
        .iter()
        .map(|path| AbsPathBuf::assert_utf8(current.join(path)))
        .collect();
    Ok(ra_ap_project_model::ProjectManifest::discover_all(
        &abs_files,
    ))
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
        ..Default::default()
    };
    let progress = |t| (println!("progress: {}", t));
    let load_config = LoadCargoConfig {
        load_out_dirs_from_check: true,
        with_proc_macro_server: ProcMacroServerChoice::Sysroot,
        prefill_caches: false,
    };
    let projects = find_project_manifests(&cfg.inputs).context("loading inputs")?;
    for project in projects {
        let mut workspace = ProjectWorkspace::load(project, &config, &progress)?;

        if load_config.load_out_dirs_from_check {
            let build_scripts = workspace.run_build_scripts(&config, &progress)?;
            workspace.set_build_scripts(build_scripts)
        }

        let (db, vfs, _macro_server) = load_workspace(workspace, &config.extra_env, &load_config)?;
        let crates = <dyn DefDatabase>::crate_graph(&db);
        for crate_id in crates.iter() {
            let krate = Crate::from(crate_id);
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

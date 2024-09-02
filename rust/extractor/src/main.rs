use std::fs;
use std::path::{PathBuf, Path};
use ra_ap_project_model::CargoConfig;
use anyhow::Context;
use log;
use ra_ap_hir::db::DefDatabase;
use ra_ap_hir::{Crate, ModuleDefId};
use ra_ap_hir::AdtId::{EnumId, UnionId, StructId};
use ra_ap_hir::sym::ge;
use ra_ap_load_cargo::{load_workspace_at, LoadCargoConfig, ProcMacroServerChoice};
use crate::trap::{TrapId};

mod config;
pub mod trap;
pub mod generated;
mod translate;
mod archive;
pub mod path;

fn main() -> anyhow::Result<()> {
    let cfg = config::Config::extract().context("failed to load configuration")?;
    stderrlog::new()
        .module(module_path!())
        .verbosity(2 + cfg.verbose as usize)
        .init()?;
    log::info!("{cfg:?}");
    let traps = trap::TrapFileProvider::new(&cfg).context("failed to set up trap files")?;
    let archiver = archive::Archiver { root: cfg.source_archive_dir };

    let config = CargoConfig { ..Default::default() };
    let no_progress = |_| ();
    let load_config = LoadCargoConfig {
        load_out_dirs_from_check: true,
        with_proc_macro_server: ProcMacroServerChoice::Sysroot,
        prefill_caches: false,
    };
    for input in cfg.inputs {
        let (db, vfs, _macro_server) = load_workspace_at(&input, &config, &load_config, &no_progress).context("loading inputs")?;
        let crates =  <dyn DefDatabase>::crate_graph(&db);
        for crate_id in crates.iter() {
            let krate = Crate::from(crate_id);
            let name = krate.display_name(&db);
            let crate_name = name.as_ref().map(|n| n.canonical_name().as_str()).unwrap_or("");
            let trap = traps.create("crates", &PathBuf::from(format!("/{}_{}", crate_name, crate_id.into_raw().into_u32())));
            translate::CrateTranslator::new(
                &db,
                trap,
                &krate,
                &vfs,
                &archiver,
            ).emit_crate().context("writing trap file")?;
        }
    }
    Ok(())
}

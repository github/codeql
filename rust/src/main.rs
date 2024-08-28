#![feature(path_add_extension)]

use std::fs;
use ra_ap_project_model::CargoConfig;
use anyhow::Context;
use log;
use ra_ap_hir::db::DefDatabase;
use ra_ap_hir::{ModuleDefId};
use ra_ap_hir::AdtId::{EnumId, UnionId, StructId};
use ra_ap_hir::sym::ge;
use ra_ap_load_cargo::{load_workspace_at, LoadCargoConfig, ProcMacroServerChoice};


mod config;
pub mod trap;
mod generated;
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
    let archiver = archive::Archiver{root: cfg.source_archive_dir};

    let config = CargoConfig { ..Default::default() };
    let no_progress = |_| ();
    let load_config = LoadCargoConfig {
        load_out_dirs_from_check: true,
        with_proc_macro_server: ProcMacroServerChoice::Sysroot,
        prefill_caches: false,
    };
    for input in cfg.inputs {
        let path = fs::canonicalize(input)?;
        {
            let mut trap = traps.create("input", &path)?;
            let name= String::from(path.to_string_lossy());
            trap.emit(generated::DbFile{key: Some(name.clone()), name })?;
            archiver.archive(&path);
        }
        load_workspace_at(&path, &config, &load_config, &no_progress)?;
        todo!()
    }
    Ok(())
}

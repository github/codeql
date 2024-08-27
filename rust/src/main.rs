use ra_ap_project_model::CargoConfig;
use anyhow::Context;
use log;
use ra_ap_hir::db::DefDatabase;
use ra_ap_hir::{ModuleDefId};
use ra_ap_hir::AdtId::{EnumId, UnionId, StructId};
use ra_ap_load_cargo::{load_workspace_at, LoadCargoConfig, ProcMacroServerChoice};


mod config;
mod trap;

fn main() -> anyhow::Result<()> {
    let cfg = config::Config::extract().context("failed to load configuration")?;
    stderrlog::new()
        .module(module_path!())
        .verbosity(2 + cfg.verbose as usize)
        .init()?;
    log::info!("{cfg:?}");

    let config = CargoConfig { ..Default::default() };
    let no_progress = |_| ();
    let load_config = LoadCargoConfig {
        load_out_dirs_from_check: true,
        with_proc_macro_server: ProcMacroServerChoice::Sysroot,
        prefill_caches: false,
    };
    for manifest in cfg.inputs {
        let (db, vfs, _macro_server) = load_workspace_at(&manifest, &config, &load_config, &no_progress)?;
        let def_db: &dyn DefDatabase = &db;
        let crates = def_db.crate_graph();
        for crate_id in crates.iter().take(1) {
            let krate = &crates[crate_id];
            let file = vfs.file_path(krate.root_file_id);
            println!("Crate: idx={:x} {}", crate_id.into_raw().into_u32(), file);
            let def_map = def_db.crate_def_map(crate_id);
            for (module_id, &ref module) in def_map.modules.iter() {
                println!("  Module: idx={:x} {:?}", module_id.into_raw().into_u32(), module.origin);
                for ref decl_id in module.scope.declarations() {
                    match decl_id {
                        ModuleDefId::ModuleId(id) => {
                            println!("    Module: idx={:x}", id.local_id.into_raw().into_u32());
                        }
                        ModuleDefId::FunctionId(id) => {
                            let function = def_db.function_data(*id);
                            println!("    Function: {:?}", function);
                        }
                        ModuleDefId::AdtId(StructId(id)) => {
                            let s = def_db.struct_data(*id);
                            println!("    Struct: {:?}", s);
                        }
                        ModuleDefId::AdtId(EnumId(id)) => {
                            let e = def_db.enum_data(*id);
                            println!("    Enum: {:?}", e);
                        }
                        ModuleDefId::AdtId(UnionId(id)) => {
                            let u = def_db.union_data(*id);
                            println!("    Union: {:?}", u);
                        }
                        ModuleDefId::EnumVariantId(_) => {}
                        ModuleDefId::ConstId(_) => {}
                        ModuleDefId::StaticId(_) => {}
                        ModuleDefId::TraitId(_) => {}
                        ModuleDefId::TraitAliasId(_) => {}
                        ModuleDefId::TypeAliasId(_) => {}
                        ModuleDefId::BuiltinType(_) => {}
                        ModuleDefId::MacroId(_) => {}
                    }
                }
            }
        }
    }
    Ok(())
}

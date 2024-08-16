use ra_ap_hir::{Crate, ModuleDef, Name, HirDisplay, DefWithBody};
use ra_ap_project_model::CargoConfig;
use std::env;
use std::path::Path;
use ra_ap_load_cargo::{load_workspace_at, LoadCargoConfig, ProcMacroServerChoice};

fn extract_name(n: Option<Name>) -> String {
    match n {
        Some(v) => v.as_str().to_owned(),
        None => String::from("<no name>"),
    }
}

fn main() {
    let args: Vec<String> = env::args().collect();
    let config = CargoConfig { ..Default::default() };
    let no_progress = &|_| ();
    let load_config = LoadCargoConfig {
        load_out_dirs_from_check: true,
        with_proc_macro_server: ProcMacroServerChoice::Sysroot,
        prefill_caches: false,
    };
    let (db, vfs, macro_server) = load_workspace_at(&Path::new(&args[1]), &config, &load_config, no_progress).unwrap();
    let mut worklist: Vec<_> =
        Crate::all(&db).into_iter().map(|krate| krate.root_module()).collect();

    while let Some(module) = worklist.pop() {
        println!("Module: {}", extract_name(module.name(&db)));
        for d in module.declarations(&db) {
            match d {
                ModuleDef::Module(e) => {
                    println!("  {}", e.display(&db));
                }
                ModuleDef::Function(e) => {
                    println!("  {}", e.display(&db));
                }
                ModuleDef::Adt(e) => {
                    println!("  {}", e.display(&db));
                }
                ModuleDef::Variant(e) => {
                    println!("  {}", e.display(&db));
                }
                ModuleDef::Const(e) => {
                    println!("  {}", e.display(&db));
                }
                ModuleDef::Static(e) => {
                    println!("  {}", e.display(&db));
                }
                ModuleDef::Trait(e) => {
                    println!("  {}", e.display(&db));
                }
                ModuleDef::TraitAlias(e) => {
                    println!("  {}", e.display(&db));
                }
                ModuleDef::TypeAlias(e) => {
                    println!("  {}", e.display(&db));
                }
                ModuleDef::BuiltinType(_e) => {}
                ModuleDef::Macro(e) => {
                    println!("  {}", e.display(&db));
                }
            }
        }
        worklist.extend(module.children(&db));
    }
}

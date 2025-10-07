use crate::{generated, trap};

use itertools::Itertools;
use ra_ap_base_db::{Crate, RootQueryDb};
use ra_ap_cfg::CfgAtom;
use ra_ap_ide_db::RootDatabase;
use ra_ap_vfs::{Vfs, VfsPath};

use std::hash::Hash;
use std::hash::Hasher;
use std::{cmp::Ordering, collections::HashMap, path::PathBuf};
use tracing::error;

pub fn extract_crate_graph(trap_provider: &trap::TrapFileProvider, db: &RootDatabase, vfs: &Vfs) {
    let crate_graph = db.all_crates();

    // According to the documentation of `CrateGraph`:
    // Each crate is defined by the `FileId` of its root module, the set of enabled
    // `cfg` flags and the set of dependencies.

    // First compute a hash map with for each crate ID, the path to its root module and a hash of all
    // its `cfg` flags and dependencies hashes. Iterate in topological order to ensure hashes of dependencies
    // are present in the map.
    let mut crate_id_map = HashMap::<Crate, (PathBuf, u64)>::new();
    for krate_id in crate_graph.as_ref().iter() {
        let krate = krate_id.data(db);
        let root_module_file: &VfsPath = vfs.file_path(krate.root_file_id);
        if let Some(root_module_file) = root_module_file
            .as_path()
            .map(|p| std::fs::canonicalize(p).unwrap_or(p.into()))
        {
            let mut hasher = std::hash::DefaultHasher::new();
            krate_id
                .cfg_options(db)
                .into_iter()
                .sorted_by(cmp_flag)
                .for_each(|x| format!("{x}").hash(&mut hasher));

            krate
                .dependencies
                .iter()
                .flat_map(|d| crate_id_map.get(&d.crate_id))
                .sorted()
                .for_each(|x| x.hash(&mut hasher));
            let hash = hasher.finish();
            crate_id_map.insert(*krate_id, (root_module_file, hash));
        }
    }
    // Extract each crate
    for krate_id in crate_graph.as_ref().iter() {
        if let Some((root_module_file, hash)) = crate_id_map.get(krate_id) {
            let path = root_module_file.join(format!("{hash:0>16x}"));
            let mut trap = trap_provider.create("crates", path.as_path());
            // If the trap file already exists, then skip extraction because we have already extracted
            // this crate with the same `cfg` flags and dependencies.
            // FIXME: this may need to b improved in case the implemenation becomes multi-threaded
            if trap.path.exists() {
                continue;
            }
            let krate = krate_id.data(db);
            let crate_dependencies: Vec<generated::NamedCrate> = krate
                .dependencies
                .iter()
                .flat_map(|x| crate_id_map.get(&x.crate_id).map(|y| (&x.name, y)))
                .map(|(name, (module, hash))| generated::NamedCrate {
                    id: trap::TrapId::Star,
                    name: name.to_string(),
                    crate_: trap.label(format!("{}:{hash}", module.display()).into()),
                })
                .collect();

            let krate_extra = krate_id.extra_data(db);
            let element = generated::Crate {
                id: trap::TrapId::Key(format!("{}:{hash}", root_module_file.display())),
                name: krate_extra
                    .display_name
                    .as_ref()
                    .map(|x| x.canonical_name().to_string()),
                version: krate_extra.version.to_owned(),
                cfg_options: krate_id
                    .cfg_options(db)
                    .into_iter()
                    .map(|x| format!("{x}"))
                    .collect(),
                named_dependencies: crate_dependencies
                    .into_iter()
                    .map(|dep| trap.emit(dep))
                    .collect(),
            };
            let label = trap.emit(element);
            let file_label = trap.emit_file(root_module_file);
            trap.emit_file_only_location(file_label, label);

            trap.commit().unwrap_or_else(|err| {
                error!(
                    "Failed to write trap file for crate: {}: {}",
                    root_module_file.display(),
                    err.to_string()
                )
            });
        }
    }
}

fn cmp_flag(a: &&CfgAtom, b: &&CfgAtom) -> Ordering {
    match (a, b) {
        (CfgAtom::Flag(a), CfgAtom::Flag(b)) => a.as_str().cmp(b.as_str()),
        (CfgAtom::Flag(a), CfgAtom::KeyValue { key: b, value: _ }) => {
            a.as_str().cmp(b.as_str()).then(Ordering::Less)
        }
        (CfgAtom::KeyValue { key: a, value: _ }, CfgAtom::Flag(b)) => {
            a.as_str().cmp(b.as_str()).then(Ordering::Greater)
        }
        (CfgAtom::KeyValue { key: a, value: av }, CfgAtom::KeyValue { key: b, value: bv }) => a
            .as_str()
            .cmp(b.as_str())
            .then(av.as_str().cmp(bv.as_str())),
    }
}

use crate::util::cmp_option_by;
use itertools::Itertools;
use ra_ap_base_db::SourceDatabase;
use ra_ap_cfg::{CfgAtom, CfgOptions};
use ra_ap_hir::Semantics;
use ra_ap_ide_db::RootDatabase;
use ra_ap_project_model::ProjectManifest;
use ra_ap_vfs::{FileId, VfsPath};
use std::cmp::Ordering;
use std::collections::{BTreeMap, HashMap, HashSet, btree_map::Entry};
use std::path::{Path, PathBuf};

/// Returns the enclosing directory of the manifest file.
pub fn manifest_parent(manifest: &ProjectManifest) -> &Path {
    manifest.manifest_path().parent().as_ref()
}

/// Compare two `CfgOptions`. Feature count wins, sorted cfg options break ties.
fn compare_cfg_options(left: &CfgOptions, right: &CfgOptions) -> Ordering {
    let feature_count = |cfg_options: &CfgOptions| {
        cfg_options
            .into_iter()
            .filter(|cfg| matches!(cfg, CfgAtom::KeyValue { key, .. } if key.as_str() == "feature"))
            .count()
    };
    feature_count(left)
        .cmp(&feature_count(right))
        .then_with(|| left.into_iter().sorted().cmp(right.into_iter().sorted()))
}

#[derive(PartialEq, Eq)]
struct DependencySource<'a> {
    cfg_options: Option<CfgOptions>,
    manifest: &'a ProjectManifest,
}

impl Ord for DependencySource<'_> {
    fn cmp(&self, other: &Self) -> Ordering {
        // Compare by cfg options first, then by manifest parent directory
        // (arbitrary but deterministic).
        cmp_option_by(&self.cfg_options, &other.cfg_options, compare_cfg_options)
            .then_with(|| manifest_parent(self.manifest).cmp(manifest_parent(other.manifest)))
    }
}

impl PartialOrd for DependencySource<'_> {
    fn partial_cmp(&self, other: &Self) -> Option<Ordering> {
        Some(self.cmp(other))
    }
}

/// Map dependency file paths to their highest-priority workspace context.
#[derive(Default)]
pub struct DependencyFiles<'a> {
    files: BTreeMap<PathBuf, DependencySource<'a>>,
}

impl<'a> DependencyFiles<'a> {
    /// Considers this workspace as an extraction context for a dependency file,
    /// retaining only the highest-priority context seen so far. The lexicographically
    /// largest workspace path breaks identical-priority ties.
    pub fn add_file(
        &mut self,
        manifest: &'a ProjectManifest,
        file_id: FileId,
        file: &VfsPath,
        semantics: &Semantics<'_, RootDatabase>,
        source_files: &HashSet<PathBuf>,
    ) {
        let db = semantics.db;
        if let Some(file) = file.as_path().map(<_ as AsRef<Path>>::as_ref)
            && file.extension().is_some_and(|ext| ext == "rs")
            && !source_files.contains(file)
            && let root = db.file_source_root(file_id).source_root_id(db)
            && db.source_root(root).source_root(db).is_library
        {
            let cfg_options = semantics
                .file_to_module_def(file_id)
                .map(|module| module.krate(db).cfg(db).clone());
            self.add_candidate(file, cfg_options, manifest);
        }
    }

    fn add_candidate(
        &mut self,
        file: &Path,
        cfg_options: Option<CfgOptions>,
        manifest: &'a ProjectManifest,
    ) {
        let candidate = DependencySource {
            cfg_options,
            manifest,
        };
        match self.files.entry(file.to_owned()) {
            Entry::Occupied(mut entry) => {
                if candidate > *entry.get() {
                    entry.insert(candidate);
                }
            }
            Entry::Vacant(entry) => {
                entry.insert(candidate);
            }
        }
    }

    /// Groups the selected dependency files by manifest for the dependency extraction pass.
    pub fn by_manifests(self) -> HashMap<&'a ProjectManifest, Vec<PathBuf>> {
        self.files
            .into_iter()
            .map(|(file, source)| (source.manifest, file))
            .into_group_map()
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use ra_ap_intern::Symbol;
    #[test]
    fn selects_highest_priority_in_either_order() {
        let cfg = |features: &[&str]| {
            let mut cfg = CfgOptions::default();
            for feature in features {
                cfg.insert_key_value(Symbol::intern("feature"), Symbol::intern(feature));
            }
            cfg
        };
        let root = crate::cwd().unwrap();
        let manifest = |path| ProjectManifest::from_manifest_file(root.join(path)).unwrap();
        let candidates = [
            (manifest("z/Cargo.toml"), cfg(&["z"])),
            (manifest("a/Cargo.toml"), cfg(&["a", "b"])),
            (manifest("b/Cargo.toml"), cfg(&["a", "b"])),
        ];
        for order in [[0, 1, 2], [2, 1, 0]] {
            let mut plan = DependencyFiles::default();
            for (manifest, cfg) in order.map(|index| &candidates[index]) {
                plan.add_candidate(Path::new("lib.rs"), Some(cfg.clone()), manifest);
            }
            let expected = HashMap::from([(&candidates[2].0, vec![PathBuf::from("lib.rs")])]);
            assert_eq!(plan.by_manifests(), expected);
        }
    }
}

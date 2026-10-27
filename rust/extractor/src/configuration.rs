use crate::util::cmp_option_by;
use itertools::Itertools;
use ra_ap_base_db::{SourceDatabase, all_crates};
use ra_ap_cfg::{CfgAtom, CfgOptions};
use ra_ap_hir::Semantics;
use ra_ap_ide_db::RootDatabase;
use ra_ap_project_model::ProjectManifest;
use ra_ap_vfs::{FileId, Vfs};
use std::cmp::Ordering;
use std::collections::{BTreeMap, HashMap, HashSet, btree_map::Entry};
use std::path::{Path, PathBuf};

/// Returns the enclosing directory of the manifest file.
pub fn manifest_parent(manifest: &ProjectManifest) -> &Path {
    manifest.manifest_path().parent().as_ref()
}

pub fn dependency_files<'a>(
    db: &'a RootDatabase,
    vfs: &'a Vfs,
    source_files: &'a HashSet<PathBuf>,
) -> impl Iterator<Item = (FileId, &'a Path)> {
    vfs.iter().filter_map(|(file_id, file)| {
        let file = file.as_path().map(<_ as AsRef<Path>>::as_ref)?;
        (file.extension().is_some_and(|ext| ext == "rs")
            && !source_files.contains(file)
            && db
                .source_root(db.file_source_root(file_id).source_root_id(db))
                .source_root(db)
                .is_library)
            .then_some((file_id, file))
    })
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

/// Map dependency files to their preferred workspace for each configuration.
#[derive(Default)]
pub struct DependencyFiles<'a> {
    files: BTreeMap<PathBuf, Vec<DependencySource<'a>>>,
}

impl<'a> DependencyFiles<'a> {
    /// Considers this workspace as an extraction context for its dependency files.
    /// The lexicographically largest workspace path wins for each configuration.
    pub fn add_workspace(
        &mut self,
        manifest: &'a ProjectManifest,
        semantics: &Semantics<'_, RootDatabase>,
        vfs: &Vfs,
        source_files: &HashSet<PathBuf>,
    ) {
        let db = semantics.db;
        let mut root_configurations = HashMap::new();
        for &krate in all_crates(db).iter() {
            let root = db
                .file_source_root(krate.data(db).root_file_id)
                .source_root_id(db);
            root_configurations
                .entry(root)
                .and_modify(|configuration: &mut Option<&CfgOptions>| {
                    if configuration.is_some_and(|cfg| cfg != krate.cfg_options(db)) {
                        *configuration = None;
                    }
                })
                .or_insert_with(|| Some(krate.cfg_options(db)));
        }
        for (file_id, file) in dependency_files(db, vfs, source_files) {
            let root = db.file_source_root(file_id).source_root_id(db);
            let cfg_options = match root_configurations.get(&root) {
                Some(Some(configuration)) => Some((*configuration).clone()),
                // Multiple crates can share a source root, for example a library
                // and its build script. Resolve ownership only if their cfgs differ.
                Some(None) => semantics
                    .file_to_module_def(file_id)
                    .map(|module| module.krate(db).cfg(db).clone()),
                None => None,
            };
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
                let sources = entry.get_mut();
                if let Some(source) = sources
                    .iter_mut()
                    .find(|source| source.cfg_options == candidate.cfg_options)
                {
                    if candidate > *source {
                        *source = candidate;
                    }
                } else {
                    sources.push(candidate);
                }
            }
            Entry::Vacant(entry) => {
                entry.insert(vec![candidate]);
            }
        }
    }

    /// Takes the highest-priority remaining context for each file, grouped by manifest.
    /// Lower-priority configurations remain available if the selected one disables the file.
    pub fn by_manifests(&mut self) -> HashMap<&'a ProjectManifest, Vec<PathBuf>> {
        self.files
            .iter_mut()
            .filter_map(|(file, sources)| {
                sources.sort_unstable();
                sources.pop().map(|source| (source.manifest, file.clone()))
            })
            .into_group_map()
    }

    pub fn has_alternative(&self, file: &Path) -> bool {
        self.files
            .get(file)
            .is_some_and(|sources| !sources.is_empty())
    }

    pub fn extracted(&mut self, file: &Path) {
        self.files.remove(file);
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use ra_ap_base_db::{
        CrateGraphBuilder, CrateOrigin, CrateWorkspaceData, FileChange, FileSet, SourceRoot,
    };
    use ra_ap_intern::Symbol;
    use ra_ap_span::Edition;
    use ra_ap_vfs::VfsPath;
    use triomphe::Arc;

    fn cfg(features: &[&str]) -> CfgOptions {
        let mut cfg = CfgOptions::default();
        for feature in features {
            cfg.insert_key_value(Symbol::intern("feature"), Symbol::intern(feature));
        }
        cfg
    }

    fn workspace(
        files: &[(&str, Option<&str>)],
        crates: &[(&str, &[&str])],
    ) -> (RootDatabase, Vfs) {
        let root = crate::cwd().unwrap();
        let mut vfs = Vfs::default();
        let mut file_set = FileSet::default();
        let mut change = FileChange::default();
        for &(name, text) in files {
            let path = VfsPath::from(root.join(name));
            vfs.set_file_contents(
                path.clone(),
                Some(text.unwrap_or_default().as_bytes().to_vec()),
            );
            let (id, _) = vfs.file_id(&path).unwrap();
            file_set.insert(id, path);
            if let Some(text) = text {
                change.change_file(id, Some(text.to_owned()));
            }
        }
        let mut graph = CrateGraphBuilder::default();
        for &(name, features) in crates {
            let (id, _) = vfs.file_id(&VfsPath::from(root.join(name))).unwrap();
            graph.add_crate_root(
                id,
                Edition::Edition2024,
                None,
                None,
                cfg(features),
                None,
                Default::default(),
                CrateOrigin::Library {
                    repo: None,
                    name: Symbol::intern(name),
                },
                Vec::new(),
                false,
                Arc::new(root.clone()),
                Arc::new(CrateWorkspaceData {
                    target: Err("unused in these tests".into()),
                    toolchain: None,
                }),
            );
        }
        change.set_roots(vec![SourceRoot::new_library(file_set)]);
        change.set_crate_graph(graph);
        let mut db = RootDatabase::default();
        change.apply(&mut db);
        (db, vfs)
    }

    #[test]
    fn selects_configuration_without_reading_dependency_sources() {
        for crates in [
            vec![("lib.rs", &["a"][..])],
            vec![("lib.rs", &["a"][..]), ("build.rs", &["a"][..])],
        ] {
            let (db, vfs) = workspace(
                &[("lib.rs", None), ("build.rs", None), ("module.rs", None)],
                &crates,
            );
            let root = crate::cwd().unwrap();
            let manifest = ProjectManifest::from_manifest_file(root.join("Cargo.toml")).unwrap();
            let mut plan = DependencyFiles::default();
            plan.add_workspace(&manifest, &Semantics::new(&db), &vfs, &HashSet::new());
            assert_eq!(plan.files.len(), 3);
            for sources in plan.files.values() {
                assert_eq!(sources[0].cfg_options, Some(cfg(&["a"])));
            }
        }
    }

    #[test]
    fn resolves_ownership_when_a_source_root_has_different_configurations() {
        let (db, vfs) = workspace(
            &[
                ("first.rs", Some("mod first_only;")),
                ("first_only.rs", Some("pub fn first() {}")),
                ("second.rs", Some("mod second_only;")),
                ("second_only.rs", Some("pub fn second() {}")),
            ],
            &[("first.rs", &["a"]), ("second.rs", &["a", "b"])],
        );
        let root = crate::cwd().unwrap();
        let manifest = ProjectManifest::from_manifest_file(root.join("Cargo.toml")).unwrap();
        let mut plan = DependencyFiles::default();
        plan.add_workspace(&manifest, &Semantics::new(&db), &vfs, &HashSet::new());
        for (file, features) in [
            ("first_only.rs", &["a"][..]),
            ("second_only.rs", &["a", "b"][..]),
        ] {
            assert_eq!(
                plan.files[AsRef::<Path>::as_ref(&root.join(file))][0].cfg_options,
                Some(cfg(features))
            );
        }
    }

    #[test]
    fn retains_distinct_configurations_for_inactive_module_fallback() {
        let root = crate::cwd().unwrap();
        let first = ProjectManifest::from_manifest_file(root.join("a/Cargo.toml")).unwrap();
        let second = ProjectManifest::from_manifest_file(root.join("b/Cargo.toml")).unwrap();
        let third = ProjectManifest::from_manifest_file(root.join("c/Cargo.toml")).unwrap();
        let file = Path::new("lib.rs");
        let mut plan = DependencyFiles::default();
        plan.add_candidate(file, Some(cfg(&["a"])), &first);
        plan.add_candidate(file, Some(cfg(&["a", "b"])), &second);
        plan.add_candidate(file, Some(cfg(&["a"])), &third);
        assert_eq!(
            plan.by_manifests(),
            HashMap::from([(&second, vec![file.to_owned()])])
        );
        assert!(plan.has_alternative(file));
        assert_eq!(
            plan.by_manifests(),
            HashMap::from([(&third, vec![file.to_owned()])])
        );
        assert!(!plan.has_alternative(file));
        plan.extracted(file);
        assert!(plan.by_manifests().is_empty());
    }

    #[test]
    fn selects_highest_priority_in_either_order() {
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

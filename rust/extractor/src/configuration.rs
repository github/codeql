use crate::util::cmp_option_by;
use itertools::Itertools;
use ra_ap_base_db::{SourceDatabase, SourceRootId, all_crates};
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

/// Reads the file's source-root ID in `db`.
///
/// A source root is rust-analyzer's group of files within which relative paths
/// are resolved. It need not correspond to one crate: a package's library and
/// build script can share a source root.
fn source_root_id(db: &RootDatabase, file_id: FileId) -> SourceRootId {
    db.file_source_root(file_id).source_root_id(db)
}

/// Maps source root IDs to cfg options shared by all their crates, using only
/// metadata.
///
/// In order for a file to be included in a crate the crate's root file and the
/// file must share the same source root. However, this condition is not
/// sufficient. The construction here relies on this to identify the cases where
/// this requirement _is_ sufficient to determine the cfg options of any crate
/// that could contain the file. Either because only one crate can contain it or
/// because all such crates share the same cfg options.
///
/// Roots whose crates disagree map to `None` and need per-file semantic lookup.
fn root_configurations(db: &RootDatabase) -> HashMap<SourceRootId, Option<&CfgOptions>> {
    let mut configurations = HashMap::new();
    for &krate in all_crates(db).iter() {
        let root = source_root_id(db, krate.data(db).root_file_id);
        configurations
            .entry(root)
            .and_modify(|configuration: &mut Option<&CfgOptions>| {
                // We're in the case where multiple crates share a source root,
                // for example a library and its build script. If their cfg
                // options differ, we mark the configuration as `None`.
                if configuration.is_some_and(|cfg| cfg != krate.cfg_options(db)) {
                    *configuration = None;
                }
            })
            .or_insert_with(|| Some(krate.cfg_options(db)));
    }
    configurations
}

/// Returns an iterator over the dependency files in `vfs`.
///
/// These are files that correspond to libraries and that are not in `source_files`.
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
                .source_root(source_root_id(db, file_id))
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

/// Tracks extraction candidates for each dependency file. Keeps one preferred
/// manifest per distinct set of cfg options, allowing lower-priority
/// configurations to be tried if the preferred one disables a file.
#[derive(Default)]
pub struct DependencyFiles<'a> {
    files: BTreeMap<PathBuf, Vec<DependencySource<'a>>>,
}

impl<'a> DependencyFiles<'a> {
    /// Considers dependency files loaded from this manifest as extraction
    /// candidates. The lexicographically largest manifest directory wins for
    /// each configuration.
    pub fn add_manifest(
        &mut self,
        manifest: &'a ProjectManifest,
        semantics: &Semantics<'_, RootDatabase>,
        vfs: &Vfs,
        source_files: &HashSet<PathBuf>,
    ) {
        let db = semantics.db;
        let root_configurations = root_configurations(db);
        for (file_id, file) in dependency_files(db, vfs, source_files) {
            let root = source_root_id(db, file_id);
            let cfg_options = match root_configurations.get(&root) {
                // There's a unique cfg configuration for this file.
                Some(Some(configuration)) => Some((*configuration).clone()),
                // There's no unique cfg configuration for this file. In this
                // case we fall back to the expensive `file_to_module_def`
                // approach which requires rust_analyzer to calculate semantic
                // information.
                Some(None) => semantics
                    .file_to_module_def(file_id)
                    .map(|module| module.krate(db).cfg(db).clone()),
                None => None,
            };
            self.add_candidate(file, cfg_options, manifest);
        }
    }

    /// Adds `cfg_options` and `manifest` as an extraction candidate for the
    /// given file unless a higher-priority candidate with the same cfg options
    /// already exists.
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
                    if manifest_parent(manifest) > manifest_parent(source.manifest) {
                        source.manifest = manifest;
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

    /// Takes the highest-priority remaining context for each file, grouped by
    /// manifest. Lower-priority configurations remain available if the selected
    /// one disables the file.
    pub fn by_manifests(&mut self) -> HashMap<&'a ProjectManifest, Vec<PathBuf>> {
        self.files
            .iter_mut()
            .filter_map(|(file, sources)| {
                sources.sort_unstable();
                sources.pop().map(|source| (source.manifest, file.clone()))
            })
            .into_group_map()
    }

    /// Returns `true` if there are alternative configurations left for the
    /// given file.
    pub fn has_alternative(&self, file: &Path) -> bool {
        self.files
            .get(file)
            .is_some_and(|sources| !sources.is_empty())
    }

    /// Marks a file as extracted, removing it from the map of files.
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

    fn workspace(files: &[&str], crates: &[(&str, &[&str])]) -> (RootDatabase, Vfs) {
        let root = crate::cwd().unwrap();
        let mut vfs = Vfs::default();
        let mut file_set = FileSet::default();
        let mut change = FileChange::default();
        for &name in files {
            let path = VfsPath::from(root.join(name));
            vfs.set_file_contents(path.clone(), Some(Vec::new()));
            let (id, _) = vfs.file_id(&path).unwrap();
            file_set.insert(id, path);
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
            let (db, vfs) = workspace(&["lib.rs", "build.rs", "module.rs"], &crates);
            let root = crate::cwd().unwrap();
            let manifest = ProjectManifest::from_manifest_file(root.join("Cargo.toml")).unwrap();
            let mut plan = DependencyFiles::default();
            plan.add_manifest(&manifest, &Semantics::new(&db), &vfs, &HashSet::new());
            assert_eq!(plan.files.len(), 3);
            for sources in plan.files.values() {
                assert_eq!(sources[0].cfg_options, Some(cfg(&["a"])));
            }
        }
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

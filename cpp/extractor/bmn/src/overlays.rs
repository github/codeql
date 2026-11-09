use crate::directory_tree::DirectoryTree;
use crate::environment;
use crate::include_finder::find_includes;
use crate::include_scanner::get_includes;
use crate::logger::{debug, log};
use crate::project_definitions::SourceDirectory;
use anyhow::{Result, anyhow};
use serde_json::{Value, from_reader};
use std::collections::HashSet;
use std::fs;
use std::hash;
use std::path::PathBuf;

pub enum OverlaySettings {
    Full,
    Base {
        metadata_out: PathBuf,
    },
    Overlay {
        changed_files: Vec<PathBuf>,
        metadata_in: PathBuf,
    },
}

impl OverlaySettings {
    pub fn overlay_mode(&self) -> &'static str {
        match self {
            OverlaySettings::Full => "full",
            OverlaySettings::Base { .. } => "base",
            OverlaySettings::Overlay { .. } => "overlay",
        }
    }

    /// Returns `true` if the overlay settings is [`Overlay`].
    ///
    /// [`Overlay`]: OverlaySettings::Overlay
    pub fn is_overlay(&self) -> bool {
        matches!(self, Self::Overlay { .. })
    }

    pub fn is_enabled(&self) -> bool {
        !matches!(self, OverlaySettings::Full)
    }
}

pub fn get_overlay_settings() -> Result<OverlaySettings> {
    let overlay_changes =
        environment::get_optional_path(environment::CODEQL_EXTRACTOR_CPP_OVERLAY_CHANGES);
    let metadata_out =
        environment::get_optional_path(environment::CODEQL_EXTRACTOR_CPP_OVERLAY_BASE_METADATA_OUT);
    let metadata_in =
        environment::get_optional_path(environment::CODEQL_EXTRACTOR_CPP_OVERLAY_METADATA_IN);
    match (overlay_changes, metadata_in, metadata_out) {
        (Some(overlay_changes), Some(metadata_in), None) => {
            let changes_file = fs::File::open(overlay_changes)?;
            let json: Value = from_reader(changes_file)?;
            let obj = json.as_object().ok_or(anyhow!(
                "Overlay changes file does not contain a JSON object."
            ))?;
            // TODO: Log/warn if there are any fields other than "changes"
            let files = obj.get("changes").ok_or_else(|| {
                anyhow!("Overlay changes file does not contain a 'changes' field.")
            })?;
            let files_array = files.as_array().ok_or(anyhow!(
                "Overlay changes file 'changes' field is not an array."
            ))?;
            let changed_files = files_array
                .iter()
                .map(|v| {
                    Ok(v.as_str()
                        .ok_or(anyhow!("Overlay changes file contains non-string entries."))?
                        .into())
                })
                .collect::<Result<_>>()?;
            Ok(OverlaySettings::Overlay {
                changed_files,
                metadata_in,
            })
        }
        (None, None, Some(metadata_out)) => Ok(OverlaySettings::Base { metadata_out }),
        (Some(_), None, _) => Err(anyhow!(
            "Metadata in must be specified when overlay changes are provided."
        )),
        (None, Some(_), _) => Err(anyhow!(
            "Metadata in cannot be specified when overlay changes are not provided."
        )),
        (Some(_), _, Some(_)) => Err(anyhow!(
            "Metadata out cannot be specified when overlay changes are provided."
        )),
        (None, None, None) => Ok(OverlaySettings::Full),
    }
}

/// Computes which source files need re-extraction based on header dependencies.
///
/// A source file needs re-extraction if:
/// 1. The source file itself is in the changed files set, OR
/// 2. Any header it (transitively) includes is in the changed files set
pub fn compute_sources_needing_reextraction<S: hash::BuildHasher + Default>(
    source_dir: &SourceDirectory,
    changed_files: &HashSet<PathBuf, S>,
) -> HashSet<PathBuf, S> {
    debug!(
        "Computing sources needing re-extraction for {} changed files",
        changed_files.len()
    );

    let tree = &source_dir.all_files;
    let no_default_includes = HashSet::default();
    let mut sources_to_reextract: HashSet<PathBuf, S> = HashSet::default();

    for source_file in &source_dir.sources {
        let source_path = &source_file.path;

        // Check if source file itself changed
        if changed_files.contains(source_path) {
            debug!("Source {:?} directly changed", source_path);
            sources_to_reextract.insert(source_path.clone());
            continue;
        }

        // Check if any of its headers changed
        let includes = get_includes(source_path.clone());
        let empty_tree = DirectoryTree::default();
        let result = find_includes(tree, &empty_tree, &no_default_includes, &includes);

        let has_changed_header = result
            .resolved_headers
            .iter()
            .any(|header| changed_files.contains(header));

        if has_changed_header {
            debug!("Source {:?} has changed header dependencies", source_path);
            sources_to_reextract.insert(source_path.clone());
        }
    }

    debug!(
        "Found {} sources needing re-extraction out of {}",
        sources_to_reextract.len(),
        source_dir.sources.len()
    );

    sources_to_reextract
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::test_utils::get_resource;
    use all_asserts::assert_true;

    #[test]
    fn test_compute_sources_needing_reextraction_direct_source_change() {
        let path = get_resource("dir1");
        let source_dir = SourceDirectory::new(&path, None);

        // If file1.c changed, it should be re-extracted
        let changed: HashSet<PathBuf> = HashSet::from([path.join("file1.c")]);
        let result = compute_sources_needing_reextraction(&source_dir, &changed);

        assert_eq!(result.len(), 1, "Expected 1 file, got: {result:?}");
        assert_true!(
            result.contains(&path.join("file1.c")),
            "Expected file1.c in result: {:?}",
            result
        );
    }

    #[test]
    fn test_compute_sources_needing_reextraction_header_change() {
        let path = get_resource("dir1");
        let source_dir = SourceDirectory::new(&path, None);

        // If local_include.h changed, only_locals.cpp should be re-extracted
        let changed: HashSet<PathBuf> = HashSet::from([path.join("local_include.h")]);
        let result = compute_sources_needing_reextraction(&source_dir, &changed);

        assert_eq!(result.len(), 1, "Expected 1 file, got: {result:?}");
        assert_true!(
            result.contains(&path.join("only_locals.cpp")),
            "Expected only_locals.cpp in result: {:?}",
            result
        );
    }

    #[test]
    fn test_compute_sources_needing_reextraction_no_changes() {
        let path = get_resource("dir1");
        let source_dir = SourceDirectory::new(&path, None);

        // If nothing relevant changed, nothing should be re-extracted
        let changed: HashSet<PathBuf> = HashSet::from([path.join("nonexistent.txt")]);
        let result = compute_sources_needing_reextraction(&source_dir, &changed);

        assert_true!(result.is_empty(), "Expected 0 files, got: {:?}", result);
    }

    #[test]
    fn test_compute_sources_needing_reextraction_nested_header_change() {
        let path = get_resource("dir1");
        let source_dir = SourceDirectory::new(&path, None);

        // If dir2/file4.hpp changed, file1.c, only_locals.cpp, and dir2/file3.cpp should be re-extracted
        let changed: HashSet<PathBuf> = HashSet::from([path.join("dir2/file4.hpp")]);
        let result = compute_sources_needing_reextraction(&source_dir, &changed);

        assert_eq!(result.len(), 3, "Expected 3 files, got: {result:?}");
        assert_true!(
            result.contains(&path.join("only_locals.cpp")),
            "Expected only_locals.cpp in result: {:?}",
            result
        );
        assert_true!(
            result.contains(&path.join("file1.c")),
            "Expected file1.c in result: {:?}",
            result
        );
        assert_true!(
            result.contains(&path.join("dir2/file3.cpp")),
            "Expected dir2/file3.cpp in result: {:?}",
            result
        );
    }

    #[test]
    fn test_compute_sources_needing_reextraction_empty_changed_set() {
        let path = get_resource("dir1");
        let source_dir = SourceDirectory::new(&path, None);

        // Empty changed files set should return empty result
        let changed: HashSet<PathBuf> = HashSet::new();
        let result = compute_sources_needing_reextraction(&source_dir, &changed);

        assert_true!(result.is_empty(), "Expected 0 files, got: {:?}", result);
    }

    #[test]
    fn test_compute_sources_needing_reextraction_transitive_header_change() {
        let path = get_resource("recursion_in_headers");
        let source_dir = SourceDirectory::new(&path, None);

        // file.c -> header1.h -> header2.h -> header2_2.h -> header3.h
        // Changing the deepest header (header3.h) should trigger file.c re-extraction
        let changed: HashSet<PathBuf> = HashSet::from([path.join("dir1/dir2/dir3/header3.h")]);
        let result = compute_sources_needing_reextraction(&source_dir, &changed);

        assert_eq!(result.len(), 1, "Expected 1 file, got: {result:?}");
        assert_true!(
            result.contains(&path.join("file.c")),
            "Expected file.c in result: {:?}",
            result
        );
    }

    #[test]
    fn test_compute_sources_needing_reextraction_intermediate_header_change() {
        let path = get_resource("recursion_in_headers");
        let source_dir = SourceDirectory::new(&path, None);

        // file.c -> header1.h -> header2.h -> header2_2.h -> header3.h
        // Changing an intermediate header (header2.h) should also trigger file.c re-extraction
        let changed: HashSet<PathBuf> = HashSet::from([path.join("dir1/dir2/header2.h")]);
        let result = compute_sources_needing_reextraction(&source_dir, &changed);

        assert_eq!(result.len(), 1, "Expected 1 file, got: {result:?}");
        assert_true!(
            result.contains(&path.join("file.c")),
            "Expected file.c in result: {:?}",
            result
        );
    }
}

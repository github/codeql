use std::{
    collections::{HashMap, HashSet},
    ffi::OsString,
    path::{Path, PathBuf},
};

use std::cell::OnceCell;

use itertools::Itertools;
use walkdir::{DirEntry, WalkDir};

use crate::path_utils::strip_suffix;

fn group_files_by_name(files: &[PathBuf]) -> HashMap<OsString, HashSet<PathBuf>> {
    files
        .iter()
        .filter_map(|file| Some((file.file_name()?.to_os_string(), file.clone())))
        .into_grouping_map()
        .collect()
}

/// Finds all files in the given directory and returns the result in a sorted vector.
pub fn all_files_in(directory: &Path) -> Vec<PathBuf> {
    WalkDir::new(directory)
        .into_iter()
        .filter_map(Result::ok)
        .filter(|e| e.file_type().is_file())
        .map(DirEntry::into_path)
        .sorted()
        .collect()
}

/// Represents a directory and all the files within it.
///
/// Provides fast-ish lookup of files with a given suffix within the directory.
#[derive(Default, Clone, Debug)]
pub struct DirectoryTree {
    /// All files in the directory
    files: Vec<PathBuf>,
    /// All files indexed by name, lazily initialized.
    files_by_name: OnceCell<HashMap<OsString, HashSet<PathBuf>>>,
}

impl DirectoryTree {
    pub fn from_files<T: Into<Vec<PathBuf>>>(files: T) -> Self {
        DirectoryTree {
            files: files.into(),
            files_by_name: OnceCell::new(),
        }
    }

    pub fn from_path(directory: &Path) -> Self {
        Self::from_files(all_files_in(directory))
    }

    fn get_files_by_name(&self) -> &HashMap<OsString, HashSet<PathBuf>> {
        self.files_by_name
            .get_or_init(|| group_files_by_name(&self.files))
    }

    fn files_with_same_name(&self, file: &Path) -> Option<&HashSet<PathBuf>> {
        self.get_files_by_name().get(file.file_name()?)
    }

    /// Returns the total number of files in the directory tree.
    pub fn len(&self) -> usize {
        self.files.len()
    }

    pub fn is_empty(&self) -> bool {
        self.files.is_empty()
    }

    /// Returns the number of unique file names in the directory tree.
    pub fn unique_name_count(&self) -> usize {
        self.get_files_by_name().len()
    }

    pub fn contains(&self, file: &Path) -> bool {
        self.files_with_same_name(file)
            .is_some_and(|files| files.contains(file))
    }

    /// Returns a set of directories containing the given file suffix.
    ///
    /// For example, if the directory tree contains `/a/sub/foo.h` and `/b/sub/foo.h` then the
    /// suffix `sub/foo.h` results in `/a` and `/b`.
    pub fn directories_with_path(&self, file_suffix: &Path) -> HashSet<PathBuf> {
        self.files_with_same_name(file_suffix)
            .map(|files_with_name| {
                files_with_name
                    .iter()
                    .filter_map(|p| strip_suffix(p, file_suffix))
                    .collect()
            })
            .unwrap_or_default()
    }

    /// Returns an iterator over all files in the directory tree.
    pub fn iter(&self) -> std::slice::Iter<'_, PathBuf> {
        self.files.iter()
    }
}

impl<'a> IntoIterator for &'a DirectoryTree {
    type Item = &'a PathBuf;
    type IntoIter = std::slice::Iter<'a, PathBuf>;

    fn into_iter(self) -> Self::IntoIter {
        self.files.iter()
    }
}

impl IntoIterator for DirectoryTree {
    type Item = PathBuf;
    type IntoIter = std::vec::IntoIter<PathBuf>;

    fn into_iter(self) -> Self::IntoIter {
        self.files.into_iter()
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    fn test_tree() -> DirectoryTree {
        DirectoryTree::from_files(vec![
            PathBuf::from("/b/foo.h"),
            PathBuf::from("/a/foo.h"),
            PathBuf::from("/d/sub/foo.h"),
            PathBuf::from("/c/sub/foo.h"),
            PathBuf::from("/c/sub/bar.h"),
        ])
    }

    #[test]
    fn test_multiple_matches_sorted() {
        assert_eq!(
            test_tree().directories_with_path(Path::new("foo.h")),
            HashSet::from([
                PathBuf::from("/a"),
                PathBuf::from("/b"),
                PathBuf::from("/c/sub"),
                PathBuf::from("/d/sub")
            ])
        );
    }

    #[test]
    fn test_nested_suffix() {
        assert_eq!(
            test_tree().directories_with_path(Path::new("sub/foo.h")),
            HashSet::from([PathBuf::from("/c"), PathBuf::from("/d")])
        );
    }

    #[test]
    fn test_no_match() {
        let tree = test_tree();
        assert!(
            tree.directories_with_path(Path::new("missing.h"))
                .is_empty()
        );
        assert!(
            tree.directories_with_path(Path::new("other/foo.h"))
                .is_empty()
        );
    }

    mod from_path {
        use super::*;
        use crate::test_utils::get_resource;
        use std::collections::HashSet;
        use std::ffi::OsString;

        fn check_files(tree: &DirectoryTree, file_name: &str, expected: &[PathBuf]) {
            let files = tree
                .get_files_by_name()
                .get(&OsString::from(file_name))
                .expect("file not found");
            assert_eq!(files, &expected.iter().cloned().collect::<HashSet<_>>());
        }

        #[test]
        fn test_dir1() {
            let path = get_resource("dir1");
            let tree = DirectoryTree::from_path(&path);
            assert_eq!(tree.get_files_by_name().len(), 7);
            check_files(&tree, "file1.c", &[path.join("file1.c")]);
            check_files(&tree, "file2.h", &[path.join("file2.h")]);
            check_files(&tree, "local_include.h", &[path.join("local_include.h")]);
            check_files(&tree, "only_locals.cpp", &[path.join("only_locals.cpp")]);
            check_files(&tree, "file3.cpp", &[path.join("dir2/file3.cpp")]);
            check_files(&tree, "file4.hpp", &[path.join("dir2/file4.hpp")]);
            check_files(
                &tree,
                "only_relative.cc",
                &[path.join("dir2/only_relative.cc")],
            );
        }

        #[test]
        fn test_path_choice() {
            let path = get_resource("path-choice");
            let tree = DirectoryTree::from_path(&path);
            assert_eq!(tree.get_files_by_name().len(), 2);
            check_files(
                &tree,
                "a.h",
                &[path.join("dir1/a.h"), path.join("dir2/a.h")],
            );
            check_files(
                &tree,
                "main.c",
                &[path.join("dir1/main.c"), path.join("dir2/main.c")],
            );
        }

        #[test]
        fn test_absolute_paths_in_include() {
            let path = get_resource("absolute_paths_in_include");
            let tree = DirectoryTree::from_path(&path);
            assert_eq!(tree.get_files_by_name().len(), 4);
            check_files(
                &tree,
                "a_header_in_same_dir.h",
                &[path.join("a_header_in_same_dir.h")],
            );
            check_files(&tree, "file.c", &[path.join("file.c")]);
            check_files(
                &tree,
                "header_specified_through_absolute_path.h",
                &[path.join("header_specified_through_absolute_path.h")],
            );
            check_files(
                &tree,
                "a_header_in_subdir.h",
                &[path.join("subdir/a_header_in_subdir.h")],
            );
        }
    }
}

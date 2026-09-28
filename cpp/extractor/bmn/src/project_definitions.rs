use super::file_filter::FileFilter;
use crate::directory_tree::DirectoryTree;
use crate::logger::{info, log};
use crate::overlays::compute_sources_needing_reextraction;
use std::cmp;
use std::cmp::Ordering;
use std::collections::HashSet;
use std::ffi::OsStr;
use std::hash::Hash;
use std::path::{Path, PathBuf};
use std::time::{Duration, Instant};

/// Maps a file extension to its `(language, is_header)` info.
fn get_extension_info(ext: &str) -> Option<(Language, bool)> {
    match ext {
        "c" => Some((Language::C, false)),
        "h" => Some((Language::C, true)),
        "cpp" | "cc" | "cxx" | "c++" => Some((Language::Cpp, false)),
        "hpp" | "hxx" | "hh" | "h++" | "inc" => Some((Language::Cpp, true)),
        _ => None,
    }
}

fn path_extension_info<S: AsRef<OsStr>>(path: S) -> Option<(Language, bool)> {
    get_extension_info(Path::new(&path).extension()?.to_str()?)
}

pub fn is_source_file(path: &Path) -> bool {
    path_extension_info(path).is_some_and(|(_, is_header)| !is_header)
}

pub fn is_header_file(path: &Path) -> bool {
    path_extension_info(path).is_some_and(|(_, is_header)| is_header)
}

#[derive(Debug, Eq, PartialEq, Copy, Clone, Hash)]
pub enum Language {
    C,
    Cpp,
}

impl Language {
    /// Returns the language to add to the gnu compiler command line.
    pub fn gnu_language_descriptor(&self) -> &'static str {
        match self {
            Language::C => "c",
            Language::Cpp => "c++",
        }
    }
}

/// Either a system include (e.g., `#include <stdio.h>`) or a local include
/// (e.g., `#include "myheader.h"`).
#[derive(Debug, PartialEq, Eq, Clone, Copy, Hash)]
pub enum IncludeKind {
    Local,
    System,
}

#[derive(Debug, Eq, PartialEq, Clone, Hash)]
pub struct IncludeDirective {
    pub kind: IncludeKind,
    pub path: PathBuf,
    pub containing_file: PathBuf,
}

impl IncludeDirective {
    pub fn new(
        kind: IncludeKind,
        path: impl Into<PathBuf>,
        containing_file: impl Into<PathBuf>,
    ) -> Self {
        IncludeDirective {
            kind,
            path: path.into(),
            containing_file: containing_file.into(),
        }
    }
    pub fn system(path: impl Into<PathBuf>, containing_file: impl Into<PathBuf>) -> Self {
        Self::new(IncludeKind::System, path, containing_file)
    }
    pub fn local(path: impl Into<PathBuf>, containing_file: impl Into<PathBuf>) -> Self {
        Self::new(IncludeKind::Local, path, containing_file)
    }
    pub fn is_local(&self) -> bool {
        self.kind == IncludeKind::Local
    }
    /// Gets the directory of the file that contains the include directive.
    pub fn containing_dir(&self) -> &Path {
        self.containing_file
            .parent()
            .expect("containing_file will have a parent as it is a file")
    }
}

#[derive(Debug, Eq, PartialEq, Clone)]
pub struct SourceFile {
    pub path: PathBuf,
    pub language: Language,
}

impl SourceFile {
    fn new(path: impl Into<PathBuf>, language: Language) -> Self {
        SourceFile {
            path: path.into(),
            language,
        }
    }
}

impl Hash for SourceFile {
    fn hash<H: std::hash::Hasher>(&self, state: &mut H) {
        self.path.hash(state);
    }
}

impl PartialOrd<Self> for SourceFile {
    fn partial_cmp(&self, other: &Self) -> Option<Ordering> {
        Some(self.path.cmp(&other.path))
    }
}

impl Ord for SourceFile {
    fn cmp(&self, other: &Self) -> cmp::Ordering {
        self.path.cmp(&other.path)
    }
}

/**
 * Struct representing a directory containing source files.
 * It collects all files, source files, and header files with matching extensions.
 */
pub struct SourceDirectory {
    pub root_directory: PathBuf,
    pub all_files: DirectoryTree,
    pub sources: Vec<SourceFile>,
    pub explicit_headers: Vec<PathBuf>,
}

impl SourceDirectory {
    pub fn new(root_directory: &Path, maybe_file_filter: Option<&FileFilter>) -> Self {
        let all_files = DirectoryTree::from_path(root_directory);

        let mut explicit_headers = Vec::new();
        let mut sources = Vec::new();
        for path in &all_files {
            // TODO: extensions can be empty, e.g. 'iostream'
            if let Some((language, is_header)) = path_extension_info(path) {
                if is_header {
                    explicit_headers.push(path.clone());
                } else if maybe_file_filter.is_none_or(|file_filter| file_filter.accepts(path)) {
                    sources.push(SourceFile::new(path.clone(), language));
                }
            }
        }

        SourceDirectory {
            root_directory: root_directory.to_path_buf(),
            all_files,
            sources,
            explicit_headers,
        }
    }

    pub fn retain_changed_files(&mut self, changed_files: &[PathBuf]) -> Duration {
        // If we are making an overlay database, filter to sources needing re-extraction
        // This includes sources that directly changed OR whose headers changed
        let changed_set: HashSet<PathBuf> = changed_files
            .iter()
            .map(|p| self.root_directory.join(p))
            .collect();
        let start = Instant::now();
        let sources_to_keep = compute_sources_needing_reextraction(self, &changed_set);
        let changed_source_resolution_duration = start.elapsed();
        self.sources
            .retain(|source_file| sources_to_keep.contains(&source_file.path));
        changed_source_resolution_duration
    }

    pub fn get_stats(&self) -> (usize, usize, usize) {
        let all_files = self.all_files.len();
        let source_files = self.sources.len();
        let header_files = self.explicit_headers.len();
        (all_files, source_files, header_files)
    }

    pub fn log_stats(&self) {
        let (all_files, source_files, header_files) = self.get_stats();
        info!(
            "Indexed folder {:?}, found {source_files} source files, {header_files} header files, {all_files} total files.",
            self.root_directory,
        );
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::test_utils::get_resource;

    #[test]
    fn test_language_gnu_descriptor() {
        assert_eq!(Language::C.gnu_language_descriptor(), "c");
        assert_eq!(Language::Cpp.gnu_language_descriptor(), "c++");
    }

    #[test]
    fn test_include_directive_path() {
        let local_include = IncludeDirective::local("local.h", "");
        let system_include = IncludeDirective::system("system.h", "");

        assert_eq!(local_include.path, Path::new("local.h"));
        assert_eq!(system_include.path, Path::new("system.h"));
    }

    #[test]
    fn test_file_equality_and_hash() {
        use std::collections::HashSet;
        let file1 = PathBuf::from("src/main.c");
        let file2 = PathBuf::from("src/main.c");
        let file3 = PathBuf::from("src/lib.cpp");

        assert_eq!(file1, file2);
        assert_ne!(file1, file3);

        let mut set = HashSet::new();
        set.insert(file1.clone());
        set.insert(file2.clone());
        set.insert(file3.clone());
        assert_eq!(set.len(), 2);
    }

    #[test]
    fn test_project_get_stats() {
        use std::fs::File as FsFile;
        use tempfile::tempdir;

        let dir = tempdir().unwrap_or_else(|e| panic!("Failed to create temporary directory: {e}"));
        let src_path = dir.path().join("main.c");
        let hdr_path = dir.path().join("defs.h");
        let txt_path = dir.path().join("notes.txt");

        FsFile::create(&src_path).unwrap_or_else(|e| panic!("Failed to create source file: {e}"));
        FsFile::create(&hdr_path).unwrap_or_else(|e| panic!("Failed to create source file: {e}"));
        FsFile::create(&txt_path).unwrap_or_else(|e| panic!("Failed to create source file: {e}"));

        let project = SourceDirectory::new(dir.path(), None);
        let (total, sources, headers) = project.get_stats();

        assert_eq!(total, 3);
        assert_eq!(sources, 1);
        assert_eq!(headers, 1);
    }

    #[test]
    fn test_new_source_dir_of_dir_1() {
        let path = get_resource("dir1");
        let source_directory = SourceDirectory::new(&path, None);

        let (total_files, source_files, header_files) = source_directory.get_stats();
        assert_eq!(total_files, 7);
        assert_eq!(source_files, 4);
        assert_eq!(header_files, 3);

        let mut expected_sources = vec![
            SourceFile {
                path: path.join("only_locals.cpp"),
                language: Language::Cpp,
            },
            SourceFile {
                path: path.join("dir2/file3.cpp"),
                language: Language::Cpp,
            },
            SourceFile {
                path: path.join("dir2/only_relative.cc"),
                language: Language::Cpp,
            },
            SourceFile {
                path: path.join("file1.c"),
                language: Language::C,
            },
        ];

        let mut expected_headers = vec![
            path.join("dir2/file4.hpp"),
            path.join("file2.h"),
            path.join("local_include.h"),
        ];

        let mut expected_all_files = [
            expected_headers.clone(),
            expected_sources.iter().map(|sf| sf.path.clone()).collect(),
        ]
        .concat();

        expected_sources.sort();
        expected_headers.sort();
        expected_all_files.sort();

        assert_eq!(source_directory.sources, expected_sources);
        assert_eq!(source_directory.explicit_headers, expected_headers);
        itertools::assert_equal(source_directory.all_files, expected_all_files);
    }

    #[test]
    fn test_new_source_dir_of_path_choice() {
        let path = get_resource("path-choice");
        let source_directory = SourceDirectory::new(&path, None);
        let (total_files, source_files, header_files) = source_directory.get_stats();
        assert_eq!(total_files, 4);
        assert_eq!(source_files, 2);
        assert_eq!(header_files, 2);

        let mut expected_sources = vec![
            SourceFile {
                path: path.join("dir1/main.c"),
                language: Language::C,
            },
            SourceFile {
                path: path.join("dir2/main.c"),
                language: Language::C,
            },
        ];

        let mut expected_headers = vec![path.join("dir1/a.h"), path.join("dir2/a.h")];

        let mut expected_all_files = [
            expected_headers.clone(),
            expected_sources.iter().map(|sf| sf.path.clone()).collect(),
        ]
        .concat();

        expected_sources.sort();
        expected_headers.sort();
        expected_all_files.sort();

        assert_eq!(source_directory.sources, expected_sources);
        assert_eq!(source_directory.explicit_headers, expected_headers);
        itertools::assert_equal(source_directory.all_files, expected_all_files);
    }

    #[test]
    fn test_new_source_dir_of_absolute_paths_in_include() {
        let path = get_resource("absolute_paths_in_include");
        let source_directory = SourceDirectory::new(&path, None);
        let (total_files, source_files, header_files) = source_directory.get_stats();
        assert_eq!(total_files, 4);
        assert_eq!(source_files, 1);
        assert_eq!(header_files, 3);

        let mut expected_sources = vec![SourceFile {
            path: path.join("file.c"),
            language: Language::C,
        }];

        let mut expected_headers = vec![
            path.join("a_header_in_same_dir.h"),
            path.join("header_specified_through_absolute_path.h"),
            path.join("subdir/a_header_in_subdir.h"),
        ];

        let mut expected_all_files = [
            expected_headers.clone(),
            expected_sources.iter().map(|sf| sf.path.clone()).collect(),
        ]
        .concat();

        expected_sources.sort();
        expected_headers.sort();
        expected_all_files.sort();

        assert_eq!(source_directory.sources, expected_sources);
        assert_eq!(source_directory.explicit_headers, expected_headers);
        itertools::assert_equal(source_directory.all_files, expected_all_files);
    }
}

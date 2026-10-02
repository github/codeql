use itertools::Itertools;

use super::compiler::{CompilerConfig, CompilerFamily};
use super::include_scanner::get_includes;
use super::project_definitions::{IncludeDirective, SourceFile};
use super::telemetry::{Severity, Telemetry, TelemetryMessage};
use super::timing::ExecuteAccumulateTime;
use crate::compiler::CompilerDefaultIncludes;
use crate::directory_tree::DirectoryTree;
use crate::logger::{debug, log};
use crate::path_utils::{is_absolute, path_distances};
use std::collections::HashSet;
use std::path::{Path, PathBuf};
use std::time::Duration;

#[derive(Debug, PartialEq)]
enum ResolveIncludeResult {
    Found(PathBuf),
    FoundDefault,
    NotFound,
}

fn filter_extend_stack_with(
    stack: &mut Vec<IncludeDirective>,
    include_directives: &[IncludeDirective],
) {
    stack.extend(
        include_directives
            .iter()
            // Don't try to resolve include directives which are absolute, specifically relative
            // to the current directory (starting with `.`) or to path which is not a file
            .filter(|id| {
                !is_absolute(&id.path)
                        // TODO: skipping paths starting with `.` is a simplification that may lead
                        //  to skip some valid includes. In the future we may want to handle them
                        && !id.path.starts_with(".")
                        && id.path.file_name().is_some()
            })
            // Clone, so we don't have problem of ownership with the other includes that are added later
            .cloned(),
    );
}

/// Check the given files for includes, if it has already been visited, do nothing, if not,
/// scan it for includes and add them to the stack and add to the visited list.
fn explore_resolved_file(
    to_process: &mut Vec<IncludeDirective>,
    visited_headers: &mut HashSet<PathBuf>,
    included_file: &PathBuf,
) {
    if !visited_headers.contains(included_file) {
        // We never visited this file. Add its own includes to the queue
        let inner_includes = get_includes(included_file.clone());

        filter_extend_stack_with(to_process, &inner_includes);

        visited_headers.insert(included_file.clone());
    }
}

/// Tries to infer an include path for an include directive by looking for files with the same name
/// and returning the shortest path prefix (in terms of path components) that, when combined with
/// the include directive path, gives the full path to the file.
fn infer_include_path(
    available_headers: &DirectoryTree,
    include_directive: &IncludeDirective,
) -> Option<PathBuf> {
    available_headers
        .directories_with_path(&include_directive.path)
        .into_iter()
        // Get the directories with the least amount of directory-up first, then directory-down
        .min_set_by_key(|dir| path_distances(include_directive.containing_dir(), dir))
        .into_iter()
        // If multiple directories are at the same distance, take the first alphabetically
        .min()
}

/// Finds the header file included by `include_directive` in the search path represented by
/// `include_dirs`.
fn find_in_include_dirs(
    available_files: &DirectoryTree,
    include_dirs: &[PathBuf],
    include_directive: &IncludeDirective,
) -> Option<PathBuf> {
    let current_dir = include_directive
        .is_local()
        .then(|| include_directive.containing_dir().to_path_buf());
    // For local includes (#include "..."), the containing directory is searched first.
    let directories_to_search = current_dir.iter().chain(include_dirs.iter());

    directories_to_search.into_iter().find_map(|folder| {
        let path = folder.join(&include_directive.path);
        available_files.contains(&path).then_some(path)
    })
}

fn resolve_include_directive(
    project_files: &DirectoryTree,
    system_files: &DirectoryTree,
    compiler_default_includes: &HashSet<PathBuf>,
    include_dirs: &[PathBuf],
    include_directive: &IncludeDirective,
) -> ResolveIncludeResult {
    if let Some(found_at) = find_in_include_dirs(project_files, include_dirs, include_directive) {
        ResolveIncludeResult::Found(found_at)
    } else if let Some(found_at) =
        find_in_include_dirs(system_files, include_dirs, include_directive)
    {
        ResolveIncludeResult::Found(found_at)
    } else if compiler_default_includes.contains(&include_directive.path) {
        ResolveIncludeResult::FoundDefault
    } else {
        ResolveIncludeResult::NotFound
    }
}

pub fn find_includes(
    project_files: &DirectoryTree,
    system_files: &DirectoryTree,
    compiler_default_includes: &HashSet<PathBuf>,
    include_directives: &[IncludeDirective],
) -> IncludeFinderResult {
    // Cache to avoid traversing the same header file twice
    let mut visited_headers: HashSet<PathBuf> = HashSet::new();

    // Directories to add to the compiler search path for header files as `-I` flags.
    let mut include_directories: Vec<PathBuf> = Vec::new();

    // List of include directives which are not resolvable
    let mut unresolvable: Vec<IncludeDirective> = Vec::new();

    // List of include directives still to process
    let mut worklist: Vec<IncludeDirective> = Vec::new();

    filter_extend_stack_with(&mut worklist, include_directives);

    while let Some(current_include_directive) = worklist.pop() {
        // Check what is the status of the current include directive:
        match resolve_include_directive(
            project_files,
            system_files,
            compiler_default_includes,
            &include_directories,
            &current_include_directive,
        ) {
            ResolveIncludeResult::FoundDefault => {
                // The include directive is satisfied by a compiler default include directory.
                debug!(
                    "Include {:?} found in a default include directory",
                    current_include_directive.path
                );
            }
            ResolveIncludeResult::Found(path) => {
                // Add all the include directives of `path` to the list of include directives
                // still to process. Then update the visited-files cache.
                explore_resolved_file(&mut worklist, &mut visited_headers, &path);
            }
            ResolveIncludeResult::NotFound => {
                // Header files on the system do not depend on header files in the project. Hence
                // they should not give rise to new include paths into the project. Therefore we
                // only attempt to infer an include path in the project source if the file
                // containing the include directive is inside the project.
                let found_project =
                    if project_files.contains(&current_include_directive.containing_file) {
                        infer_include_path(project_files, &current_include_directive)
                    } else {
                        None
                    };
                let found = found_project
                    .or_else(|| infer_include_path(system_files, &current_include_directive));

                if let Some(dir_to_add) = found {
                    debug!(
                        "Include {:?} in {:?} caused {:?} to be added",
                        current_include_directive.path,
                        current_include_directive.containing_file,
                        dir_to_add
                    );
                    include_directories.push(dir_to_add.clone());
                    let file_name = dir_to_add.join(&current_include_directive.path);
                    explore_resolved_file(&mut worklist, &mut visited_headers, &file_name);
                } else {
                    debug!(
                        "Include {:?} in {:?} still missing",
                        current_include_directive.path, current_include_directive.containing_file
                    );
                    unresolvable.push(current_include_directive);
                }
            }
        }
    }

    IncludeFinderResult {
        include_directories,
        unresolvable,
        resolved_headers: visited_headers,
    }
}

/// Result of running `find_includes`.
#[derive(Default)]
pub struct IncludeFinderResult {
    /// Include directories that the compiler should search for header files
    pub include_directories: Vec<PathBuf>,
    /// Include directives that could not be resolved.
    pub unresolvable: Vec<IncludeDirective>,
    /// Set of header file paths that were resolved during include scanning.
    pub resolved_headers: HashSet<PathBuf>,
}

/// Result of inferring include paths for a single source file.
#[derive(Debug, Clone)]
pub struct InferredIncludes {
    pub include_directories: Vec<PathBuf>,
    pub unresolvable: HashSet<PathBuf>,
    pub lookup_duration: Duration,
}

/// Create a directory tree for all the files available on the system that might be header files
/// that should be included.
pub fn find_system_header_files(compiler_config: &CompilerConfig) -> DirectoryTree {
    match compiler_config.family {
        CompilerFamily::Posix => DirectoryTree::from_path(Path::new("/usr/include")),
        CompilerFamily::Msvc => DirectoryTree::default(),
    }
}

/// Infers include paths for a single source file.
pub fn infer_include_paths(
    source: &DirectoryTree,
    system: &DirectoryTree,
    compiler_default_includes: &CompilerDefaultIncludes,
    file: &SourceFile,
) -> InferredIncludes {
    let mut lookup_timer = ExecuteAccumulateTime::default();

    let result = lookup_timer.execute_accumulate_time(|| {
        let includes = get_includes(file.path.clone());
        find_includes(
            source,
            system,
            compiler_default_includes.defaults_for(file.language),
            &includes,
        )
    });

    let unresolvable: HashSet<PathBuf> =
        result.unresolvable.iter().map(|p| p.path.clone()).collect();

    InferredIncludes {
        include_directories: result.include_directories,
        unresolvable,
        lookup_duration: lookup_timer.total(),
    }
}

/// Aggregated statistics from include inference across all files.
#[derive(Default)]
pub struct AggregatedIncludeStats {
    pub all_includes_missing: HashSet<PathBuf>,
    pub include_directories_added: HashSet<PathBuf>,
    pub total_duration: Duration,
}

impl AggregatedIncludeStats {
    #[must_use]
    pub fn aggregate(mut self, inferred: InferredIncludes) -> Self {
        self.all_includes_missing.extend(inferred.unresolvable);
        self.include_directories_added
            .extend(inferred.include_directories);
        self.total_duration += inferred.lookup_duration;
        self
    }
}

pub fn send_folder_scan_telemetry(content: serde_json::Value, telemetry: &Telemetry) {
    let message = TelemetryMessage::new(
        Severity::Note,
        "cpp/bmn/folder-scan-information",
        "Folder scan information",
    )
    .attributes(content);

    telemetry.write_message(message);
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::compiler::compute_include_files;
    use crate::include_scanner;
    use crate::test_utils::{create_populate_tmp_dir, get_resource};
    use all_asserts::assert_true;
    use std::path::Path;

    fn create_tree(files: &[&str]) -> DirectoryTree {
        DirectoryTree::from_files(files.iter().map(PathBuf::from).collect::<Vec<_>>())
    }

    fn empty_tree() -> DirectoryTree {
        DirectoryTree::default()
    }

    fn scan_for_includes(path: &Path) -> Vec<IncludeDirective> {
        include_scanner::get_includes(path.to_path_buf())
            .into_iter()
            .filter(|include| !include.path.is_absolute())
            .collect()
    }

    mod resolve_include_directive {
        use super::*;

        #[test]
        fn test_found_in_project() {
            let tree = create_tree(&[
                "/project/include/foo.h",
                "/project/foo.h",
                "/project/include/bar.h",
            ]);

            let include_directive = IncludeDirective::system("bar.h", "/project/file.c");
            let include_dirs = vec![PathBuf::from("/project/include")];

            let result = resolve_include_directive(
                &tree,
                &empty_tree(),
                &HashSet::default(),
                &include_dirs,
                &include_directive,
            );
            assert_eq!(
                result,
                ResolveIncludeResult::Found(PathBuf::from("/project/include/bar.h"))
            );
        }

        #[test]
        fn test_found_with_many() {
            let tree = create_tree(&[
                "/project/include/foo.h",
                "/project/1/include/foo.h",
                "/project/2/include/foo.h",
                "/project/foo.h",
                "/project/include/bar.h",
            ]);

            let include_directive = IncludeDirective::system("include/foo.h", "/project/file.c");
            let include_dirs = vec![
                PathBuf::from("/project/include"),
                PathBuf::from("/project/1"),
                PathBuf::from("/project/2"),
                PathBuf::from("/project"),
            ];

            let result = resolve_include_directive(
                &tree,
                &empty_tree(),
                &HashSet::default(),
                &include_dirs,
                &include_directive,
            );
            assert_eq!(
                result,
                ResolveIncludeResult::Found(PathBuf::from("/project/1/include/foo.h"))
            );
        }

        #[test]
        fn test_not_found() {
            let tree = create_tree(&[
                "/project/include/foo.h",
                "/project/foo.h",
                "/project/include/bar.h",
            ]);

            let include_directive = IncludeDirective::system("biz.h", "/project/file.c");
            let include_dirs = vec![PathBuf::from("/project/include"), PathBuf::from("/project")];

            let result = resolve_include_directive(
                &tree,
                &empty_tree(),
                &HashSet::default(),
                &include_dirs,
                &include_directive,
            );
            assert_eq!(result, ResolveIncludeResult::NotFound);
        }

        #[test]
        fn test_missing_include_folder() {
            let tree = create_tree(&[
                "/project/include/foo.h",
                "/project/foo.h",
                "/project/include/bar.h",
            ]);

            let include_directive = IncludeDirective::system("include/foo.h", "/project/file.c");
            let include_dirs = vec![];

            let result = resolve_include_directive(
                &tree,
                &empty_tree(),
                &HashSet::default(),
                &include_dirs,
                &include_directive,
            );
            assert_eq!(result, ResolveIncludeResult::NotFound);
        }

        #[test]
        fn test_local_existing() {
            let tree = create_tree(&[
                "/project/include/foo.h",
                "/project/foo.h",
                "/project/include/bar.h",
            ]);

            let include_directive = IncludeDirective::local("foo.h", "/project/include/bar.c");
            let include_dirs = vec![];

            let result = resolve_include_directive(
                &tree,
                &empty_tree(),
                &HashSet::default(),
                &include_dirs,
                &include_directive,
            );
            assert_eq!(
                result,
                ResolveIncludeResult::Found(PathBuf::from("/project/include/foo.h"))
            );
        }

        #[test]
        fn test_local_existing_with_relative_path() {
            let tree = create_tree(&[
                "/project/include/foo.h",
                "/project/foo.h",
                "/project/include/bar.h",
            ]);

            let include_directive = IncludeDirective::local("include/foo.h", "/project/bar.c");
            let include_dirs = vec![];

            let result = resolve_include_directive(
                &tree,
                &empty_tree(),
                &HashSet::default(),
                &include_dirs,
                &include_directive,
            );
            assert_eq!(
                result,
                ResolveIncludeResult::Found(PathBuf::from("/project/include/foo.h"))
            );
        }

        #[test]
        fn test_local_choose_proper_dir() {
            let tree = create_tree(&[
                "/project/include/foo.h",
                "/project/foo.h",
                "/project/include/bar.h",
            ]);

            let include_directive = IncludeDirective::local("foo.h", "/project/bar.c");
            let include_dirs = vec![];

            let result = resolve_include_directive(
                &tree,
                &empty_tree(),
                &HashSet::default(),
                &include_dirs,
                &include_directive,
            );
            assert_eq!(
                result,
                ResolveIncludeResult::Found(PathBuf::from("/project/foo.h"))
            );
        }

        #[test]
        fn test_local_honours_include_dirs() {
            let tree = create_tree(&[
                "/project/include/foo.h",
                "/project/foo.h",
                "/project/include/bar.h",
            ]);

            let include_directive = IncludeDirective::local("bar.h", "/project/bar.c");
            let include_dirs = vec![PathBuf::from("/project/include")];

            let result = resolve_include_directive(
                &tree,
                &empty_tree(),
                &HashSet::default(),
                &include_dirs,
                &include_directive,
            );
            assert_eq!(
                result,
                ResolveIncludeResult::Found(PathBuf::from("/project/include/bar.h"))
            );
        }

        #[test]
        fn test_local_not_existing() {
            let tree = create_tree(&[
                "/project/include/foo.h",
                "/project/foo.h",
                "/project/include/bar.h",
            ]);

            let include_directive = IncludeDirective::local("bar.h", "/project/bar.c");
            let include_dirs = vec![];

            let result = resolve_include_directive(
                &tree,
                &empty_tree(),
                &HashSet::default(),
                &include_dirs,
                &include_directive,
            );
            assert_eq!(result, ResolveIncludeResult::NotFound);
        }

        #[test]
        fn test_in_default_compiler_folder() {
            let tmp_dir = create_populate_tmp_dir();
            let dirname = tmp_dir.path().to_path_buf();

            let default_includes = compute_include_files(&[dirname]);
            let tree = DirectoryTree::default();

            let include_1 = IncludeDirective::system("sub1/file1.h", "/project/file.c");
            let include_2 = IncludeDirective::system("sub2/file2.hpp", "/project/file.c");
            let include_3 = IncludeDirective::system("root.h", "/project/file.c");

            assert_eq!(
                resolve_include_directive(&tree, &empty_tree(), &default_includes, &[], &include_1),
                ResolveIncludeResult::FoundDefault
            );
            assert_eq!(
                resolve_include_directive(&tree, &empty_tree(), &default_includes, &[], &include_2),
                ResolveIncludeResult::FoundDefault
            );
            assert_eq!(
                resolve_include_directive(&tree, &empty_tree(), &default_includes, &[], &include_3),
                ResolveIncludeResult::FoundDefault
            );

            // Not in default includes
            let include_missing = IncludeDirective::system("missing.h", "/project/file.c");
            assert_eq!(
                resolve_include_directive(
                    &tree,
                    &empty_tree(),
                    &default_includes,
                    &[],
                    &include_missing
                ),
                ResolveIncludeResult::NotFound
            );
        }

        #[test]
        fn test_current_folder_takes_priority() {
            let tree = create_tree(&["/system/include/foo.h", "/project/foo.h"]);

            let include_directive = IncludeDirective::local("foo.h", "/project/file.c");
            let include_dirs = vec![PathBuf::from("/system/include"), PathBuf::from("/project")];

            let result = resolve_include_directive(
                &tree,
                &empty_tree(),
                &HashSet::default(),
                &include_dirs,
                &include_directive,
            );
            assert_eq!(
                result,
                ResolveIncludeResult::Found(PathBuf::from("/project/foo.h"))
            );
        }
    }

    mod infer_include_path {
        use super::*;

        #[test]
        fn test_same_directory() {
            let tree = create_tree(&[
                "/project/include/foo.h",
                "/project/foo.h",
                "/project/include/bar.h",
            ]);
            let include_directive = IncludeDirective::system("foo.h", "/project/file.c");
            let result = infer_include_path(&tree, &include_directive);
            assert_eq!(result, Some(PathBuf::from("/project")));
        }

        #[test]
        fn test_parent_directory() {
            let tree = create_tree(&["/project/include/bar.h", "/foo.h"]);
            let include_directive = IncludeDirective::system("foo.h", "/project/file.c");
            let result = infer_include_path(&tree, &include_directive);
            assert_eq!(result, Some(PathBuf::from("/")));
        }

        #[test]
        fn test_prefer_child_directory() {
            // When the header file can be found one level above and one level below, then the one
            // below is picked. We prefer the option that requires the smallest amount of going up in
            // the hierarchy relative to the including file.
            let tree = create_tree(&["/project/include/foo.h", "/foo.h"]);
            let include_directive = IncludeDirective::system("foo.h", "/project/file.c");
            let result = infer_include_path(&tree, &include_directive);
            assert_eq!(result, Some(PathBuf::from("/project/include")));
        }

        #[test]
        fn test_multiple_at_same_distance() {
            let tree = create_tree(&["/project/include-b/foo.h", "/project/include-a/foo.h"]);
            let include_directive = IncludeDirective::system("foo.h", "/project/file.c");
            let result = infer_include_path(&tree, &include_directive);
            assert_eq!(result, Some(PathBuf::from("/project/include-a")));
        }

        #[test]
        fn test_header_file_not_present() {
            let tree = create_tree(&["/project/include/foo.h", "/project/include/bar.h"]);
            let include_directive = IncludeDirective::system("baz.h", "/project/file.c");
            let result = infer_include_path(&tree, &include_directive);
            assert_eq!(result, None);
        }
    }

    mod find_includes {
        use crate::project_definitions::IncludeKind;
        use std::slice;

        use super::*;

        #[test]
        fn test_simple_file_1() {
            let no_default_includes = HashSet::default();
            let path = get_resource("dir1");
            let tree = DirectoryTree::from_path(&path);

            let file = &path.join("file1.c");
            let includes = scan_for_includes(file);

            let result = find_includes(&tree, &empty_tree(), &no_default_includes, &includes);

            assert_eq!(
                result.include_directories,
                vec![path.clone(), path.clone().join("dir2")]
            );
            assert!(!result.unresolvable.is_empty());
            assert_eq!(
                result.unresolvable,
                vec![
                    IncludeDirective::system("missing_system.hpp", file),
                    IncludeDirective::local("missing_local.hpp", file),
                ]
            );
        }

        #[test]
        fn test_simple_file_3() {
            let no_default_includes = HashSet::default();
            let path = get_resource("dir1");
            let tree = DirectoryTree::from_path(&path);

            let file = &path.join("dir2/file3.cpp");
            let includes = scan_for_includes(file);

            let result = find_includes(&tree, &empty_tree(), &no_default_includes, &includes);

            assert_eq!(result.include_directories, vec![path.clone()]);
            assert_eq!(
                result.unresolvable,
                vec![
                    IncludeDirective::system("missing_5.hpp", file),
                    IncludeDirective::local("missing_4.hpp", file),
                ]
            );
        }

        #[test]
        fn test_simple_only_locals() {
            let no_default_includes = HashSet::default();
            // Local includes do not need any extra folder to be added if they can be resolved from the
            // containing file directory
            let path = get_resource("dir1");
            let tree = DirectoryTree::from_path(&path);

            let file = &path.join("only_locals.cpp");
            let includes = scan_for_includes(file);

            let result = find_includes(&tree, &empty_tree(), &no_default_includes, &includes);

            assert_true!(result.include_directories.is_empty());
            assert_true!(result.unresolvable.is_empty());
        }

        #[test]
        fn test_simple_only_relative_paths() {
            let no_default_includes = HashSet::default();
            // Relative includes are skipped
            let path = get_resource("dir1");
            let tree = DirectoryTree::from_path(&path);

            let file = &path.join("only_relative.cc");
            let includes = scan_for_includes(file);

            let result = find_includes(&tree, &empty_tree(), &no_default_includes, &includes);

            // Empty as all include directives containing relative paths are skipped
            assert_true!(result.include_directories.is_empty());
            assert_true!(result.unresolvable.is_empty());
        }

        #[test]
        fn test_simple_causing_recursion() {
            let no_default_includes = HashSet::default();
            let path = get_resource("recursion_in_headers");
            let tree = DirectoryTree::from_path(&path);

            let file = &path.join("file.c");
            let includes = scan_for_includes(file);

            let result = find_includes(&tree, &empty_tree(), &no_default_includes, &includes);

            let dir1 = path.join("dir1");
            let dir2 = dir1.join("dir2");
            let dir3 = dir2.join("dir3");

            assert_eq!(result.include_directories, vec![dir1, dir2, dir3]);
            assert_eq!(result.unresolvable, vec![]);
        }

        #[test]
        fn test_include_dirs_with_duplicates() {
            let no_default_includes = HashSet::default();
            let path = get_resource("path-choice");
            let tree = DirectoryTree::from_path(&path);

            let file = &path.join("dir1/main.c");
            let includes = scan_for_includes(file);

            let result = find_includes(&tree, &empty_tree(), &no_default_includes, &includes);

            assert_eq!(result.include_directories, vec![path.join("dir1")]);
            assert_true!(result.unresolvable.is_empty());
        }

        #[test]
        fn test_include_dirs_with_duplicates_2() {
            let no_default_includes = HashSet::default();
            let path = get_resource("path-choice");
            let tree = DirectoryTree::from_path(&path);

            let file = &path.join("dir2/main.c");
            let includes = scan_for_includes(file);

            let result = find_includes(&tree, &empty_tree(), &no_default_includes, &includes);

            assert_eq!(result.include_directories, vec![path.join("dir2")]);
            assert_true!(result.unresolvable.is_empty());
        }

        #[test]
        fn test_absolute_paths() {
            let no_default_includes = HashSet::default();
            let path = get_resource("absolute_paths_in_include");
            let tree = DirectoryTree::from_path(&path);

            let file = &path.join("file.c");
            let includes = scan_for_includes(file);

            let result = find_includes(&tree, &empty_tree(), &no_default_includes, &includes);

            assert_eq!(
                result.include_directories,
                vec![path.join("subdir"), path.clone()]
            );
            assert_eq!(
                result.unresolvable,
                vec![
                    IncludeDirective::system("non_existing_folder/non_existing_header.h", file),
                    IncludeDirective::system("subdir_for_windows/header_windows_specified.h", file),
                    IncludeDirective::system("non_existing_folder/non_existing_header.h", file),
                    IncludeDirective::system("non_existing_header.h", file),
                ]
            );
        }

        #[test]
        fn project_include_system() {
            let path = get_resource("project-include-system");

            let project_files = DirectoryTree::from_path(&path.join("project"));
            let system_files = DirectoryTree::from_path(&path.join("system"));
            let compiler_defaults = compute_include_files(&[path.join("system")]);

            let result = find_includes(
                &project_files,
                &system_files,
                &compiler_defaults,
                &[IncludeDirective {
                    containing_file: path.join("project/main.c"),
                    kind: IncludeKind::System,
                    path: "foo.h".into(),
                }],
            );

            // This is empty since `foo.h` is in `system_files` and hence satisfied by
            // `compiler_defaults`.
            assert!(result.include_directories.is_empty());
        }

        #[test]
        fn system_does_not_include_project() {
            let path = get_resource("project-include-system");

            let project_files = DirectoryTree::from_path(&path.join("project"));
            let system_files = DirectoryTree::from_path(&path.join("system"));
            let compiler_defaults = compute_include_files(&[path.join("system")]);
            let include_directive = IncludeDirective {
                containing_file: path.join("system/system.h"),
                kind: IncludeKind::System,
                path: "bar.h".into(),
            };
            let result = find_includes(
                &project_files,
                &system_files,
                &compiler_defaults,
                slice::from_ref(&include_directive),
            );

            let empty: Vec<PathBuf> = vec![];
            assert_eq!(result.include_directories, empty);
            assert_eq!(result.unresolvable, vec![include_directive]);
        }
    }
}

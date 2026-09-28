use super::project_definitions::IncludeDirective;
use cached::proc_macro::cached;
use regex::Regex;
use std::path::PathBuf;
use std::sync::LazyLock;

static SYSTEM_INCLUDE_RE: LazyLock<Regex> = LazyLock::new(|| {
    Regex::new(r#"^\s*#include\s+<([^">]+)>"#).expect("Failed to compile system include regex")
});
static LOCAL_INCLUDE_RE: LazyLock<Regex> = LazyLock::new(|| {
    Regex::new(r#"^\s*#include\s+"([^">]+)""#).expect("Failed to compile local include regex")
});

#[cached]
fn get_includes_cached(filename: PathBuf) -> Vec<IncludeDirective> {
    let Ok(file_content) = std::fs::read_to_string(&filename) else {
        // TODO: warn!("Error reading file {}: {}", filename, e);
        return Vec::new();
    };
    file_content
        .lines()
        .filter_map(|line| {
            // Replace backslashes with forward slashes so we can handle includes containing
            // Windows paths
            fn replace_backslashes(include_path: &str) -> PathBuf {
                PathBuf::from(include_path.replace('\\', "/"))
            }
            // Check whether line matches regexp for include statements
            // #include <(.*)>
            SYSTEM_INCLUDE_RE
                .captures(line)
                .map(|global_include| {
                    IncludeDirective::system(replace_backslashes(&global_include[1]), &filename)
                })
                .or(
                    // #include "(.*)"
                    LOCAL_INCLUDE_RE.captures(line).map(|local_include| {
                        IncludeDirective::local(replace_backslashes(&local_include[1]), &filename)
                    }),
                )
        })
        .collect()
}

/// Public wrapper around the cached implementation `get_includes_cached` to keep the
/// cached function non-public.
pub fn get_includes(filename: PathBuf) -> Vec<IncludeDirective> {
    get_includes_cached(filename)
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::test_utils::get_symlinked_resource;
    use all_asserts::assert_true;

    #[test]
    fn test_get_includes_works() {
        let file_name = get_symlinked_resource("dir1").join("file1.c");

        let expected = [
            IncludeDirective::local("file4.hpp", &file_name),
            IncludeDirective::system("dir2/file4.hpp", &file_name),
            IncludeDirective::local("missing_local.hpp", &file_name),
            IncludeDirective::system("missing_system.hpp", &file_name),
        ];

        let actual = get_includes(file_name.clone());

        assert_eq!(actual, expected);
    }

    #[test]
    fn test_get_includes_works_with_absolute_paths() {
        let file_name = get_symlinked_resource("absolute_paths_in_include").join("file.c");

        let expected = [
            IncludeDirective::system(r"a_header_in_same_dir.h", &file_name),
            IncludeDirective::system(r"a_header_in_subdir.h", &file_name),
            IncludeDirective::system(r"non_existing_header.h", &file_name),
            IncludeDirective::system(r"non_existing_folder/non_existing_header.h", &file_name),
            IncludeDirective::system(r"/non_existing_with_absolute_path.h", &file_name),
            IncludeDirective::system(r"/header_specified_through_absolute_path.h", &file_name),
            IncludeDirective::system(r"/", &file_name),
            IncludeDirective::system(r"subdir_for_windows/header_windows_specified.h", &file_name),
            IncludeDirective::system(r"non_existing_folder/non_existing_header.h", &file_name),
            IncludeDirective::system(r"/non_existing_with_absolute_path.h", &file_name),
            IncludeDirective::system(r"/header_specified_through_absolute_path.h", &file_name),
            IncludeDirective::system(r"/", &file_name),
            IncludeDirective::system(r"C:/non_existing_with_absolute_path.h", &file_name),
            IncludeDirective::system(r"C:/header_specified_through_absolute_path.h", &file_name),
            IncludeDirective::system(r"C:/", &file_name),
        ];

        let actual = get_includes(file_name.clone());

        assert_eq!(actual, expected);
        assert_true!(!actual.contains(&IncludeDirective::system(r"", &file_name)));
    }
}

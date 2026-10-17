//! File filtering functionality for the C++ BMN (Build Mode None) runner.
//!
//! The logic implemented here is based on the behavior of the JavaScript extractor in
//! `ql/javascript/extractor/src/com/semmle/js/extractor/AutoBuild.java` for what concerns the
//! `LGTM_INDEX_INCLUDE`, `LGTM_INDEX_EXCLUDE` and `LGTM_INDEX_FILTERS` environment variables and
//! their interpretation.
//! For the pattern matching the logic is based on the Java implementation in the `Rewrite` class in
//! `util-java7/src/com/semmle/util/projectstructure/ProjectLayout.java`.
//!
//! This module provides file filtering capabilities using three environment variables:
//! - `LGTM_INDEX_INCLUDE`: Specifies directories to include (default: current directory)
//! - `LGTM_INDEX_EXCLUDE`: Specifies directories to exclude
//! - `LGTM_INDEX_FILTERS`: Advanced glob-style patterns for include/exclude filtering
//!
//! ## Environment Variables
//!
//! ### `LGTM_INDEX_INCLUDE`
//! A newline-separated list of directory paths to include. If not specified, the root
//! directory is included by default. Paths are treated as relative to the root directory
//! even if they begin with '/'.
//!
//! ### `LGTM_INDEX_EXCLUDE`
//! A newline-separated list of directory paths to exclude. Works in combination with
//! include paths using specificity rules (more specific paths win).
//!
//! ### `LGTM_INDEX_FILTERS`
//! Advanced filtering using glob-style patterns. Each line should be in the format:
//! - `include: PATTERN` - Include files matching the pattern
//! - `exclude: PATTERN` - Exclude files matching the pattern
//!
//! Patterns support:
//! - `*` matches any characters except `/`
//! - `**` matches any characters including `/` (directory recursion)
//!
//! ## Examples
//!
//! ```bash
//! # Include only source directories
//! export LGTM_INDEX_INCLUDE="src
//! include"
//!
//! # Exclude build artifacts
//! export LGTM_INDEX_EXCLUDE="build
//! target
//! node_modules"
//!
//! # Advanced filtering: include C++ files but exclude test files
//! export LGTM_INDEX_FILTERS="include: /**/*.cpp
//! include: /**/*.h
//! exclude: /**/test/*"
//! ```

use crate::environment;
use anyhow::{Result, anyhow};
use regex::bytes::Regex;
use std::path::{Component, Path, PathBuf};
use std::sync::LazyLock;

/// Regex to validate star patterns. Matches invalid uses of `**`:
///
/// The intention is to allow the `**` wildcard when followed by a slash only.
/// The following should be invalid:
/// - `- a/***/b` (too many stars)
/// - `a/**` (`**` at the end should be omitted)
/// - `a/**b` (illegal)
/// - `a/b**` (illegal)
/// - `**` (the same as a singleton `/`)
///
static VERIFY_STARS_RE: LazyLock<regex::Regex> = LazyLock::new(|| {
    regex::Regex::new(".*(?:\\*\\*[^/].*|\\*\\*$|[^/]\\*\\*.*)").expect("Bad literal regex?")
});

type IncludeExcludeRule = PathBuf;

/// Convert a path to a relative path by stripping any leading root components.
///
/// This function removes leading `/` or `\` characters to ensure paths are treated as
/// relative to the root directory. This is necessary because paths in include/exclude
/// directives are always treated as relative to the root directory even if they start
/// with a leading slash.
///
/// # Arguments
/// * `path` - The path to relativize
///
/// # Returns
/// * `Ok(PathBuf)` - The relativized path
/// * `Err` - If the path starts with `..` or a drive prefix (Windows)
fn relativize_path(path: PathBuf) -> Result<PathBuf> {
    let components: Vec<Component> = path.components().collect();
    if components.is_empty() {
        Ok(path)
    } else {
        match components[0] {
            Component::Normal(_) | Component::CurDir => Ok(path),
            Component::RootDir => {
                let sliced = &components[1..];
                Ok(PathBuf::from_iter(sliced))
            }
            _ => Err(anyhow!(
                "Path cannot start with .. or the drive prefix: {path:?}"
            )),
        }
    }
}

/// Parse include/exclude directives from a string, making paths absolute with respect to the current directory.
fn parse_include_exclude_directives(
    directive_content: &str,
    current_dir: &Path,
) -> Result<Vec<IncludeExcludeRule>> {
    directive_content
        .lines()
        .map(str::trim)
        .filter(|line| !line.is_empty())
        .map(|line|
            // Paths are treated as being relative to the current directory even if they begin
            // with '/', so we remove all leading slashes so the IO libraries treat them as
            // relative paths
            relativize_path(PathBuf::from(line)).map(|pb| current_dir.join(pb)))
        .collect()
}

/// Parse `LGTM_INDEX_FILTERS` environment variable or provided filter string.
fn parse_index_filters(filters_str: &str) -> Result<Vec<FilterRule>> {
    let rules: Vec<Result<FilterRule>> = filters_str
        .lines()
        .map(str::trim)
        .filter(|line| !line.is_empty())
        .map(FilterRule::from_line)
        .collect();

    if rules.iter().any(std::result::Result::is_err) {
        return Err(anyhow::anyhow!("Invalid filter in LGTM_INDEX_FILTERS"));
    }

    Ok(rules
        .iter()
        .filter_map(|rule| rule.as_ref().ok())
        .cloned()
        .collect())
}

/// Pattern represents a glob-style pattern that can be translated to regex for matching paths.
///
/// The following invariants are checked when creating a Pattern:
///
/// - There are no occurrences of '**' that is not surrounded by slashes (unless it is at the start
///   of a pattern).
/// - There is at most one double slash.
///
/// The pattern construction guarantees the following:
/// - The pattern starts with a '/' (if it does not start with a '/', one is prepended).
///
/// The result of the translation has precisely one capture group.
///
/// It proceeds by starting the capture group either after the double slash or at the start of
/// the pattern, and then replacing '*' with '[^/]*' (meaning any number of non-slash characters)
/// and '/**' with '(?:|/.*)' (meaning empty string or a slash followed by any number of
/// characters including '/').
///
/// The pattern is terminated by the term '(?:/.*|$)', saying 'either the next character is a
/// '/' or the string ends' -- this avoids accidental matching of partial directory/file names.
#[derive(Debug, Clone)]
struct Pattern {
    regex: Regex,
}
impl Pattern {
    /// Create a new Pattern from a glob-style pattern string
    fn new(pattern: &str) -> Result<Self> {
        let regex = Self::translate_to_regex(pattern)?;

        Ok(Pattern { regex })
    }

    /// Check if this pattern matches the given path
    fn matches(&self, path: &Path) -> bool {
        self.regex.is_match(path.as_os_str().as_encoded_bytes())
    }

    /// Escape special regex characters in a pattern, preserving certain characters for later
    fn escape_for_regex(pattern: &str) -> String {
        let mut escaped_pattern = String::new();
        for c in pattern.chars() {
            match c {
                c if "(){}[].^$+|\\?".contains(c) => {
                    escaped_pattern.push('\\');
                    escaped_pattern.push(c);
                }
                c => escaped_pattern.push(c),
            }
        }
        escaped_pattern
    }

    /// Translate a glob-style pattern to regex following the specific rules
    /// Based on the Java implementation
    fn translate_to_regex(pattern: &str) -> Result<Regex> {
        // The pattern is not valid. If it is not valid, return an error
        Self::is_valid_pattern(pattern)?;

        let pattern = if pattern.starts_with('/') {
            pattern.to_string()
        } else {
            format!("/{pattern}")
        };

        let escaped_pattern = Self::escape_for_regex(&pattern);

        // Handle double slash and start capture group
        let pattern_with_capture = if escaped_pattern.contains("//") {
            escaped_pattern.replace("//", "(/")
        } else {
            format!("({escaped_pattern}")
        };

        // Remove trailing slash if present
        let mut final_pattern = pattern_with_capture;
        if final_pattern.ends_with('/') {
            final_pattern.pop();
        }

        // Replace patterns: first replace /** with placeholder, then *, then restore /**
        // As we check that there are no triple-/ in the path we can use the -///- placeholder
        final_pattern = final_pattern
            .replace("/**", "-///-")
            .replace('*', "[^/]*")
            .replace("-///-", "(?:|/.*)");

        // Terminate the pattern
        final_pattern += "(?:/.*|$))";

        // Replace / with a regex that matches both / and \ on Windows
        #[cfg(windows)]
        {
            let windows_path_sep_regex = r"(?:/|\\)";
            final_pattern = final_pattern.replace("/", windows_path_sep_regex);
        }

        Ok(Regex::new(&final_pattern)?)
    }

    /// Validate pattern according to the invariants - checking for illegal patterns only
    fn is_valid_pattern(pattern: &str) -> Result<()> {
        if VERIFY_STARS_RE.is_match(pattern) {
            return Err(anyhow::anyhow!("Illegal use of '**' in include path"));
        }

        if let Some(first) = pattern.find("//") {
            // There is a double slash, check that there is not another one, and that it's not a
            // triple slash
            if pattern[first + 1..].contains("//") {
                return Err(anyhow::anyhow!("More than one '//' in include path"));
            }
        }

        Ok(())
    }
}

/// `FilterRule` represents a single include or exclude filter with a pattern
#[derive(Debug, Clone)]
enum FilterRule {
    Include(Pattern),
    Exclude(Pattern),
}

impl FilterRule {
    pub fn matches(&self, path: &Path) -> bool {
        match self {
            FilterRule::Exclude(pattern) | FilterRule::Include(pattern) => pattern.matches(path),
        }
    }

    /// Parse a single filter line (either "include: PATTERN" or "exclude: PATTERN")
    fn from_line(line: &str) -> Result<Self> {
        if let Some(pattern_str) = line.strip_prefix("include:") {
            let pattern_str = pattern_str.trim();
            let pattern = Pattern::new(pattern_str)?;
            Ok(FilterRule::Include(pattern))
        } else if let Some(pattern_str) = line.strip_prefix("exclude:") {
            let pattern_str = pattern_str.trim();
            let pattern = Pattern::new(pattern_str)?;
            Ok(FilterRule::Exclude(pattern))
        } else {
            Err(anyhow::anyhow!("Invalid filter line {line}"))
        }
    }

    pub fn is_include(&self) -> bool {
        matches!(self, FilterRule::Include(_))
    }
}
#[derive(Debug)]
pub struct FileFilter {
    include_paths: Vec<IncludeExcludeRule>,
    exclude_paths: Vec<IncludeExcludeRule>,
    index_filters: Vec<FilterRule>,
    root_directory: PathBuf,
}

impl FileFilter {
    /// Creates a new `FileFilter` instance for the given root directory and the include/exclude paths
    fn new(
        root_directory: &Path,
        include_paths: &str,
        exclude_paths: &str,
        index_filter_patterns: &str,
    ) -> Result<Self> {
        let mut include_paths: Vec<IncludeExcludeRule> =
            parse_include_exclude_directives(include_paths, root_directory)?;
        let exclude_paths: Vec<IncludeExcludeRule> =
            parse_include_exclude_directives(exclude_paths, root_directory)?;

        // If no include paths are specified add the root directory as by default everything is
        // included.
        // We do this as:
        //    This list (the include list) replaces (rather than extends) the default include
        //    path which otherwise is defaulted to be the current directory
        if include_paths.is_empty() {
            include_paths.push(root_directory.to_path_buf());
        }

        let mut index_filters = parse_index_filters(index_filter_patterns)?;

        let include_filter_count = index_filters.iter().filter(|f| f.is_include()).count();

        let wildcard = Pattern::new("**/*").expect("Bad pattern");

        // The behaviour of the following default is taken from the behaviour of the tree-sitter
        // extractor implementation.
        if include_filter_count == 0 {
            // No include, everything not excluded should be accepted, so add an include all filter
            // at the beginning to include everything else
            index_filters.insert(0, FilterRule::Include(wildcard.clone()));
        } else {
            // If only include filters are specified, add an exclude all filter at the beginning to
            // exclude everything else
            index_filters.insert(0, FilterRule::Exclude(wildcard.clone()));
        }

        Ok(FileFilter {
            include_paths,
            exclude_paths,
            index_filters,
            root_directory: root_directory.to_path_buf(),
        })
    }

    /// Creates a new `FileFilter` instance using environment variables for include/exclude paths
    /// and the given root directory using the `LGTM_INDEX_INCLUDE` and `LGTM_INDEX_EXCLUDE` environment
    /// variables.
    pub fn from_env_vars(root_directory: &Path) -> Result<Self> {
        let include_paths =
            environment::get_optional(environment::LGTM_INDEX_INCLUDE).unwrap_or_default();
        let exclude_paths =
            environment::get_optional(environment::LGTM_INDEX_EXCLUDE).unwrap_or_default();
        let index_filters_patterns =
            environment::get_optional(environment::LGTM_INDEX_FILTERS).unwrap_or_default();
        Self::new(
            root_directory,
            &include_paths,
            &exclude_paths,
            &index_filters_patterns,
        )
    }

    /// Determines if a given absolute path should be included based on the configured filters
    pub fn accepts(&self, path: &Path) -> bool {
        assert!(
            path.is_absolute(),
            "Path must be absolute: {}",
            path.display()
        );
        // Apply "simple" include/exclude logic first (before advanced filtering)
        if !self.include_and_exclude_accepts(path) {
            return false;
        }

        self.index_filter_accepts(path)
    }

    /// Simple include/exclude logic for `LGTM_INDEX_INCLUDE` and `LGTM_INDEX_EXCLUDE`
    fn include_and_exclude_accepts(&self, absolute_path: &Path) -> bool {
        let include_rule = Self::get_best_matching_rule(absolute_path, &self.include_paths);
        let exclude_rule = Self::get_best_matching_rule(absolute_path, &self.exclude_paths);

        match (include_rule, exclude_rule) {
            (Some(include_rule), Some(exclude_rule)) => {
                // The conflicting case: both an include and an exclude match, and we need to decide
                // which one to follow

                // If the include rule is equally or more specific (>= path), we include the file
                include_rule.components().count() >= exclude_rule.components().count()
            }
            (Some(_), None) => {
                // If an include rule and no exclude rule match, we include the file
                true
            }
            _ => {
                // Only an exclude and no include rule match, or either rule matches.
                // If only an exclude rule matches, we exclude the file
                // If neither rule matches, we exclude the path as it is not in an include path or
                // outside the root directory (which is added if no include paths are specified)
                false
            }
        }
    }

    /// Check if an absolute path matches a rule from a vector.
    /// If it is return the most specific rule, None otherwise.
    fn get_best_matching_rule<'a>(
        absolute_path: &Path,
        rules: &'a [IncludeExcludeRule],
    ) -> Option<&'a IncludeExcludeRule> {
        rules
            .iter()
            .filter(|filter_path| absolute_path.starts_with(filter_path))
            .max_by_key(|p| p.components().count())
    }

    /// Determines whether the given path should be included or excluded based on the
    /// advanced filtering logic defined by the `LGTM_INDEX_FILTERS` environment variable.
    ///
    /// The function iterates over the list of filter rules in reverse order, so that later
    /// filters take precedence over earlier ones (i.e., the last matching filter wins).
    /// If a matching rule is found, the function returns `true` for an include rule and
    /// `false` for an exclude rule.
    /// If no matching rule is found, the function panics, as a default rule should always be
    /// present.
    fn index_filter_accepts(&self, absolute_path: &Path) -> bool {
        // To avoid matching the regex against the full absolute path, we strip the root directory
        if let Ok(relative_path) = absolute_path.strip_prefix(&self.root_directory) {
            // Paths should start with a leading forward-slash
            let path_to_match = PathBuf::from("/").join(relative_path);

            // As the later filters take precedence, we iterate the filters in reverse order
            let matching_rule = self
                .index_filters
                .iter()
                .rev()
                .find(|rule| rule.matches(&path_to_match));

            match matching_rule {
                Some(FilterRule::Include(_)) => true,
                Some(FilterRule::Exclude(_)) => false,
                None => {
                    // We added the default behaviour when creating the filter, so this should never
                    // happen
                    panic!("Invalid index filter")
                }
            }
        } else {
            false
        }
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use all_asserts::{assert_false, assert_true};
    use std::path::PathBuf;

    // Using the current directory as root for tests to avoid issues with absolute paths on Windows
    fn get_cwd() -> PathBuf {
        let maybe_cwd = std::env::current_dir();
        assert_true!(maybe_cwd.is_ok());

        let cwd = maybe_cwd.expect("Can't get current directory");
        assert_true!(cwd.is_absolute());

        cwd
    }

    #[test]
    fn test_file_filter_creation() {
        let root = get_cwd();
        let filter = FileFilter::new(&root, "", "", "").expect("Bad file filter");
        assert_eq!(root, filter.root_directory);
    }

    #[test]
    fn test_file_filter_panics_with_relative_path() {
        let filter = FileFilter::new(&get_cwd(), "", "", "").expect("Bad file filter");
        let result = std::panic::catch_unwind(|| {
            filter.accepts(&PathBuf::from("relative/path.c"));
        });
        assert!(result.is_err());
    }

    #[test]
    fn test_file_filter_makes_include_exclude_paths_absolute_wrt_root() {
        let root = get_cwd();
        let filter_string = "relative/include\n/absolute/include\n./same/dir/include";
        let filter =
            FileFilter::new(&root, filter_string, filter_string, "").expect("Bad file filter");

        let expected_paths: Vec<PathBuf> = vec![
            root.join("relative/include"),
            root.join("absolute/include"),
            root.join("same/dir/include"),
        ];

        assert_eq!(filter.include_paths, expected_paths);
        assert_eq!(filter.exclude_paths, expected_paths);
    }

    #[cfg(target_os = "windows")]
    #[test]
    fn test_file_filter_windows_specific() {
        let root = get_cwd();

        let result = FileFilter::new(&root, r"C:\a\dir", "", "");

        assert_true!(result.is_err());
        let error_message = format!("{}", result.unwrap_err());
        assert_true!(error_message.contains("Path cannot start with .. or the drive prefix"));
    }

    #[test]
    fn test_file_filter_rejects_parent_include_exclude_paths() {
        let root = get_cwd();

        let result = FileFilter::new(&root, "../outside/include", "", "");

        assert!(result.is_err());
        let error_message = format!("{}", result.unwrap_err());
        assert_true!(error_message.contains("Path cannot start with .. or the drive prefix"));
    }

    #[test]
    fn test_file_filter_is_valid_with_default() {
        let root = get_cwd();
        let filter = FileFilter::new(&root, "", "", "").expect("Bad file filter");

        // Path inside the root directory should be valid
        assert_true!(filter.accepts(&root.join("test.c")));
        assert_true!(filter.accepts(&root.join("another/test.h")));

        // Path outside root directory should be invalid
        let parent = root.parent().expect("CWD has no parent");
        assert_false!(filter.accepts(&parent.join("other/path/test.cpp")));
    }

    #[test]
    fn test_file_filter_with_include_paths() {
        let root = get_cwd();
        let filter = FileFilter::new(&root, "src\ninclude", "", "").expect("Bad file filter");

        // Files under included paths should be valid
        assert_true!(filter.accepts(&root.join("src/test.c")));
        assert_true!(filter.accepts(&root.join("include/header.h")));
        assert_true!(filter.accepts(&root.join("src/subdir/main.cpp")));

        // Files outside included paths should be invalid
        assert_false!(filter.accepts(&root.join("docs/readme.txt")));
        assert_false!(filter.accepts(&root.join("build/output.o")));
    }

    #[test]
    fn test_file_filter_include_paths_with_whitespace() {
        let root = get_cwd();
        let filter =
            FileFilter::new(&root, " src \n  include  \n\n", "", "").expect("Bad file filter");

        assert_true!(filter.accepts(&root.join("src/test.c")));
        assert_true!(filter.accepts(&root.join("include/header.h")));
        assert_false!(filter.accepts(&root.join("docs/readme.txt")));
    }

    #[test]
    fn test_file_filter_with_exclude_paths() {
        let root = get_cwd();
        let filter =
            FileFilter::new(&root, "", "build\nnode_modules", "").expect("Bad file filter");

        // Files under excluded paths should be invalid
        assert_false!(filter.accepts(&root.join("build/output.o")));
        assert_false!(filter.accepts(&root.join("node_modules/package.json")));
        assert_false!(filter.accepts(&root.join("build/subdir/file.txt")));

        // Files outside excluded paths should be valid
        assert_true!(filter.accepts(&root.join("src/test.c")));
        assert_true!(filter.accepts(&root.join("include/header.h")));

        // Files outside root directory should be invalid
        let parent = root.parent().expect("CWD has no parent");
        assert_false!(filter.accepts(&parent.join("other/include/header.h")));
    }

    #[test]
    fn test_file_filter_exclude_with_whitespace() {
        let root_dir = get_cwd();
        let filter = FileFilter::new(&root_dir, "", " build \n  node_modules  \n\n", "")
            .expect("Bad file filter");

        assert_false!(filter.accepts(&root_dir.join("build/output.o")));
        assert_true!(filter.accepts(&root_dir.join("src/test.c")));
    }

    #[test]
    fn test_file_filter_include_exclude_precedence() {
        let root = get_cwd();
        let filter = FileFilter::new(
            &root,
            "src\nbuild/important\nother",
            "build\nsrc/ignored\nother",
            "",
        )
        .expect("Bad file filter");

        // Files in build should be excluded
        assert_false!(filter.accepts(&root.join("build/output.o")));

        // But files in build/important should be included (more specific)
        assert_true!(filter.accepts(&root.join("build/important/file.c")));

        // Files in src should be included
        assert_true!(filter.accepts(&root.join("src/test.c")));

        // But files in src/ignored should be excluded (more specific)
        assert_false!(filter.accepts(&root.join("src/ignored/file.c")));

        // Files in other should be included as include and exclude are equally specific and include
        // wins
        assert_true!(filter.accepts(&root.join("other/another.txt")));

        // Files outside both should be excluded (include paths specified)
        assert_false!(filter.accepts(&root.join("docs/readme.txt")));
    }

    #[test]
    fn test_file_filter_include_exclude_equals() {
        let root = get_cwd();
        let filter = FileFilter::new(&root, "build", "build", "").expect("Bad file filter");

        // Files in build should be included as when equally specific include wins
        assert_true!(filter.accepts(&root.join("build/output.o")));

        // Files in outside build should be excluded (include paths specified)
        assert_false!(filter.accepts(&root.join("src/test.c")));
    }

    #[test]
    fn test_is_valid_pattern_valid_cases() {
        // Valid patterns
        assert_true!(Pattern::is_valid_pattern("/src/*").is_ok());
        assert_true!(Pattern::is_valid_pattern("/**/main.c").is_ok());
        assert_true!(Pattern::is_valid_pattern("/foo/*/main.c").is_ok());
        assert_true!(Pattern::is_valid_pattern("/foo/**/main.c").is_ok());
        assert_true!(Pattern::is_valid_pattern("/foo/b*r/main.c").is_ok());
        assert_true!(Pattern::is_valid_pattern("/foo//bar").is_ok());
        assert_true!(Pattern::is_valid_pattern("/foo/bar").is_ok());
    }

    #[test]
    fn test_is_valid_pattern_invalid_double_star_usage() {
        // Invalid: '**' at the end
        assert_true!(Pattern::is_valid_pattern("/foo/**").is_err());
        // Invalid: '**' not surrounded by slashes
        assert_true!(Pattern::is_valid_pattern("/foo/**bar").is_err());
        // Invalid: '**' not surrounded by slashes
        assert_true!(Pattern::is_valid_pattern("/foo/bar**/baz").is_err());
        // Invalid: '**' in the middle of a segment
        assert_true!(Pattern::is_valid_pattern("/foo/b**ar").is_err());
        // Invalid: '***' in the middle of a segment
        assert_true!(Pattern::is_valid_pattern("/src/***/*.c").is_err());
        // Invalid: more than one double slash
        assert_true!(Pattern::is_valid_pattern("/foo//bar//baz").is_err());
    }

    #[test]
    fn test_escape_for_regex_preserves_specified_chars() {
        // '*' should not be escaped if preserved
        let pattern = "foo*bar.baz";
        let escaped = Pattern::escape_for_regex(pattern);
        assert_eq!(escaped, "foo*bar\\.baz");

        // No preserved chars, all special regex chars escaped
        let pattern = "a(b)c{d}e[f]g.h^i$j+k\\l?m|n";
        let escaped = Pattern::escape_for_regex(pattern);
        assert_eq!(
            escaped,
            "a\\(b\\)c\\{d\\}e\\[f\\]g\\.h\\^i\\$j\\+k\\\\l\\?m\\|n"
        );
    }

    #[test]
    fn test_pattern_new() {
        // Simple pattern
        let pattern = Pattern::new("/src/*").expect("Bad regex");
        assert_true!(pattern.matches(&PathBuf::from("/src/main.c")));

        // Pattern with double star
        let pattern = Pattern::new("/**/main.c").expect("Bad regex");
        assert_true!(pattern.matches(&PathBuf::from("/foo/bar/main.c")));
        assert_true!(pattern.matches(&PathBuf::from("/main.c")));

        // Pattern with double slash
        let pattern = Pattern::new("/foo//bar").expect("Bad regex");
        assert_true!(pattern.matches(&PathBuf::from("/foo/bar/baz.c")));
    }

    #[test]
    fn test_translate_to_regex_invalid_patterns() {
        // Invalid: '**' at the end
        assert_true!(Pattern::translate_to_regex("/foo/**").is_err());
        // Invalid: more than one double slash
        assert_true!(Pattern::translate_to_regex("/foo//bar//baz").is_err());
        // Invalid: '**' not surrounded by slashes
        assert_true!(Pattern::translate_to_regex("/foo/**bar").is_err());
    }

    ///////////////////// PATTERN TESTS /////////////////////

    #[test]
    fn test_pattern_basic() {
        let pattern = Pattern::new("/src/*.c").expect("Bad pattern?");
        assert_true!(pattern.matches(&PathBuf::from("/src/test.c")));
        assert_true!(pattern.matches(&PathBuf::from("/src/main.c")));
        assert_true!(!pattern.matches(&PathBuf::from("/src/test.h")));
        assert_true!(!pattern.matches(&PathBuf::from("/include/test.c")));

        // Only paths starting with "/" should match
        assert_false!(pattern.matches(&PathBuf::from("src/test.h")));
    }

    #[test]
    fn test_pattern_double_star() {
        let pattern = Pattern::new("/src/**/*.c").expect("Bad pattern?");
        assert_true!(pattern.matches(&PathBuf::from("/src/test.c")));
        assert_true!(pattern.matches(&PathBuf::from("/src/subdir/test.c")));
        assert_true!(pattern.matches(&PathBuf::from("/src/deep/nested/dir/test.c")));
        assert_false!(pattern.matches(&PathBuf::from("/src/test.h")));
        assert_false!(pattern.matches(&PathBuf::from("/include/test.c")));

        // Only paths starting with "/" should match
        assert_false!(pattern.matches(&PathBuf::from("src/subdir/test.c")));
    }

    #[test]
    fn test_pattern_double_star_prefix() {
        let pattern = Pattern::new("/**/test.c").expect("Bad pattern?");
        assert_true!(pattern.matches(&PathBuf::from("/test.c")));
        assert_true!(pattern.matches(&PathBuf::from("/src/test.c")));
        assert_true!(pattern.matches(&PathBuf::from("/deep/nested/test.c")));
        assert_false!(pattern.matches(&PathBuf::from("/test.h")));

        // Only paths starting with "/" should match
        assert_false!(pattern.matches(&PathBuf::from("test.c")));
    }

    #[test]
    fn test_pattern_regex_escaping() {
        let pattern = Pattern::new("/test[].c").expect("Bad pattern?");
        assert_true!(pattern.matches(&PathBuf::from("/test[].c")));
        assert_false!(pattern.matches(&PathBuf::from("/testa.c"))); // [] should be literal, not regex class
    }

    #[test]
    fn test_pattern_terminating_match() {
        let pattern = Pattern::new("/src").expect("Bad pattern?");
        assert_true!(pattern.matches(&PathBuf::from("/src")));
        assert_true!(pattern.matches(&PathBuf::from("/src/file.c")));
        assert_false!(pattern.matches(&PathBuf::from("/src_backup"))); // Should not match partial names
    }

    #[test]
    fn test_filters_include_only() {
        let root = get_cwd();
        let filter_res = FileFilter::new(&root, "", "", "include:/src/*.c\ninclude:/include/*.h");

        assert_true!(filter_res.is_ok());
        let filter = filter_res.expect("Bad file filter");

        // Only files matching include patterns should be valid
        assert_true!(filter.accepts(&root.join("src/test.c")));
        assert_true!(filter.accepts(&root.join("include/header.h")));

        // Other files should be invalid
        assert_false!(filter.accepts(&root.join("src/test.h")));
        assert_false!(filter.accepts(&root.join("docs/readme.txt")));
    }

    #[test]
    fn test_filters_exclude_only() {
        let root = get_cwd();
        let filter_res =
            FileFilter::new(&root, "", "", "exclude:/build/*\nexclude:/**/node_modules");

        assert_true!(filter_res.is_ok());
        let filter = filter_res.expect("Bad file filter");

        // Files matching exclude patterns should be invalid
        assert_false!(filter.accepts(&root.join("build/output.o")));
        assert_false!(filter.accepts(&root.join("node_modules/package.json")));
        assert_false!(filter.accepts(&root.join("src/node_modules/lib.js")));

        // Other files should be valid
        assert!(filter.accepts(&root.join("src/test.c")));
        assert!(filter.accepts(&root.join("include/header.h")));
    }

    #[test]
    fn test_filters_priority_order() {
        let root = get_cwd();
        let filter_res = FileFilter::new(
            &root,
            "",
            "",
            "include:/src/*\nexclude:/src/*.o\ninclude:/src/important.o",
        );

        assert_true!(filter_res.is_ok());
        let filter = filter_res.expect("Bad file filter");

        // First rule: include /src/*
        assert_true!(filter.accepts(&root.join("src/test.c")));

        // Second rule overrides: exclude /src/*.o
        assert_false!(filter.accepts(&root.join("src/output.o")));

        // Third rule overrides again: include /src/important.o
        assert_true!(filter.accepts(&root.join("src/important.o")));

        // Files outside /src are not valid
        assert_false!(filter.accepts(&root.join("include/header.h")));
    }

    #[test]
    fn test_filters_mixed_include_exclude() {
        let root = get_cwd();
        let filter_res = FileFilter::new(&root, "", "", "include:/src/*\nexclude:/src/test/*");

        assert_true!(filter_res.is_ok());
        let filter = filter_res.expect("Bad file filter");

        // Include src files
        assert_true!(filter.accepts(&root.join("src/main.c")));

        // But exclude test files (later rule takes precedence)
        assert_false!(filter.accepts(&root.join("src/test/unit.c")));

        // Files outside src should be excluded (since we have includes)
        assert_false!(filter.accepts(&root.join("docs/readme.txt")));
    }

    #[test]
    fn test_filters_invalid_syntax() {
        let root = get_cwd();
        let filter = FileFilter::new(
            &root,
            "",
            "",
            "include:/src/*\ninvalid_line\nexclude:/build/*",
        );

        assert_true!(filter.is_err());
    }

    #[test]
    fn test_integration_with_source_directory() {
        use crate::project_definitions::SourceDirectory;
        use std::fs;
        use tempfile::TempDir;

        // Create a temporary directory structure
        let temp_dir = TempDir::new().expect("Can't create temporary directory");
        let root_path = temp_dir.path();

        // Create directory structure and files
        fs::create_dir_all(root_path.join("src")).expect("Can't create source directory");
        fs::create_dir_all(root_path.join("build")).expect("Can't create build directory");
        fs::create_dir_all(root_path.join("build/autogen")).expect("Can't create build directory");
        fs::create_dir_all(root_path.join("include")).expect("Can't create include directory");

        fs::write(root_path.join("src/main.c"), "int main() { return 0; }")
            .expect("Can't write file");
        fs::write(root_path.join("src/utils.cpp"), "void utils() {}").expect("Can't write file");
        fs::write(root_path.join("src/file-to-exclude.cpp"), "void utils() {}")
            .expect("Can't write file");
        fs::write(root_path.join("include/header.h"), "#pragma once").expect("Can't write file");
        fs::write(root_path.join("build/output.o"), "binary data").expect("Can't write file");
        fs::write(root_path.join("build/autogen/parser.cpp"), "binary data")
            .expect("Can't write file");
        fs::write(root_path.join("README.md"), "# Project").expect("Can't write file");

        // Test without any filters - should include all files
        {
            let empty_filter: FileFilter =
                FileFilter::new(root_path, "", "", "").expect("Bad file filter");
            let source_dir = SourceDirectory::new(root_path, Some(&empty_filter));
            let (all_files, source_files, header_files) = source_dir.get_stats();
            assert_true!(all_files >= 5); // Should include all created files
            assert_eq!(source_files, 4); // all files
            assert_eq!(header_files, 1); // header.h
        }
        // This test demonstrates integration
        {
            let working_filter = FileFilter::new(
                root_path,
                "src\nbuild/autogen",
                "src/file-to-exclude.cpp\nbuild",
                "",
            )
            .expect("Bad file filter");
            let source_dir_filtered = SourceDirectory::new(root_path, Some(&working_filter));
            let (all_files, source_files, header_files) = source_dir_filtered.get_stats();
            assert_true!(all_files >= 5); // Should include all created files
            assert_eq!(source_files, 3); // main.c and utils.cpp
            assert_eq!(header_files, 1); // header.h}
        }
    }
}

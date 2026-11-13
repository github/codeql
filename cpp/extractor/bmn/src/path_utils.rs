use os_str_bytes::{OsStrBytes, OsStrBytesExt};
use regex::bytes::Regex;
use std::ffi::{OsStr, OsString};
use std::path::{Path, PathBuf};
use std::sync::LazyLock;

static WINDOWS_PREFIX_RE: LazyLock<Regex> =
    LazyLock::new(|| Regex::new("^[a-zA-Z]:(.*)").expect("Bad regex."));

/// Compute the distance between two paths in terms of number of components to leave and to enter.
pub fn path_distances(from: &Path, to: &Path) -> (usize, usize) {
    let from_components = from.components();
    let to_components = to.components();

    let from_length = from.components().count();
    let to_length = to.components().count();

    let common_path_len = from_components
        .zip(to_components)
        .take_while(|(a, b)| a == b)
        .count();

    let leave_count = from_length - common_path_len;
    let enter_count = to_length - common_path_len;

    (leave_count, enter_count)
}

/// Strip the suffix from path `path` if it ends with `suffix`, returning the remaining prefix.
/// Returns `None` if `path` does not end with `suffix`.
pub fn strip_suffix(path: &Path, suffix: &Path) -> Option<PathBuf> {
    let mut x = path.components().rev();
    let mut y = suffix.components().rev();
    loop {
        let rev_result = x.clone();
        match (x.next(), y.next()) {
            (Some(a), Some(b)) if a == b => (),
            (Some(_) | None, Some(_)) => return None,
            (_, None) => return Some(rev_result.rev().collect::<PathBuf>()),
        }
    }
}

/// Check if the path is absolute.
pub fn is_absolute(path: &Path) -> bool {
    fn sanitize_path(path: &OsStr) -> OsString {
        WINDOWS_PREFIX_RE
            .captures(path.as_encoded_bytes())
            .and_then(|caps| caps.get(1))
            .and_then(|m| OsStr::from_io_bytes(m.as_bytes()))
            .unwrap_or(path)
            .to_owned()
    }

    let sanitised_path = sanitize_path(path.as_os_str());

    sanitised_path.starts_with("/") || sanitised_path.starts_with("\\")
}

#[cfg(test)]
mod tests {
    use super::{is_absolute, path_distances, strip_suffix};
    use all_asserts::{assert_false, assert_true};
    use std::path::{Path, PathBuf};

    #[test]
    fn test_strip_suffix_exact_match() {
        let include_directive_content = Path::new("bar/baz.h");
        let include_file_path = Path::new("/foo/bar/baz.h");
        let result = strip_suffix(include_file_path, include_directive_content);
        assert_eq!(result, Some(PathBuf::from("/foo")));
    }

    #[test]
    fn test_strip_suffix_no_match() {
        let include_directive_content = Path::new("baz/bar.h");
        let include_file_path = Path::new("/foo/bar/baz.h");
        let result = strip_suffix(include_file_path, include_directive_content);
        assert_eq!(result, None);
    }

    #[test]
    fn test_strip_suffix_suffix_longer_than_path() {
        let include_directive_content = Path::new("foo/bar/baz.h");
        let include_file_path = Path::new("baz.h");
        let result = strip_suffix(include_file_path, include_directive_content);
        assert_eq!(result, None);
    }

    #[test]
    fn test_strip_suffix_suffix_is_file_name() {
        let include_directive_content = Path::new("baz.h");
        let include_file_path = Path::new("/foo/bar/baz.h");
        let result = strip_suffix(include_file_path, include_directive_content);
        assert_eq!(result, Some(PathBuf::from("/foo/bar")));
    }

    #[test]
    fn test_path_distance_same_path() {
        let from = Path::new("/foo/bar/baz");
        let to = Path::new("/foo/bar/baz");
        assert_eq!(path_distances(from, to), (0, 0));
    }

    #[test]
    fn test_path_distance_subdir() {
        let from = Path::new("/foo/bar");
        let to = Path::new("/foo/bar/baz/qux");
        // leave_count = 0, enter_count = 2
        assert_eq!(path_distances(from, to), (0, 2));
    }

    #[test]
    fn test_path_distance_parent_dir() {
        let from = Path::new("/foo/bar/baz/qux");
        let to = Path::new("/foo/bar");
        // leave_count = 2, enter_count = 0
        assert_eq!(path_distances(from, to), (2, 0));
    }

    #[test]
    fn test_path_distance_different_roots() {
        let from = Path::new("/foo/bar");
        let to = Path::new("/baz/qux");
        // common_path_len = 1 ("/"), leave_count = 2, enter_count = 2
        assert_eq!(path_distances(from, to), (2, 2));
    }

    #[test]
    fn test_is_absolute_unix_paths() {
        assert_true!(is_absolute(Path::new("/usr/include")));
        assert_true!(is_absolute(Path::new("/")));
        assert_false!(is_absolute(Path::new("relative/path")));
        assert_false!(is_absolute(Path::new("file.h")));
        assert_false!(is_absolute(Path::new("../file.h")));
    }

    #[test]
    fn test_is_absolute_windows_paths() {
        assert_true!(is_absolute(Path::new("C:/Windows/System32")));
        assert_true!(is_absolute(Path::new("D:\\")));
        assert_false!(is_absolute(Path::new("E:Windows\\System32")));
        assert_false!(is_absolute(Path::new("Windows\\System32")));
        assert_false!(is_absolute(Path::new("file.h")));
        assert_true!(is_absolute(Path::new(r"\\?\C:\Folder\File.txt")));
    }
}

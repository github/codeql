use all_asserts::assert_true;
use std::fs::File;
use std::path::PathBuf;
use std::{env, fs};
use tempfile::{tempdir, TempDir};

/// This function tries to get the root test resource path.
/// If `allow_symlinks` is `false` will avoid the bazel off-tree test directory as this contains
/// symlinks instead of the files, and we will return the folder containing the canonicalized
/// `Cargo.toml` file.
fn get_in_tree_resource_root(allow_symlinks: bool) -> PathBuf {
    // The below ensures that we support both `bazel test` and `cargo test`.
    let manifest_path = if let Ok(runfiles_manifest) = env::var("BMN_TEST_MANIFEST") {
        let runfiles_dir = env::var("TEST_SRCDIR").expect("$TEST_SRCDIR not set");
        PathBuf::from(runfiles_dir).join(runfiles_manifest)
    } else {
        env::var("CARGO_MANIFEST_DIR")
            .map(PathBuf::from)
            .expect("$CARGO_MANIFEST_DIR not set")
            .join("Cargo.toml")
    };

    let final_manifest_path = if !allow_symlinks {
        // If we do not want symlinks ()created by Bazel), we can canonicalize the manifest path to
        // get its real path
        manifest_path
            .canonicalize()
            .expect("Cargo.toml symlink cannot be resolved")
    } else {
        manifest_path
    };

    final_manifest_path
        .parent()
        .expect("Cargo.toml parent cannot be resolved")
        .join("tests")
        .join("resources")
}

/// This function returns the path to a test resource given its name.
/// If `allow_symlinks` is `false` will avoid the bazel off-tree test directory as this contains
/// symlinks instead of the files, and we will return the folder containing the canonicalized
/// `Cargo.toml` file.
fn get_resource_impl(resource_name: &str, allow_symlinks: bool) -> PathBuf {
    let path = get_in_tree_resource_root(allow_symlinks);

    let final_path = path.join(resource_name);

    assert_true!(
        final_path.exists(),
        "Test resource path does not exist: {}",
        final_path.display()
    );

    final_path
}

/// This function returns the path to a test resource given its name avoiding the bazel off-tree
/// test directory as this contains symlinks instead of the files.
pub fn get_resource(resource_name: &str) -> PathBuf {
    get_resource_impl(resource_name, false)
}

/// This function returns the path to a test resource given its name potentially using the bazel
/// off-tree test directory as this contains symlinks instead of the files.
pub fn get_symlinked_resource(resource_name: &str) -> PathBuf {
    get_resource_impl(resource_name, true)
}

/// Creates an empty temporary directory.
pub fn create_empty_tmp_dir() -> TempDir {
    tempdir().expect("Failed to create temp dir")
}

/// Creates a temporary directory with the following structure:
/// ```text
/// tmp_dir/
/// |-- sub1/
/// |   \-- file1.h
/// |-- sub2/
/// |   \-- file2.hpp
/// \-- root.h
/// ```
pub fn create_populate_tmp_dir() -> TempDir {
    let tmp_dir = tempdir().expect("Failed to create temp dir");
    let sub1 = tmp_dir.path().join("sub1");
    let sub2 = tmp_dir.path().join("sub2");
    fs::create_dir(&sub1).expect("Failed to create sub1 dir");
    fs::create_dir(&sub2).expect("Failed to create sub2 dir");

    let file1 = sub1.join("file1.h");
    let file2 = sub2.join("file2.hpp");
    let file3 = tmp_dir.path().join("root.h");
    File::create(&file1).expect("Failed to create file1.h");
    File::create(&file2).expect("Failed to create file2.hpp");
    File::create(&file3).expect("Failed to create root.h");

    tmp_dir
}

#[cfg(test)]
mod tests {
    use super::*;
    use all_asserts::assert_false;

    #[test]
    fn test_get_resource() {
        let path = get_resource("dir1");
        assert_true!(path.exists());
        assert_true!(path.is_dir());
        let file = path.join("file1.c");
        assert_true!(file.exists());
        assert_true!(file.is_file());
        assert_false!(file.is_symlink());
        assert_true!(file.ends_with("tests/resources/dir1/file1.c"));
    }

    #[test]
    fn test_get_symlinked_resource() {
        let path_with_symlinks = get_symlinked_resource("dir1");
        assert_true!(path_with_symlinks.exists());
        assert_true!(path_with_symlinks.is_dir());
        let file_maybe_symlinked = path_with_symlinks.join("file1.c");
        assert_true!(file_maybe_symlinked.exists());
        assert_true!(file_maybe_symlinked.ends_with("tests/resources/dir1/file1.c"));

        let is_bazel = env::var("BAZEL_TEST")
            .map(|bazel| bazel == "1")
            .unwrap_or(false);
        if is_bazel {
            assert_true!(file_maybe_symlinked.is_symlink());
        } else {
            assert_true!(file_maybe_symlinked.is_file());
        }
    }
}

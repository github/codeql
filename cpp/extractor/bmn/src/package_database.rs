//! Module containing functionality to read, parse, and query the deptrace package database.

use crate::environment;
use crate::logger::{debug, log};
use anyhow::{anyhow, bail};
use itertools::Itertools;
use std::{
    collections::{HashMap, HashSet},
    ffi::OsString,
    fs::{self, File},
    io::Read,
    path::{Path, PathBuf},
};
use zip::ZipArchive;

/// A package name and a file it provides.
#[derive(Debug, PartialEq, Eq, PartialOrd, Ord, Hash)]
struct PackageAndFile {
    package_name: String,
    file: PathBuf,
}

/// Package database of packages and the files that they provide.
pub struct PackageDatabase {
    file_name_provided_by: HashMap<OsString, HashSet<PackageAndFile>>,
}

fn parse_deptrace_content(content: &str) -> anyhow::Result<HashMap<String, HashSet<PathBuf>>> {
    // The deptrace database format consists of sections where each section is
    // separated by a blank line. The first section is a header section
    // containing a set of folder names (which we ignore). The following
    // sections are package data sections, each starting with the package name
    // followed by the list of files it provides, one per line.
    content
        .trim() // Trim to remove the last trailing linebreak
        .split("\n\n") // Get an iterator over each section
        .skip(1) // Skip the header section
        .map(|block| {
            let mut lines = block.lines().map(str::trim);
            // The first line of the block is the package name
            let package_name = lines
                .next()
                .ok_or_else(|| anyhow!("Unexpected empty package block in deptrace database"))?;
            if package_name.is_empty() {
                bail!("Unexpected empty package name in deptrace database");
            }
            let files: HashSet<PathBuf> = lines
                .map(PathBuf::from)
                .filter(|file| file.starts_with("/usr/include/"))
                .collect();
            Ok((package_name.to_string(), files))
        })
        .filter(|result| !result.as_ref().is_ok_and(|(_, files)| files.is_empty()))
        .collect()
}

impl PackageDatabase {
    /// Create a `PackageDatabase` from the content of a given deptrace database file.
    /// Returns an error if the content is malformed.
    pub fn from_deptrace_content(content: &str) -> anyhow::Result<PackageDatabase> {
        let package_provides = parse_deptrace_content(content)?;

        let file_name_provided_by: HashMap<OsString, HashSet<PackageAndFile>> = package_provides
            .iter()
            .flat_map(|(package_name, files)| {
                files.iter().filter_map(|file| {
                    let file = PathBuf::from(file);
                    let file_name = file.file_name()?.to_os_string();
                    Some((
                        file_name,
                        PackageAndFile {
                            package_name: package_name.clone(),
                            file,
                        },
                    ))
                })
            })
            .into_grouping_map()
            .collect();

        Ok(PackageDatabase {
            file_name_provided_by,
        })
    }

    /// Get the set of packages providing include files that satisfy the include
    /// directive path.
    pub fn get_packages_providing(&self, include_path: &Path) -> HashSet<String> {
        let Some(file_name) = include_path.file_name() else {
            return HashSet::new();
        };
        self.file_name_provided_by
            .get(file_name)
            .into_iter()
            .flatten()
            .filter(|p| p.file.ends_with(include_path))
            .map(|p| p.package_name.clone())
            .collect()
    }
}

/// Map the binary's target architecture to the Debian/Ubuntu architecture name
/// used in the prebuilt deptrace database file names.
fn deptrace_db_arch() -> anyhow::Result<&'static str> {
    match std::env::consts::ARCH {
        "x86_64" => Ok("amd64"),
        "aarch64" => Ok("arm64"),
        other => Err(anyhow!(
            "Dependency installation is not supported on architecture {other}."
        )),
    }
}

/// Determine the path to the deptrace database zip file based on OS version and `AUTOBUILD_ROOT`.
fn get_deptrace_db_zip_path() -> anyhow::Result<PathBuf> {
    let os = infer_os_version_name().ok_or_else(|| anyhow!("Could not infer OS version."))?;

    debug!(
        "Inferred OS version: ID={}, VERSION_ID={}, VERSION_CODENAME={}",
        os.id, os.version_id, os.codename,
    );

    let autobuild_root = environment::get_required_path(environment::AUTOBUILD_ROOT)?;

    let archive_zip_name = format!(
        "deptrace-db-{}-{}-{}.zip",
        os.id,
        os.version_id,
        deptrace_db_arch()?,
    );
    let archive_file_path = autobuild_root.join(&archive_zip_name);

    if !archive_file_path.exists() {
        Err(anyhow!(
            "Dependency installation is not supported on the current OS. Detected {} {}",
            os.id,
            os.version_id,
        ))
    } else {
        Ok(archive_file_path)
    }
}

/// Get a package database from the deptrace database for the given OS. Returns an error if the
/// database cannot be found or parsed.
pub fn get_package_database() -> anyhow::Result<PackageDatabase> {
    // Check for user-specified local deptrace database (plain text file)
    let content = if let Some(path) =
        environment::get_optional_path(environment::CODEQL_EXTRACTOR_CPP_LOCAL_DEPTRACE_DB)
    {
        if !path.exists() {
            return Err(anyhow!(
                "Local deptrace database path specified but file does not exist: {path:?}.",
            ));
        }
        debug!(
            "Using local deptrace database from {}: {path:?}",
            environment::CODEQL_EXTRACTOR_CPP_LOCAL_DEPTRACE_DB,
        );
        fs::read_to_string(&path)
            .map_err(|e| anyhow!("Failed to read local deptrace database from {path:?}: {e}"))?
    } else {
        let archive_file_path = get_deptrace_db_zip_path()?;
        extract_content_from_zip(&archive_file_path).map_err(|e| {
            anyhow!("Failed to extract package database from {archive_file_path:?}: {e}")
        })?
    };
    PackageDatabase::from_deptrace_content(&content)
}

/// Struct to hold OS release information
struct OsReleaseInfo {
    codename: String,
    id: String,
    version_id: String,
}

/// Read the os-release file and extract `VERSION_CODENAME`, `ID` and `VERSION_ID` in a
/// `OsReleaseInfo` struct
fn get_os_release_content(file: impl AsRef<Path>) -> Option<OsReleaseInfo> {
    let content = fs::read_to_string(file).ok()?;
    let lines = content.lines();
    let map: HashMap<&str, &str> = lines
        .filter_map(|line| {
            line.split_once('=').map(|(key, value)| {
                (
                    key.trim(),
                    value.trim().trim_matches('"').trim_matches('\''),
                )
            })
        })
        .collect();

    Some(OsReleaseInfo {
        codename: (*map.get("VERSION_CODENAME")?).to_string(),
        id: (*map.get("ID")?).to_string(),
        version_id: (*map.get("VERSION_ID")?).to_string(),
    })
}

/// Infer the OS version codename, ID and version ID of the host based on
/// either `/etc/os-release` or `/usr/lib/os-release` if any.
fn infer_os_version_name() -> Option<OsReleaseInfo> {
    let locations = [
        PathBuf::from("/etc/os-release"),
        PathBuf::from("/usr/lib/os-release"),
    ];

    locations.iter().find_map(get_os_release_content)
}

/// Open the zip archive at the given path and extract the content of the inner deptrace-db.txt file
/// as a string.
fn extract_content_from_zip(archive_zip_name: &Path) -> anyhow::Result<String> {
    let inner_file_name = "deptrace-db.txt";
    let file = File::open(archive_zip_name)
        .map_err(|e| anyhow!("Could not open archive zip name {archive_zip_name:?}: {e}"))?;
    let mut archive = ZipArchive::new(file)
        .map_err(|e| anyhow!("Could not read zip archive {archive_zip_name:?}: {e}"))?;
    let mut zipped_file = archive.by_name(inner_file_name).map_err(|e| {
        anyhow!("Could not find {inner_file_name} in archive {archive_zip_name:?}: {e}")
    })?;

    let mut buffer = String::new();
    zipped_file.read_to_string(&mut buffer).map_err(|e| {
        anyhow!("Could not read {inner_file_name} from archive {archive_zip_name:?}: {e}")
    })?;

    Ok(buffer)
}

#[cfg(test)]
mod tests {
    use super::*;
    use all_asserts::assert_true;
    use std::fs::File;
    use std::io::Write;
    use tempfile::tempdir;

    fn generate_os_release_file(dir: &Path, content: &str) -> std::io::Result<PathBuf> {
        let file_path = dir.join("os-release");
        let mut file = File::create(&file_path)?;
        writeln!(file, "{content}")?;
        Ok(file_path)
    }

    #[test]
    fn test_get_os_release_content_success_with_double_quotes_ubuntu_24_04() {
        let tmp_dir = tempdir().expect("Could not create temp dir");
        let file_path = generate_os_release_file(
            tmp_dir.path(),
            r#"PRETTY_NAME="Ubuntu 24.04.3 LTS"
NAME="Ubuntu"
VERSION_ID="24.04"
VERSION="24.04.3 LTS (Noble Numbat)"
VERSION_CODENAME=noble
ID=ubuntu
ID_LIKE=debian
HOME_URL="https://www.ubuntu.com/"
SUPPORT_URL="https://help.ubuntu.com/"
BUG_REPORT_URL="https://bugs.launchpad.net/ubuntu/"
PRIVACY_POLICY_URL="https://www.ubuntu.com/legal/terms-and-policies/privacy-policy"
UBUNTU_CODENAME=noble
LOGO=ubuntu-logo"#,
        )
        .expect("Could not generate OS release file");

        let result = get_os_release_content(&file_path);
        assert_true!(result.is_some());
        let os_release_info = result.expect("Should contain OS release data");
        assert_eq!(os_release_info.codename, "noble");
        assert_eq!(os_release_info.id, "ubuntu");
        assert_eq!(os_release_info.version_id, "24.04");
    }

    #[test]
    fn test_get_os_release_content_success_with_single_quotes_ubuntu_24_04() {
        let tmp_dir = tempdir().expect("Could not create temp dir");
        let file_path = generate_os_release_file(
            tmp_dir.path(),
            r"PRETTY_NAME='Ubuntu 24.04.3 LTS'
NAME='Ubuntu'
VERSION_ID='24.04'
VERSION='24.04.3 LTS (Noble Numbat)'
VERSION_CODENAME=noble
ID=ubuntu
ID_LIKE=debian
HOME_URL='https://www.ubuntu.com/'
SUPPORT_URL='https://help.ubuntu.com/'
BUG_REPORT_URL='https://bugs.launchpad.net/ubuntu/'
PRIVACY_POLICY_URL='https://www.ubuntu.com/legal/terms-and-policies/privacy-policy'
UBUNTU_CODENAME=noble
LOGO=ubuntu-logo",
        )
        .expect("Could not generate OS release file");

        let result = get_os_release_content(&file_path);
        assert_true!(result.is_some());
        let os_release_info = result.expect("Should contain OS release data");
        assert_eq!(os_release_info.codename, "noble");
        assert_eq!(os_release_info.id, "ubuntu");
        assert_eq!(os_release_info.version_id, "24.04");
    }

    #[test]
    fn test_get_os_release_content_missing_fields() {
        let tmp_dir = tempdir().expect("Could not create temp dir");
        let file_path = generate_os_release_file(
            tmp_dir.path(),
            r#"PRETTY_NAME="Ubuntu 24.04.3 LTS"
NAME="Ubuntu"
VERSION_ID="24.04"
VERSION="24.04.3 LTS (Noble Numbat)"
ID=ubuntu
ID_LIKE=debian
HOME_URL="https://www.ubuntu.com/"
SUPPORT_URL="https://help.ubuntu.com/"
BUG_REPORT_URL="https://bugs.launchpad.net/ubuntu/"
PRIVACY_POLICY_URL="https://www.ubuntu.com/legal/terms-and-policies/privacy-policy"
UBUNTU_CODENAME=noble
LOGO=ubuntu-logo"#,
        )
        .expect("Could not generate OS release file");

        // File is missing `VERSION_CODENAME`, so it should return None
        let result = get_os_release_content(&file_path);
        assert_true!(result.is_none());
    }

    #[test]
    fn test_get_os_release_content_file_not_found() {
        let file_path = PathBuf::from("/nonexistent/os-release");
        // File is not existent, so it should return None
        let result = get_os_release_content(&file_path);
        assert_true!(result.is_none());
    }

    #[test]
    fn test_from_deptrace_content_basic() {
        let content = r"
/bin
/etc
/lib

libfoo-dev
/usr/include/foo.h
/usr/include/foo/bar.h
/usr/lib/libfoo.so

libbar-dev
/usr/include/bar.h
/usr/lib/libbar.so
/usr/bin/bar

libbaz-dev
/usr/bin/baz
/usr/lib/libbaz.so
";

        let package_provides = parse_deptrace_content(content).expect("Should parse");
        let db = PackageDatabase::from_deptrace_content(content);
        assert_true!(db.is_ok());
        let db = db.expect("Should parse");
        assert_eq!(package_provides.len(), 2);
        assert_eq!(
            package_provides.get("libfoo-dev"),
            Some(&HashSet::from(
                ["/usr/include/foo.h", "/usr/include/foo/bar.h"].map(PathBuf::from)
            ))
        );
        assert_eq!(
            package_provides.get("libbar-dev"),
            Some(&HashSet::from([PathBuf::from("/usr/include/bar.h")]))
        );

        assert_eq!(db.file_name_provided_by.len(), 2);
        assert_eq!(
            db.file_name_provided_by.get(&OsString::from("foo.h")),
            Some(&HashSet::from([PackageAndFile {
                package_name: "libfoo-dev".to_string(),
                file: PathBuf::from("/usr/include/foo.h"),
            }]))
        );
        assert_eq!(
            db.file_name_provided_by.get(&OsString::from("bar.h")),
            Some(&HashSet::from([
                PackageAndFile {
                    package_name: "libbar-dev".to_string(),
                    file: PathBuf::from("/usr/include/bar.h"),
                },
                PackageAndFile {
                    package_name: "libfoo-dev".to_string(),
                    file: PathBuf::from("/usr/include/foo/bar.h"),
                },
            ]))
        );
    }

    #[test]
    fn test_from_deptrace_empty_database() {
        let content = "";
        let result = PackageDatabase::from_deptrace_content(content);

        assert_true!(result.is_ok());
        let db = result.expect("Should parse");

        assert_eq!(db.file_name_provided_by.len(), 0);
    }

    #[test]
    fn test_from_deptrace_with_failures() {
        let content = r"
    Header


    /usr/include/foo.h
    ";
        let result = PackageDatabase::from_deptrace_content(content);
        assert_true!(result.is_err());
    }

    fn generate_database() -> PackageDatabase {
        let content = r"
/bin
/etc
/lib

libfoo-dev
/usr/include/foo.h
/usr/include/foo/bar.h
/usr/lib/libfoo.so

libbar-dev
/usr/include/bar.h
/usr/lib/libbar.so
/usr/bin/bar

libbaz-dev
/usr/bin/baz
/usr/lib/libbaz.so
";
        PackageDatabase::from_deptrace_content(content).expect("Should parse")
    }

    #[test]
    fn test_get_packages_providing_exact_match() {
        let db = generate_database();
        let result = db.get_packages_providing(&PathBuf::from("foo.h"));
        assert_eq!(result, HashSet::from(["libfoo-dev".to_string()]));
    }

    #[test]
    fn test_get_packages_providing_nested_header() {
        let db = generate_database();
        let result = db.get_packages_providing(&PathBuf::from("foo/bar.h"));
        assert_eq!(result, HashSet::from(["libfoo-dev".to_string()]));
    }

    #[test]
    fn test_get_packages_providing_multiple_headers() {
        let db = generate_database();
        let result = db.get_packages_providing(&PathBuf::from("bar.h"));
        assert_eq!(
            result,
            HashSet::from(["libbar-dev".to_string(), "libfoo-dev".to_string()])
        );
    }

    #[test]
    fn test_get_packages_providing_no_match() {
        let db = generate_database();
        let result = db.get_packages_providing(&PathBuf::from("notfound.h"));
        assert!(result.is_empty());
    }
}

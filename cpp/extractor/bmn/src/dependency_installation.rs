use crate::logger::{debug, info, log};
use crate::package_database::{PackageDatabase, get_package_database};
use anyhow::{anyhow, bail};
use itertools::Itertools;
use os_str_bytes::OsStrBytes;
use serde::Serialize;
use std::collections::HashSet;
use std::ffi::{OsStr, OsString};
use std::path::{Path, PathBuf};
use std::process::{Command, Stdio};

/// Check if both apt-get and sudo are available on the system
fn package_installation_available() -> bool {
    Command::new("sudo")
        .args(["--non-interactive", "apt-get", "--version"])
        .stdout(Stdio::null())
        .stderr(Stdio::null())
        .status()
        .is_ok_and(|status| status.success())
}

/// Get a string representation of a command for logging
fn get_command_as_string(command: &Command) -> String {
    let cmd_str = command
        .get_args()
        .collect::<Vec<_>>()
        .join(&OsString::from(" "));
    format!(
        "{:} {:}",
        command.get_program().display(),
        cmd_str.display()
    )
}

/// Run a command and handle errors
fn run_command(command: &mut Command) -> anyhow::Result<()> {
    let command_name = get_command_as_string(command);

    match command.output() {
        Ok(output) if output.status.success() => Ok(()),
        Ok(output) => {
            // Command failed, collect error output
            let error = if let Some(err_str) = OsStr::from_io_bytes(&output.stderr) {
                err_str.to_os_string()
            } else {
                OsString::from("Failed to read output")
            };
            Err(anyhow!("\"{command_name}\" failed: {error:?}"))
        }
        Err(e) => Err(anyhow!("Error waiting for process \"{command_name}\": {e}")),
    }
}

/// Run "sudo apt-get update"
fn apt_update() -> anyhow::Result<()> {
    let mut update_command = Command::new("sudo");
    update_command
        .args(["--non-interactive", "apt-get", "update"])
        .env("DEBIAN_FRONTEND", "noninteractive")
        .stdout(Stdio::piped())
        .stderr(Stdio::piped());

    run_command(&mut update_command)
}

/// Install a package using apt-get
fn install_package(package_name: &str) -> anyhow::Result<()> {
    // Attempt to install the package
    let mut install_command = Command::new("sudo");
    install_command
        .args([
            "--non-interactive",
            "apt-get",
            "install",
            "-y",
            "--no-remove",
            "--no-install-recommends",
            "--",
        ])
        .arg(package_name)
        .env("DEBIAN_FRONTEND", "noninteractive")
        .stdout(Stdio::piped())
        .stderr(Stdio::piped());

    run_command(&mut install_command)
}

/// Struct to manage package installation state
struct PackageInstaller {}

impl PackageInstaller {
    /// Create a new `PackageInstaller` and perform an initial `apt-get update`
    fn new() -> anyhow::Result<Self> {
        if !package_installation_available() {
            bail!("'sudo apt-get' not available.");
        }
        apt_update()?;
        Ok(Self {})
    }

    /// Ensure the given package is installed
    #[allow(clippy::unused_self)]
    fn install_package(&mut self, package_name: &str) -> anyhow::Result<()> {
        install_package(package_name)
    }
}

/// Search for a package that provides the given include path if any.
/// If multiple packages provide the include path, the package with the shortest name is
/// returned, with ties broken by the lexicographically smallest name.
fn search_in_database(package_database: &PackageDatabase, include_path: &Path) -> Option<String> {
    let providing = package_database.get_packages_providing(include_path);

    debug!(
        "Trying to resolve {:?}. found {}: {:?}",
        include_path,
        providing.len(),
        providing
    );

    let best_package = providing.into_iter().min_by(|pkg1, pkg2| {
        // Sort by length first, then lexicographically
        (pkg1.len(), pkg1).cmp(&(pkg2.len(), pkg2))
    });

    debug!(
        "Best package for include {:?} is {:?}",
        include_path, best_package
    );

    best_package
}

fn infer_dependencies(
    package_database: &PackageDatabase,
    missing_include_paths: &[impl AsRef<Path>],
) -> impl Iterator<Item = String> {
    missing_include_paths.iter().map(AsRef::as_ref).filter_map(|include_path| {
        let result = search_in_database(package_database, include_path);
        if let Some(package) = &result {
            debug!("Attempting to resolve include directive {include_path:?}: Inferred package {package:?}.");
        } else {
            debug!("Attempting to resolve include directive {include_path:?}: Could not infer package.");
        }
        result
    })
}

#[derive(Debug, Serialize)]
#[serde(rename_all = "camelCase")]
pub struct InstallationFailure {
    pub package_name: String,
    pub installation_error: String,
}

#[derive(Debug, Serialize)]
#[serde(rename_all = "camelCase")]
pub struct InstallationResult {
    #[serde(skip_serializing_if = "Vec::is_empty")]
    pub installed_packages: Vec<String>,
    #[serde(skip_serializing_if = "Vec::is_empty")]
    pub failed_packages: Vec<InstallationFailure>,
}

/// Try to infer and install missing dependencies for the given include paths if the system is
/// supported.
///
/// Errors when package installation is unavailable, for instance if the system does not provide
/// `apt-get`.
pub fn infer_and_install_dependencies(
    missing_include_paths: &[PathBuf],
) -> Result<InstallationResult, String> {
    // Initialize package installer updating apt-get
    let mut package_installer = PackageInstaller::new()
        .map_err(|e| format!("Could not initialize package installer: {e}"))?;

    //  Load package database or fail if unable
    let package_database =
        get_package_database().map_err(|e| format!("Package database not available: {e}."))?;

    let inferred_dependencies = infer_dependencies(&package_database, missing_include_paths);

    let mut already_installed_packages = HashSet::new();

    // Try to install packages for each missing include
    let (installed_packages, failed_packages) = inferred_dependencies
        .filter_map(|package_name| {
            (!already_installed_packages.contains(&package_name)).then(|| {
                let result = package_installer.install_package(&package_name);
                if let Err(ref e) = result {
                    info!("Package {package_name:?} was not installed due to error {e:?}.");
                    Err(InstallationFailure {
                        package_name,
                        installation_error: e.to_string(),
                    })
                } else {
                    debug!("Installed package {package_name:?}.");
                    already_installed_packages.insert(package_name.clone());
                    Ok(package_name)
                }
            })
        })
        .partition_result();
    Ok(InstallationResult {
        installed_packages,
        failed_packages,
    })
}

#[cfg(test)]
mod tests {
    use super::*;

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
    fn test_search_in_database_exact_match() {
        let db = generate_database();
        let result = search_in_database(&db, &PathBuf::from("foo.h"));
        assert_eq!(result, Some("libfoo-dev".to_string()));
    }

    #[test]
    fn test_search_in_database_multiple_headers() {
        let db = generate_database();
        let result = search_in_database(&db, &PathBuf::from("bar.h"));
        // Should return the lexicographically smallest package name
        assert_eq!(result, Some("libbar-dev".to_string()));
    }

    #[test]
    fn test_search_in_database_no_match() {
        let db = generate_database();
        let result = search_in_database(&db, &PathBuf::from("notfound.h"));
        assert!(result.is_none());
    }

    #[test]
    fn test_infer_dependencies_include_zlib() {
        let db = PackageDatabase::from_deptrace_content(
            r"
/bin

libbotan-2-dev
/usr/include/botan-2/botan/zlib.h

python3-pycparser
/usr/share/python3-pycparser/fake_libc_include/zlib.h

zlib1g-dev
/usr/include/zlib.h",
        )
        .expect("Should parse");
        let result: Vec<String> = infer_dependencies(&db, &["zlib.h"]).collect();
        assert_eq!(result, vec!["zlib1g-dev".to_string()]);
    }
}

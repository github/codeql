//! Contains the logic for determining the Rust toolchain to be used by the
//! extractor.
//!
//! Rust-analyzer only guarantees compatibility with the latest Rust toolchain
//! per:
//! <https://rust-analyzer.github.io/book/installation.html#rust-standard-library>
//!
//! The Rust compiler on the other hand has fairly strong backwards
//! compatibility guarantees. Usually updating to a newer toolchain does not
//! cause any compilation errors.
//!
//! We therefore use a fixed Rust toolchain that is known to work with our
//! version of rust-analyzer. This gives us backwards compatibility issues
//! stemming from the Rust compiler, instead of those stemming from
//! rust-analyzer <-> Rust toolchain incompatibilities. The former set of
//! problems is (per current experiments and future expectations) much smaller.

use std::{io, process};

use chrono::NaiveDate;
use tracing::{info, warn};

/// The toolchain target by the extractor. This should usually be latest Rust
/// toolchain release that precedes our version of rust-analyzer.
///
/// When rust-analyzer is updated this version should be updated accordingly.
const FIXED_RUST_TOOLCHAIN: &str = "1.99.0";

/// The date of the oldest nightly toolchain known to work with our version of
/// rust-analyzer.
///
/// When rust-analyzer is updated this version may need to be updated.
const MINIMUM_NIGHTLY_DATE: NaiveDate = NaiveDate::from_ymd_opt(2026, 7, 15).unwrap();

/// The command output of asking `rustup` which toolchain is used by the Rust
/// project in the current working directory. This main looks at
/// `rust-toolchain.toml` if present.
///
/// Examples of what the stdout might look like when the command is successful:
/// - `nightly-aarch64-apple-darwin (overridden by '/path/to/project/rust-toolchain.toml')`
/// - `nightly-2026-09-01-aarch64-apple-darwin (overridden by '/path/to/project/rust-toolchain.toml')`
/// - `stable-aarch64-apple-darwin (default)`
/// - `1.80.1-aarch64-apple-darwin (overridden by '/path/to/project/rust-toolchain.toml')`
pub fn project_toolchain() -> io::Result<process::Output> {
    process::Command::new("rustup")
        .args(["show", "active-toolchain"])
        .output()
}

/// Returns the fixed toolchain except when the project is using a nightly
/// toolchain.
///
/// Recent nightly toolchains are preserved so that projects can use unstable
/// features. Older dated nightlies are replaced with the oldest nightly known
/// to be compatible with our rust-analyzer version.
pub fn select_toolchain() -> String {
    let stdout = |command: io::Result<process::Output>| {
        command
            .ok()
            .filter(|output| output.status.success())
            .and_then(|output| String::from_utf8(output.stdout).ok())
            .unwrap_or_default()
    };
    let project_toolchain = stdout(project_toolchain());
    let rustc_version = stdout(process::Command::new("rustc").arg("--version").output());
    select_toolchain_from_project_toolchain(&project_toolchain, &rustc_version)
}

/// A toolchain is nightly when its name says so, or when its compiler reports a
/// nightly or dev build (e.g. `rustc 1.102.0-nightly (277240238 2026-11-23)`), which
/// covers custom toolchains linked with `rustup toolchain link`.
fn select_toolchain_from_project_toolchain(project_toolchain: &str, rustc_version: &str) -> String {
    let nightly_rustc = rustc_version
        .split_whitespace()
        .nth(1)
        .is_some_and(|version| version.ends_with("-nightly") || version.ends_with("-dev"));
    let nightly_toolchain = project_toolchain
        .split_whitespace()
        .next()
        .filter(|toolchain| toolchain.starts_with("nightly") || nightly_rustc)
        .map(|toolchain| cap_nightly_toolchain(toolchain.to_owned(), rustc_version));
    nightly_toolchain.unwrap_or_else(|| FIXED_RUST_TOOLCHAIN.to_owned())
}

fn cap_nightly_toolchain(nightly_toolchain: String, rustc_version: &str) -> String {
    if let Some(project_date) =
        nightly_date(&nightly_toolchain).or_else(|| rustc_commit_date(rustc_version))
        && project_date < MINIMUM_NIGHTLY_DATE
    {
        format!("nightly-{MINIMUM_NIGHTLY_DATE}")
    } else {
        nightly_toolchain
    }
}

/// Parse the commit date from `rustc --version` output.
fn rustc_commit_date(rustc_version: &str) -> Option<NaiveDate> {
    let date = rustc_version.trim().strip_suffix(')')?.rsplit(' ').next()?;
    NaiveDate::parse_from_str(date, "%Y-%m-%d").ok()
}

/// Parse the date from a nightly toolchain string.
fn nightly_date(toolchain: &str) -> Option<NaiveDate> {
    let suffix = toolchain.strip_prefix("nightly-")?;
    (suffix.len() >= 10).then(|| NaiveDate::parse_from_str(suffix.get(..10)?, "%Y-%m-%d").ok())?
}

pub fn log_project_toolchain() {
    match project_toolchain() {
        Ok(output) if output.status.success() => info!(
            "project Rust toolchain: {}",
            String::from_utf8_lossy(&output.stdout).trim()
        ),
        Ok(output) => warn!(
            "unable to determine project Rust toolchain: {}",
            String::from_utf8_lossy(&output.stderr).trim()
        ),
        Err(error) => warn!("unable to determine project Rust toolchain: {error}"),
    }
}

#[cfg(test)]
mod tests {
    use super::{
        FIXED_RUST_TOOLCHAIN, MINIMUM_NIGHTLY_DATE, select_toolchain_from_project_toolchain,
    };

    const STABLE_RUSTC: &str = "rustc 1.100.0 (d3a0b1a7f 2026-10-29)";

    #[test]
    fn preserves_rolling_nightly_toolchain() {
        assert_eq!(
            select_toolchain_from_project_toolchain("nightly-aarch64-apple-darwin", STABLE_RUSTC),
            "nightly-aarch64-apple-darwin"
        );
    }

    #[test]
    fn replaces_old_dated_nightly_toolchain() {
        assert_eq!(
            select_toolchain_from_project_toolchain(
                "nightly-2025-07-15-aarch64-apple-darwin",
                STABLE_RUSTC
            ),
            format!("nightly-{MINIMUM_NIGHTLY_DATE}")
        );
        assert_eq!(
            select_toolchain_from_project_toolchain("nightly-2025-07-15", STABLE_RUSTC),
            format!("nightly-{MINIMUM_NIGHTLY_DATE}")
        );
    }

    #[test]
    fn preserves_minimum_dated_nightly_toolchain() {
        assert_eq!(
            select_toolchain_from_project_toolchain(
                "nightly-2026-07-15-aarch64-apple-darwin",
                STABLE_RUSTC
            ),
            "nightly-2026-07-15-aarch64-apple-darwin"
        );
    }

    #[test]
    fn preserves_newer_dated_nightly_toolchain() {
        assert_eq!(
            select_toolchain_from_project_toolchain(
                "nightly-2026-09-01-aarch64-apple-darwin",
                STABLE_RUSTC
            ),
            "nightly-2026-09-01-aarch64-apple-darwin"
        );
    }

    #[test]
    fn preserves_unrecognized_nightly_toolchain() {
        assert_eq!(
            select_toolchain_from_project_toolchain("nightly-custom", STABLE_RUSTC),
            "nightly-custom"
        );
        assert_eq!(
            select_toolchain_from_project_toolchain(
                "nightly-2026-99-99-aarch64-apple-darwin",
                STABLE_RUSTC
            ),
            "nightly-2026-99-99-aarch64-apple-darwin"
        );
    }

    #[test]
    fn replaces_stable_toolchain() {
        assert_eq!(
            select_toolchain_from_project_toolchain(
                "stable-x86_64-unknown-linux-gnu (default)",
                STABLE_RUSTC
            ),
            FIXED_RUST_TOOLCHAIN
        );
    }

    #[test]
    fn preserves_linked_nightly_toolchain() {
        assert_eq!(
            select_toolchain_from_project_toolchain(
                "rustc-master (default)",
                "rustc 1.102.0-nightly (277240238 2026-11-23)\n"
            ),
            "rustc-master"
        );
        assert_eq!(
            select_toolchain_from_project_toolchain("stage1 (default)", "rustc 1.102.0-dev\n"),
            "stage1"
        );
    }

    #[test]
    fn replaces_old_linked_nightly_toolchain() {
        assert_eq!(
            select_toolchain_from_project_toolchain(
                "my-nightly (default)",
                "rustc 1.90.0-nightly (0123456789 2025-07-15)"
            ),
            format!("nightly-{MINIMUM_NIGHTLY_DATE}")
        );
    }

    #[test]
    fn minimum_nightly_matches_qltest_toolchain() {
        // The minimum nightly toolchain should match the one we test against.
        let toolchain_file = include_str!("nightly-toolchain/rust-toolchain.toml");
        assert!(toolchain_file.contains(&format!("channel = \"nightly-{MINIMUM_NIGHTLY_DATE}\"")));
    }
}

//! This module contains all environment variables used and helper functions
//! for accessing them.

use anyhow::{Context, Result, anyhow};
use std::env;
use std::ffi::OsString;
use std::path::PathBuf;

// ============================================================================
// CodeQL Core Environment Variables
// ============================================================================

/// Root directory of the C/C++ extractor.
pub const CODEQL_EXTRACTOR_CPP_ROOT: &str = "CODEQL_EXTRACTOR_CPP_ROOT";

/// Platform identifier (e.g., "linux64", "osx64", "win64").
pub const CODEQL_PLATFORM: &str = "CODEQL_PLATFORM";

/// Directory for log files.
pub const CODEQL_EXTRACTOR_CPP_LOG_DIR: &str = "CODEQL_EXTRACTOR_CPP_LOG_DIR";

/// Directory for diagnostic output.
pub const CODEQL_EXTRACTOR_CPP_DIAGNOSTIC_DIR: &str = "CODEQL_EXTRACTOR_CPP_DIAGNOSTIC_DIR";

/// Number of threads to use for extraction.
pub const CODEQL_THREADS: &str = "CODEQL_THREADS";

/// Verbosity level for logging (0-3).
pub const CODEQL_EXTRACTOR_CPP_VERBOSITY: &str = "CODEQL_EXTRACTOR_CPP_VERBOSITY";

// ============================================================================
// BMN-Specific Environment Variables
// ============================================================================

/// Skip extraction phase (for testing/debugging). Set to "true" to skip.
pub const CODEQL_EXTRACTOR_CPP_BMN_SKIP_EXTRACTION: &str =
    "CODEQL_EXTRACTOR_CPP_BMN_SKIP_EXTRACTION";

/// Compiler override instruction. Values: "clang", "gnu", "msvc", "fallback clang", "fallback msvc".
pub const CODEQL_EXTRACTOR_CPP_BMN_COMPILER: &str = "CODEQL_EXTRACTOR_CPP_BMN_COMPILER";

/// Path to clang C compiler (used with `CODEQL_EXTRACTOR_CPP_BMN_COMPILER=clang`).
pub const CODEQL_EXTRACTOR_CPP_BMN_COMPILER_CLANG_C: &str =
    "CODEQL_EXTRACTOR_CPP_BMN_COMPILER_CLANG_C";

/// Path to clang C++ compiler (used with `CODEQL_EXTRACTOR_CPP_BMN_COMPILER=clang`).
pub const CODEQL_EXTRACTOR_CPP_BMN_COMPILER_CLANG_CPP: &str =
    "CODEQL_EXTRACTOR_CPP_BMN_COMPILER_CLANG_CPP";

/// Path to GNU C compiler (used with `CODEQL_EXTRACTOR_CPP_BMN_COMPILER=gnu`).
pub const CODEQL_EXTRACTOR_CPP_BMN_COMPILER_GNU_C: &str = "CODEQL_EXTRACTOR_CPP_BMN_COMPILER_GNU_C";

/// Path to GNU C++ compiler (used with `CODEQL_EXTRACTOR_CPP_BMN_COMPILER=gnu`).
pub const CODEQL_EXTRACTOR_CPP_BMN_COMPILER_GNU_CPP: &str =
    "CODEQL_EXTRACTOR_CPP_BMN_COMPILER_GNU_CPP";

/// Path to MSVC compiler (used with `CODEQL_EXTRACTOR_CPP_BMN_COMPILER=msvc`).
pub const CODEQL_EXTRACTOR_CPP_BMN_COMPILER_MSVC: &str = "CODEQL_EXTRACTOR_CPP_BMN_COMPILER_MSVC";

/// Enable panic for testing. Set to "true" to enable.
pub const CODEQL_EXTRACTOR_CPP_BMN_PANIC_TEST: &str = "CODEQL_EXTRACTOR_CPP_BMN_PANIC_TEST";

// ============================================================================
// Overlay Environment Variables
// ============================================================================

/// Path to JSON file containing overlay changes.
pub const CODEQL_EXTRACTOR_CPP_OVERLAY_CHANGES: &str = "CODEQL_EXTRACTOR_CPP_OVERLAY_CHANGES";

/// Path to write base metadata for overlay.
pub const CODEQL_EXTRACTOR_CPP_OVERLAY_BASE_METADATA_OUT: &str =
    "CODEQL_EXTRACTOR_CPP_OVERLAY_BASE_METADATA_OUT";

/// Path to read metadata for overlay.
pub const CODEQL_EXTRACTOR_CPP_OVERLAY_METADATA_IN: &str =
    "CODEQL_EXTRACTOR_CPP_OVERLAY_METADATA_IN";

// ============================================================================
// Dependency Installation Environment Variables
// ============================================================================

/// Enable automatic installation of missing dependencies. Set to "true" to enable.
pub const CODEQL_EXTRACTOR_CPP_AUTOINSTALL_DEPENDENCIES: &str =
    "CODEQL_EXTRACTOR_CPP_AUTOINSTALL_DEPENDENCIES";

/// Enable BMN's _experimental_ automatic installation of missing dependencies.
/// Set to "true" to enable.
pub const CODEQL_EXTRACTOR_CPP_BMN_EXPERIMENTAL_AUTOINSTALL_DEPENDENCIES: &str =
    "CODEQL_EXTRACTOR_CPP_BMN_EXPERIMENTAL_AUTOINSTALL_DEPENDENCIES";

/// Path to a local deptrace database text file. If set this path is used instead of the computed
/// path based on OS version and `AUTOBUILD_ROOT`.
pub const CODEQL_EXTRACTOR_CPP_LOCAL_DEPTRACE_DB: &str = "CODEQL_EXTRACTOR_CPP_LOCAL_DEPTRACE_DB";

/// Root directory for autobuild resources (used for package database).
pub const AUTOBUILD_ROOT: &str = "AUTOBUILD_ROOT";

// ============================================================================
// File Filtering Environment Variables (LGTM)
// ============================================================================

/// Newline-separated list of directories to include.
pub const LGTM_INDEX_INCLUDE: &str = "LGTM_INDEX_INCLUDE";

/// Newline-separated list of directories to exclude.
pub const LGTM_INDEX_EXCLUDE: &str = "LGTM_INDEX_EXCLUDE";

/// Advanced glob-style patterns for include/exclude filtering.
/// Format: "include: PATTERN" or "exclude: PATTERN" per line.
pub const LGTM_INDEX_FILTERS: &str = "LGTM_INDEX_FILTERS";

// ============================================================================
// Helper Functions
// ============================================================================

/// Get a required environment variable as a `String`.
/// Returns an error if the variable is not set.
pub fn get_required(name: &str) -> Result<String> {
    env::var(name).with_context(|| format!("Environment variable {name} must be set"))
}

/// Get an optional environment variable as a `String`.
/// Returns `None` if the variable is not set or empty.
pub fn get_optional(name: &str) -> Option<String> {
    env::var(name).ok().filter(|s| !s.is_empty())
}

/// Get an optional environment variable as an `OsString`.
/// Returns `None` if the variable is not set or empty.
pub fn get_optional_os(name: &str) -> Option<OsString> {
    env::var_os(name).filter(|s| !s.is_empty())
}

/// Get a required environment variable as a non-empty `OsString`.
/// Returns an error if the variable is not set or empty.
pub fn get_required_os(name: &str) -> Result<OsString> {
    let value =
        env::var_os(name).ok_or_else(|| anyhow!("Environment variable {name} must be set"))?;
    if value.is_empty() {
        Err(anyhow!("Environment variable {name} must be non-empty"))
    } else {
        Ok(value)
    }
}

pub fn get_optional_path(name: &str) -> Option<PathBuf> {
    get_optional_os(name).map(PathBuf::from)
}

pub fn get_required_path(name: &str) -> Result<PathBuf> {
    get_required_os(name).map(PathBuf::from)
}

/// Get an environment variable as a boolean.
/// Returns true if the value is "true" (case-insensitive), false otherwise.
pub fn get_bool(name: &str) -> bool {
    env::var(name).unwrap_or_default().to_lowercase() == "true"
}

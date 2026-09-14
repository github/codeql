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

use tracing::{info, warn};

/// The toolchain target by the extractor. This should usually be latest Rust
/// toolchain release that precedes our version of rust-analyzer.
///
/// When rust-analyzer is updated this version should be updated accordingly.
const FIXED_RUST_TOOLCHAIN: &str = "1.97.0";

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
/// When the project is using `nightly`, anything below is almost certain to not
/// work. In that case using the specified nightly toolchain may work if the
/// toolchain is compatible with our rust-analyzer version.
pub fn select_toolchain() -> String {
    let nightly = project_toolchain()
        .ok()
        .filter(|output| output.status.success())
        .and_then(|output| String::from_utf8(output.stdout).ok())
        .and_then(|toolchain| toolchain.split_whitespace().next().map(str::to_owned))
        .filter(|toolchain| toolchain.starts_with("nightly"));
    nightly.unwrap_or_else(|| FIXED_RUST_TOOLCHAIN.to_owned())
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

//! Swift front-end parser: shells out to the separate `swift-syntax-parse`
//! binary (which links swift-syntax) to obtain a JSON syntax tree, then adapts
//! that JSON into a `yeast::Ast` via the pure-Rust [`swift_adapter`] module.
//!
//! Running the parser in a separate process keeps the Swift toolchain out of
//! the extractor's own build: the extractor never links Swift, so working on
//! other (e.g. tree-sitter based) languages needs no Swift toolchain. Each call
//! spawns the parser afresh; a longer-lived parser process could be swapped in
//! behind this same seam later without touching the extraction pipeline.

use std::io::Write;
use std::process::{Command, Stdio};

use codeql_extractor::extractor::ParsedTree;

use super::swift_adapter;

/// Environment variable naming the `swift-syntax-parse` executable. When unset,
/// the parser is resolved next to the extractor executable, then on `PATH`.
const PARSE_BIN_ENV: &str = "CODEQL_EXTRACTOR_UNIFIED_SWIFT_SYNTAX_PARSE";

/// Base name of the `swift-syntax-parse` executable as shipped / looked up.
const PARSE_BIN_NAME: &str = "swift-syntax-parse";

/// Parse Swift `source` into a [`ParsedTree`] (a raw `yeast::Ast` plus
/// side-channel `extra` tokens), ready to be desugared via `run_from_ast`.
pub fn parse(source: &[u8]) -> Result<ParsedTree, String> {
    let source =
        std::str::from_utf8(source).map_err(|e| format!("Swift source is not valid UTF-8: {e}"))?;
    let json = run_parser(source)?;
    let mut adapted = swift_adapter::json_to_ast(&json)?;
    adapted.ast.set_source(source.as_bytes().to_vec());
    Ok(ParsedTree {
        ast: adapted.ast,
        extras: adapted.extras,
    })
}

/// The `swift-syntax-parse` executable to invoke, resolved in priority order:
///
/// 1. the `CODEQL_EXTRACTOR_UNIFIED_SWIFT_SYNTAX_PARSE` override, if set;
/// 2. a copy shipped next to the extractor executable — this is how the CodeQL
///    extractor pack lays it out (`tools/<platform>/{extractor,
///    swift-syntax-parse}`), so a packaged extractor is self-contained with no
///    environment setup;
/// 3. a copy one directory further up, which is where `cargo` leaves it when
///    the running executable is a test binary: those live in
///    `target/<profile>/deps/`, one level below `target/<profile>/`;
/// 4. a bare `swift-syntax-parse`, looked up on `PATH`.
fn parse_bin() -> String {
    if let Ok(bin) = std::env::var(PARSE_BIN_ENV) {
        if !bin.is_empty() {
            return bin;
        }
    }
    if let Ok(exe) = std::env::current_exe() {
        let exe_dir = exe.parent();
        let candidates = [exe_dir, exe_dir.and_then(|dir| dir.parent())];
        for dir in candidates.into_iter().flatten() {
            let candidate = dir.join(PARSE_BIN_NAME);
            if candidate.is_file() {
                return candidate.to_string_lossy().into_owned();
            }
        }
    }
    PARSE_BIN_NAME.to_string()
}

/// Explain a failure to launch the parser. A missing binary is by far the most
/// common way this fails — the Swift half of the build is separate, so it is
/// easy to have never built it — so that case carries the remedy rather than a
/// bare OS error.
fn spawn_error(bin: &str, error: std::io::Error) -> String {
    if error.kind() == std::io::ErrorKind::NotFound {
        format!(
            "could not find the Swift parser `{bin}`. Build it with \
             `unified/scripts/build-parser.sh`, which prints the path to set \
             `{PARSE_BIN_ENV}` to (it uses Bazel's Swift toolchain, so no local \
             Swift installation is needed)."
        )
    } else {
        format!("failed to spawn Swift parser `{bin}`: {error}")
    }
}

/// Run the external parser, feeding `source` on stdin and returning its JSON
/// stdout.
fn run_parser(source: &str) -> Result<String, String> {
    let bin = parse_bin();
    let mut child = Command::new(&bin)
        .stdin(Stdio::piped())
        .stdout(Stdio::piped())
        .stderr(Stdio::piped())
        .spawn()
        .map_err(|e| spawn_error(&bin, e))?;

    // The parser reads all of stdin before writing any stdout, so writing the
    // whole source and then closing stdin (by dropping it) cannot deadlock.
    child
        .stdin
        .take()
        .expect("child stdin was piped")
        .write_all(source.as_bytes())
        .map_err(|e| format!("failed to write source to Swift parser `{bin}`: {e}"))?;

    let output = child
        .wait_with_output()
        .map_err(|e| format!("failed to run Swift parser `{bin}`: {e}"))?;
    if !output.status.success() {
        return Err(format!(
            "Swift parser `{bin}` failed ({}): {}",
            output.status,
            String::from_utf8_lossy(&output.stderr).trim()
        ));
    }
    String::from_utf8(output.stdout)
        .map_err(|e| format!("Swift parser produced non-UTF-8 output: {e}"))
}

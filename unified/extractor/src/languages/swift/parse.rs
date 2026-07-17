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
/// `swift-syntax-parse` is looked up on `PATH`.
const PARSE_BIN_ENV: &str = "CODEQL_EXTRACTOR_UNIFIED_SWIFT_SYNTAX_PARSE";

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

/// The `swift-syntax-parse` executable to invoke.
fn parse_bin() -> String {
    std::env::var(PARSE_BIN_ENV).unwrap_or_else(|_| "swift-syntax-parse".to_string())
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
        .map_err(|e| format!("failed to spawn Swift parser `{bin}`: {e}"))?;

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

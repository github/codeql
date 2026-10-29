//! Swift front-end parser: calls into the `swift-syntax-rs` crate (which links
//! swift-syntax) to obtain a JSON syntax tree, then adapts that JSON into a
//! `yeast::Ast` via the pure-Rust [`swift_adapter`] module.

use codeql_extractor::extractor::ParsedTree;

use super::swift_adapter;

/// Parse Swift `source` into a [`ParsedTree`] (a raw `yeast::Ast` plus
/// side-channel `extra` tokens), ready to be desugared via `run_from_ast`.
pub fn parse(source: &[u8]) -> Result<ParsedTree, String> {
    let source =
        std::str::from_utf8(source).map_err(|e| format!("Swift source is not valid UTF-8: {e}"))?;
    let json =
        swift_syntax_rs::parse_to_json(source).map_err(|e| format!("Swift parser failed: {e}"))?;
    let mut adapted = swift_adapter::json_to_ast(&json)?;
    adapted.ast.set_source(source.as_bytes().to_vec());
    Ok(ParsedTree {
        ast: adapted.ast,
        extras: adapted.extras,
    })
}

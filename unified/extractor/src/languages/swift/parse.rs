//! Swift front-end parser, using swift-syntax by default or the native Rust
//! parser when the `rust-parser` feature is enabled.

use codeql_extractor::extractor::ParsedTree;

#[cfg(all(not(feature = "rust-parser"), feature = "swift-syntax"))]
use super::swift_adapter;

#[cfg(not(any(feature = "swift-syntax", feature = "rust-parser")))]
compile_error!("enable either the `swift-syntax` or `rust-parser` feature");

/// Parse Swift `source` into a [`ParsedTree`] (a raw `yeast::Ast` plus
/// side-channel `extra` tokens), ready to be desugared via `run_from_ast`.
pub fn parse(source: &[u8]) -> Result<ParsedTree, String> {
    let source =
        std::str::from_utf8(source).map_err(|e| format!("Swift source is not valid UTF-8: {e}"))?;
    parse_source(source)
}

#[cfg(feature = "rust-parser")]
fn parse_source(source: &str) -> Result<ParsedTree, String> {
    super::swift_rust_parser::parse(source)
}

#[cfg(all(not(feature = "rust-parser"), feature = "swift-syntax"))]
fn parse_source(source: &str) -> Result<ParsedTree, String> {
    let json =
        swift_syntax_rs::parse_to_json(source).map_err(|e| format!("Swift parser failed: {e}"))?;
    let mut adapted = swift_adapter::json_to_ast(&json)?;
    adapted.ast.set_source(source.as_bytes().to_vec());
    Ok(ParsedTree {
        ast: adapted.ast,
        extras: adapted.extras,
    })
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn rejects_invalid_utf8() {
        assert!(
            parse(&[0xff])
                .err()
                .is_some_and(|error| error.contains("not valid UTF-8"))
        );
    }
}

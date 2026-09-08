//! Rust wrapper around the [swift-syntax](https://github.com/swiftlang/swift-syntax)
//! package, allowing Swift source code to be parsed from Rust.
//!
//! The heavy lifting is done by a small Swift shim (see `swift/`) that links
//! against `SwiftSyntax`/`SwiftParser` and exposes a tiny C ABI. This module
//! provides safe Rust bindings on top of that ABI, exposing [`parse_to_json`]
//! which turns Swift source into a JSON syntax tree.
//!
//! Converting that JSON into a `yeast::Ast` (for the CodeQL extractor) is done
//! by the extractor's own pure-Rust adapter module, keeping the Swift toolchain
//! out of the extractor's build.

use std::ffi::{CStr, CString};
use std::os::raw::c_char;

// C ABI exported by the `SwiftSyntaxFFI` dynamic library.
unsafe extern "C" {
    /// Parse a NUL-terminated Swift source string, returning a heap-allocated
    /// NUL-terminated JSON string (or null on failure). The caller owns the
    /// returned pointer and must release it with `ssr_string_free`.
    fn ssr_parse_json(source: *const c_char) -> *mut c_char;

    /// Free a string previously returned by `ssr_parse_json`.
    fn ssr_string_free(ptr: *mut c_char);
}

/// Errors that can occur while parsing Swift source.
#[derive(Debug)]
pub enum ParseError {
    /// The provided source contained an interior NUL byte.
    NulByte,
    /// The Swift shim returned no result. `SwiftParser` recovers from invalid
    /// syntax (it always produces a tree, possibly with error nodes), so this
    /// does *not* indicate a syntax error in the source — it means the shim
    /// failed to serialize the tree to JSON or to allocate the result string.
    SwiftFailure,
}

impl std::fmt::Display for ParseError {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        match self {
            ParseError::NulByte => write!(f, "source contained an interior NUL byte"),
            ParseError::SwiftFailure => {
                write!(f, "the swift-syntax shim failed to produce a JSON result")
            }
        }
    }
}

impl std::error::Error for ParseError {}

/// Parse the given Swift `source` and return a JSON representation of its
/// syntax tree.
///
/// # Example
/// ```no_run
/// let json = swift_syntax_rs::parse_to_json("let x = 1").unwrap();
/// println!("{json}");
/// ```
pub fn parse_to_json(source: &str) -> Result<String, ParseError> {
    let c_source = CString::new(source).map_err(|_| ParseError::NulByte)?;

    // SAFETY: `c_source` is a valid NUL-terminated string for the duration of
    // the call. The returned pointer, if non-null, is owned by us and freed via
    // `ssr_string_free` before returning.
    unsafe {
        let ptr = ssr_parse_json(c_source.as_ptr());
        if ptr.is_null() {
            return Err(ParseError::SwiftFailure);
        }
        let json = CStr::from_ptr(ptr).to_string_lossy().into_owned();
        ssr_string_free(ptr);
        Ok(json)
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn parses_simple_declaration() {
        let json = parse_to_json("let x = 1").expect("parsing should succeed");
        assert!(
            json.contains("\"kind\":\"sourceFile\""),
            "unexpected tree: {json}"
        );
        assert!(json.contains("\"text\":\"x\""), "unexpected tree: {json}");
        // Source ranges are emitted for every node.
        assert!(json.contains("\"range\""), "missing ranges: {json}");
        assert!(
            json.contains("\"line\"") && json.contains("\"column\"") && json.contains("\"offset\""),
            "missing location fields: {json}"
        );
    }

    #[test]
    fn preserves_named_structure() {
        let json = parse_to_json("let x = 1").expect("parsing should succeed");
        // Layout children are embedded directly under their field name.
        assert!(
            json.contains("\"initializer\""),
            "missing initializer field: {json}"
        );
        // Collection-valued fields are elided to plain JSON arrays.
        assert!(
            json.contains("\"statements\":["),
            "statements should be an array: {json}"
        );
        assert!(
            json.contains("\"bindings\":["),
            "bindings should be an array: {json}"
        );
    }

    #[test]
    fn parses_empty_source() {
        let json = parse_to_json("").expect("parsing empty source should succeed");
        assert!(
            json.contains("\"kind\":\"sourceFile\""),
            "unexpected tree: {json}"
        );
        assert!(
            json.contains("\"statements\":[]"),
            "empty collections should be serialized as JSON arrays: {json}"
        );
    }

    #[test]
    fn serializes_json_strings_and_keys_deterministically() {
        let source = "/* quote \" slash / backslash \\ tab \t newline\n emoji 😀 combining e\u{301} control \u{1} */\nlet x = 1";
        let json = parse_to_json(source).expect("parsing should succeed");

        assert!(
            json.contains(
                r#""text":"\/* quote \" slash \/ backslash \\ tab \t newline\n emoji 😀 combining é control \u0001 *\/""#
            ),
            "JSON string was not escaped correctly: {json}"
        );
        assert!(
            json.contains(r#""start":{"column":1,"line":1,"offset":0}"#),
            "JSON object keys were not sorted: {json}"
        );
    }

    #[test]
    fn captures_trivia() {
        // A leading comment is kept as trivia on the token it precedes.
        let json = parse_to_json("// hi\nlet x = 1").expect("parsing should succeed");
        assert!(json.contains("\"leadingTrivia\""), "missing trivia: {json}");
        assert!(
            json.contains("lineComment"),
            "comment trivia not captured: {json}"
        );
    }

    #[test]
    fn folds_standard_library_operators() {
        // Standard-library operators are folded into a precedence-correct tree:
        // the flat `sequenceExpr` becomes nested `infixOperatorExpr` nodes.
        let json = parse_to_json("let x = 1 + 2 * 3").expect("parsing should succeed");
        assert!(
            json.contains("\"kind\":\"infixOperatorExpr\""),
            "operators were not folded: {json}"
        );
        assert!(
            !json.contains("\"kind\":\"sequenceExpr\""),
            "a foldable sequence was left flat: {json}"
        );
    }

    #[test]
    fn folds_file_defined_operators() {
        // An operator declared in the same file (with a known precedence group)
        // is folded, just like a standard-library one.
        let json = parse_to_json("infix operator |>: AdditionPrecedence\nlet y = a |> b |> c")
            .expect("parsing should succeed");
        assert!(
            json.contains("\"kind\":\"infixOperatorExpr\""),
            "file-defined operator was not folded: {json}"
        );
        assert!(
            !json.contains("\"kind\":\"sequenceExpr\""),
            "a foldable sequence was left flat: {json}"
        );
    }

    #[test]
    fn leaves_unknown_operators_unfolded() {
        // An operator that is neither in the standard library nor declared in
        // this file (e.g. imported from another module) has unknown precedence,
        // so its sequence is left flat rather than folded incorrectly.
        let json = parse_to_json("let z = a <+> b").expect("parsing should succeed");
        assert!(
            json.contains("\"kind\":\"sequenceExpr\""),
            "unknown-operator sequence should stay flat: {json}"
        );
        assert!(
            !json.contains("\"kind\":\"infixOperatorExpr\""),
            "unknown operator should not be folded: {json}"
        );
    }

    #[test]
    fn folds_each_sequence_independently() {
        // Folding is isolated per sequence: a statement using a known operator
        // folds even when another statement uses an unknown one. One unfoldable
        // expression does not suppress folding elsewhere.
        let json = parse_to_json("let x = 1 + 2\nlet y = a <+> b").expect("parsing should succeed");
        assert!(
            json.contains("\"kind\":\"infixOperatorExpr\""),
            "the known-operator statement should fold: {json}"
        );
        assert!(
            json.contains("\"kind\":\"sequenceExpr\""),
            "the unknown-operator statement should stay flat: {json}"
        );
    }

    #[test]
    fn folds_grouped_subexpressions_under_unknown_operators() {
        // A parenthesized (or otherwise bracketed) subexpression is its own
        // sequence, so it folds independently even when the enclosing sequence
        // uses an unknown operator. Here `***` is unknown (outer stays flat) but
        // the grouped `b + c` still folds. Note this only works because the
        // parentheses isolate `b + c`: in an unparenthesized `a *** b + c` the
        // whole thing is one flat sequence whose structure can't be determined
        // without `***`'s precedence, so it is left flat entirely.
        let json = parse_to_json("let r = a *** (b + c)").expect("parsing should succeed");
        assert!(
            json.contains("\"kind\":\"infixOperatorExpr\""),
            "the grouped known-operator subexpression should fold: {json}"
        );
        assert!(
            json.contains("\"kind\":\"sequenceExpr\""),
            "the enclosing unknown-operator sequence should stay flat: {json}"
        );
    }
}

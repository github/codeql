//! Converts the swift-syntax JSON syntax tree into a [`yeast::Ast`], the
//! in-memory format the CodeQL desugaring rules operate on.
//!
//! The JSON tree is produced by the `swift-syntax-rs` crate's Swift FFI shim
//! (`parse_to_json`). This module needs no Swift toolchain, so the extractor
//! consumes swift-syntax output out-of-process.
//!
//! The mapping mirrors tree-sitter's node model, which is what yeast (and the
//! extractor's rewrite rules) expect:
//!
//! * **Layout nodes** (e.g. `functionDecl`) and **varying tokens** (identifiers,
//!   literals, operators — the ones whose text is not determined by their kind)
//!   become **named** nodes, keyed by their kind name.
//! * **Fixed tokens** (keywords and punctuation, whose text is fully determined
//!   by their kind) become **anonymous** nodes, keyed by their text — exactly
//!   how tree-sitter models anonymous tokens (e.g. `"func"`, `"->"`).
//! * Collection nodes are already elided to JSON arrays upstream, so a
//!   list-valued field maps directly to that field holding several children.
//!
//! Note: this preserves swift-syntax's own kind/field names; the rewrite rules
//! in [`super::swift`] match those names directly.

use std::collections::BTreeMap;

use codeql_extractor::extractor::ExtraToken;
use serde_json::Value;
use yeast::{Ast, Id, NodeContent, Point, Range};

/// The result of adapting a swift-syntax JSON tree: the [`yeast::Ast`] plus the
/// comment/`unexpectedText` [`ExtraToken`]s harvested from it (in source order).
///
/// The extra tokens are collected into a side channel rather than embedded in
/// the [`yeast::Ast`], mirroring how the extractor treats tree-sitter `extra`
/// nodes: they carry a location and text but are not attached to a parent.
pub struct AdaptedTree {
    pub ast: Ast,
    pub extras: Vec<ExtraToken>,
}

/// swift-syntax `TokenKind` cases whose text is *not* determined by the kind
/// (i.e. `TokenKind.defaultText == nil`). These carry varying information and
/// are modelled as named leaf nodes; every other token is a fixed
/// keyword/punctuation token modelled as an anonymous token keyed by its text.
const VARYING_TOKEN_KINDS: &[&str] = &[
    "identifier",
    "integerLiteral",
    "floatLiteral",
    "stringSegment",
    "binaryOperator",
    "prefixOperator",
    "postfixOperator",
    "dollarIdentifier",
    "regexLiteralPattern",
    "rawStringPoundDelimiter",
    "regexPoundDelimiter",
    "shebang",
    "unknown",
];

/// Keys of a node object that carry metadata rather than a structural child.
fn is_metadata_key(key: &str) -> bool {
    matches!(
        key,
        "kind"
            | "$pos"
            | "$end"
            | "$lineStarts"
            | "tokenKind"
            | "text"
            | "leadingTrivia"
            | "trailingTrivia"
    )
}

/// Converts compact UTF-8 byte offsets into tree-sitter-style points.
struct LocationTable {
    line_starts: Vec<usize>,
}

impl LocationTable {
    fn from_root(root: &Value) -> Result<Self, String> {
        let values = root
            .get("$lineStarts")
            .and_then(Value::as_array)
            .ok_or("root node is missing an array `$lineStarts`")?;
        let mut line_starts = Vec::with_capacity(values.len());
        for (index, value) in values.iter().enumerate() {
            let offset = value
                .as_u64()
                .and_then(|offset| usize::try_from(offset).ok())
                .ok_or_else(|| format!("`$lineStarts[{index}]` is not a valid byte offset"))?;
            line_starts.push(offset);
        }
        if line_starts.first() != Some(&0) {
            return Err("`$lineStarts` must start with offset 0".to_string());
        }
        if line_starts.windows(2).any(|pair| pair[0] >= pair[1]) {
            return Err("`$lineStarts` offsets must be strictly increasing".to_string());
        }
        Ok(Self { line_starts })
    }

    fn point(&self, offset: usize) -> Point {
        let row = self
            .line_starts
            .partition_point(|line_start| *line_start <= offset)
            - 1;
        Point::new(row, offset - self.line_starts[row])
    }

    /// Parse a node's half-open UTF-8 byte range into a [`yeast::Range`].
    fn range(&self, node: &Value) -> Option<Range> {
        let offset = |key: &str| {
            node.get(key)?
                .as_u64()
                .and_then(|offset| usize::try_from(offset).ok())
        };
        let start_byte = offset("$pos")?;
        let end_byte = offset("$end")?;
        Some(Range {
            start_byte,
            end_byte,
            start_point: self.point(start_byte),
            end_point: self.point(end_byte),
        })
    }
}

/// The classification of a JSON node into a yeast kind name and named-ness.
struct KindInfo {
    /// The name under which the kind is registered in the schema.
    name: String,
    /// `true` for named nodes (layout nodes + varying tokens), `false` for
    /// anonymous tokens (fixed keywords/punctuation).
    is_named: bool,
    /// The leaf text for tokens (empty for layout nodes).
    text: String,
}

/// Determine the kind name / named-ness / text for a JSON node object.
fn classify(node: &Value) -> Result<KindInfo, String> {
    let kind = node
        .get("kind")
        .and_then(Value::as_str)
        .ok_or("node object is missing a string `kind`")?;

    if kind != "token" {
        // Layout node: named, keyed by its kind, no leaf text.
        return Ok(KindInfo {
            name: kind.to_string(),
            is_named: true,
            text: String::new(),
        });
    }

    let token_kind = node
        .get("tokenKind")
        .and_then(Value::as_str)
        .ok_or("token is missing a string `tokenKind`")?;
    let text = node
        .get("text")
        .and_then(Value::as_str)
        .unwrap_or("")
        .to_string();

    // The case name is the part before any `(payload)` in the debug rendering.
    let case_name = token_kind.split('(').next().unwrap_or(token_kind);

    if VARYING_TOKEN_KINDS.contains(&case_name) {
        // Varying token: named leaf, keyed by its case name.
        Ok(KindInfo {
            name: case_name.to_string(),
            is_named: true,
            text,
        })
    } else {
        // Fixed token: anonymous, keyed by its text (as tree-sitter does).
        // `endOfFile` has empty text, so fall back to the case name there.
        let name = if text.is_empty() {
            case_name.to_string()
        } else {
            text.clone()
        };
        Ok(KindInfo {
            name,
            is_named: false,
            text,
        })
    }
}

/// Iterate over a node object's structural (field, value) pairs in a stable
/// order, skipping metadata keys.
fn field_entries(node: &Value) -> Vec<(&str, &Value)> {
    node.as_object()
        .map(|map| {
            map.iter()
                .filter(|(k, _)| !is_metadata_key(k))
                .map(|(k, v)| (k.as_str(), v))
                .collect()
        })
        .unwrap_or_default()
}

/// The child node objects held by a field value, which is either a single node
/// object or an array of them (an elided collection).
fn children_of(value: &Value) -> Vec<&Value> {
    match value {
        Value::Array(items) => items.iter().collect(),
        other => vec![other],
    }
}

/// Recursively build `node` (and its descendants) into `ast`, returning its id.
///
/// This is a single traversal: each node's kind and field names are registered
/// in the schema on the fly, immediately before the node is created. Children
/// are built first so a parent's field lists reference existing ids. Any
/// comment/`unexpectedText` trivia carried by a token is harvested into
/// `extras` (as [`ExtraToken`]s) during the same pass rather than embedded in
/// the tree.
fn build(
    node: &Value,
    locations: &LocationTable,
    ast: &mut Ast,
    extras: &mut Vec<ExtraToken>,
) -> Result<Id, String> {
    let info = classify(node)?;
    collect_extras(node, locations, extras);

    let mut fields: BTreeMap<u16, Vec<Id>> = BTreeMap::new();
    for (field, value) in field_entries(node) {
        let field_id = ast.register_field(field);
        let mut ids = Vec::new();
        for child in children_of(value) {
            ids.push(build(child, locations, ast, extras)?);
        }
        fields.insert(field_id, ids);
    }

    let kind_id = if info.is_named {
        ast.register_kind(&info.name)
    } else {
        ast.register_unnamed_kind(&info.name)
    };

    Ok(ast.create_node_with_range(
        kind_id,
        NodeContent::DynamicString(info.text),
        fields,
        info.is_named,
        locations.range(node),
    ))
}

/// Harvest a token's `leadingTrivia`/`trailingTrivia` pieces (each already
/// filtered to comments/`unexpectedText` upstream) into `out` as
/// [`ExtraToken`]s. Non-token nodes have no trivia keys, so this is a no-op for
/// them.
fn collect_extras(node: &Value, locations: &LocationTable, out: &mut Vec<ExtraToken>) {
    for key in ["leadingTrivia", "trailingTrivia"] {
        let Some(Value::Array(pieces)) = node.get(key) else {
            continue;
        };
        for piece in pieces {
            let (Some(kind), Some(range)) = (
                piece.get("kind").and_then(Value::as_str),
                locations.range(piece),
            ) else {
                continue;
            };
            let text = piece
                .get("text")
                .and_then(Value::as_str)
                .unwrap_or("")
                .to_string();
            out.push(ExtraToken {
                kind: trivia_kind_id(kind),
                text,
                range,
            });
        }
    }
}

/// Map a swift-syntax trivia kind name to the stable integer id stored in an
/// [`ExtraToken`]'s `kind` (and written to the `unified_trivia_tokeninfo`
/// table). The value is opaque to the QL library (which reads only the text),
/// but is kept stable and meaningful.
fn trivia_kind_id(kind: &str) -> usize {
    match kind {
        "lineComment" => 1,
        "blockComment" => 2,
        "docLineComment" => 3,
        "docBlockComment" => 4,
        "unexpectedText" => 5,
        _ => 0,
    }
}

/// The authoritative swift-syntax input node-types schema, generated from
/// swift-syntax by `swift-syntax-rs/schemagen` (run
/// `unified/scripts/regenerate-node-types.sh` to refresh it).
/// [`json_to_ast`] seeds every parse with the schema built from this,
/// pre-registering every input kind and field so rule matching never references
/// a name absent from a given file's tree.
const SWIFT_NODE_TYPES: &str = include_str!("../../../swift_node_types.yml");

/// Convert a swift-syntax JSON tree (as produced by [`crate::parse_to_json`])
/// into a [`yeast::Ast`] plus the comment/`unexpectedText` trivia harvested
/// from it. Both are produced in a single traversal. The AST is seeded with the
/// authoritative swift-syntax schema ([`SWIFT_NODE_TYPES`]); the adapter only
/// ever consumes swift-syntax input, so the schema is not a parameter.
pub fn json_to_ast(json: &str) -> Result<AdaptedTree, String> {
    let root: Value = serde_json::from_str(json).map_err(|e| format!("invalid JSON: {e}"))?;
    let locations = LocationTable::from_root(&root)?;

    let mut ast = Ast::with_schema(yeast::node_types_yaml::schema_from_yaml(SWIFT_NODE_TYPES)?);
    let mut extras = Vec::new();
    let root_id = build(&root, &locations, &mut ast, &mut extras)?;
    ast.set_root(root_id);

    // Emit extras in source order (the traversal visits nodes bottom-up).
    extras.sort_by_key(|t| t.range.start_byte);

    Ok(AdaptedTree { ast, extras })
}

#[cfg(test)]
mod tests {
    use super::*;

    /// A hand-written JSON tree exercising layout nodes, a named (varying)
    /// token, a fixed keyword token, and an elided collection field — so the
    /// adapter is tested without needing the Swift toolchain.
    fn sample_json() -> &'static str {
        r#"{
            "$lineStarts": [0],
            "$pos": 0,
            "$end": 9,
            "kind": "sourceFile",
            "statements": [
                {
                    "$pos": 0,
                    "$end": 9,
                    "kind": "variableDecl",
                    "bindingSpecifier": {
                        "$pos": 0,
                        "$end": 3,
                        "kind": "token",
                        "tokenKind": "keyword(SwiftSyntax.Keyword.let)",
                        "text": "let"
                    },
                    "name": {
                        "$pos": 4,
                        "$end": 5,
                        "kind": "token",
                        "tokenKind": "identifier(\"x\")",
                        "text": "x"
                    }
                }
            ]
        }"#
    }

    #[test]
    fn builds_ast_from_json() {
        let ast = json_to_ast(sample_json())
            .expect("adapter should succeed")
            .ast;
        let root = ast.get_root();
        let root_node = ast.get_node(root).expect("root exists");
        assert_eq!(root_node.kind_name(), "sourceFile");
        assert!(root_node.is_named());
    }

    #[test]
    fn classifies_named_and_anonymous_tokens() {
        let ast = json_to_ast(sample_json())
            .expect("adapter should succeed")
            .ast;
        // Walk all nodes and collect (kind_name, is_named) for the two tokens.
        let mut let_named = None;
        let mut ident_named = None;
        for node in ast.nodes() {
            match node.kind_name() {
                "let" => let_named = Some(node.is_named()),
                "identifier" => ident_named = Some(node.is_named()),
                _ => {}
            }
        }
        // Fixed keyword `let` is anonymous (keyed by its text "let").
        assert_eq!(let_named, Some(false));
        // Varying `identifier` is a named leaf.
        assert_eq!(ident_named, Some(true));
    }

    #[test]
    fn preserves_leaf_text() {
        let ast = json_to_ast(sample_json())
            .expect("adapter should succeed")
            .ast;
        let ident = ast
            .nodes()
            .iter()
            .enumerate()
            .find(|(_, n)| n.kind_name() == "identifier")
            .map(|(i, _)| Id(i))
            .expect("identifier node exists");
        assert_eq!(ast.source_text(ident), "x");
    }

    #[test]
    fn maps_source_locations() {
        let ast = json_to_ast(sample_json())
            .expect("adapter should succeed")
            .ast;
        let ident = ast
            .nodes()
            .iter()
            .find(|n| n.kind_name() == "identifier")
            .expect("identifier node exists");
        // `x` is at UTF-8 byte range 4..5 on the first line.
        assert_eq!(ident.start_byte(), 4);
        assert_eq!(ident.end_byte(), 5);
        assert_eq!(ident.start_position(), Point::new(0, 4));
        assert_eq!(ident.end_position(), Point::new(0, 5));
    }

    #[test]
    fn maps_utf8_locations_across_swift_line_endings() {
        // The implied source prefix is `// é😀\r\nlet `: the second line begins
        // at UTF-8 byte 11 and `x` occupies bytes 15..16.
        let json = r#"{
            "$lineStarts": [0, 11, 21, 31],
            "$pos": 0,
            "$end": 31,
            "kind": "sourceFile",
            "name": {
                "$pos": 15,
                "$end": 16,
                "kind": "token",
                "tokenKind": "identifier(\"x\")",
                "text": "x"
            }
        }"#;
        let ast = json_to_ast(json).expect("adapter should succeed").ast;
        let ident = ast
            .nodes()
            .iter()
            .find(|n| n.kind_name() == "identifier")
            .expect("identifier node exists");
        assert_eq!(ident.start_byte(), 15);
        assert_eq!(ident.end_byte(), 16);
        assert_eq!(ident.start_position(), Point::new(1, 4));
        assert_eq!(ident.end_position(), Point::new(1, 5));
    }

    #[test]
    fn rejects_invalid_line_starts() {
        let json = r#"{"$lineStarts":[1],"$pos":0,"$end":0,"kind":"sourceFile"}"#;
        let error = match json_to_ast(json) {
            Ok(_) => panic!("invalid line starts should fail"),
            Err(error) => error,
        };
        assert!(error.contains("must start with offset 0"), "{error}");
    }

    #[test]
    fn collects_extras_into_side_channel() {
        // A token carrying a trailing line comment in its trivia.
        let json = r#"{
            "$lineStarts": [0],
            "$pos": 0,
            "$end": 14,
            "kind": "sourceFile",
            "value": {
                "$pos": 0,
                "$end": 1,
                "kind": "token",
                "tokenKind": "integerLiteral(\"1\")",
                "text": "1",
                "trailingTrivia": [
                    {
                        "$pos": 2,
                        "$end": 6,
                        "kind": "lineComment",
                        "text": "// c"
                    }
                ]
            }
        }"#;
        let adapted = json_to_ast(json).expect("adapter should succeed");

        // The comment is in the side channel, with its text and location.
        assert_eq!(adapted.extras.len(), 1);
        let comment = &adapted.extras[0];
        // `lineComment` maps to extra kind id 1.
        assert_eq!(comment.kind, 1);
        assert_eq!(comment.text, "// c");
        assert_eq!(comment.range.start_byte, 2);
        assert_eq!(comment.range.end_byte, 6);

        // It is not embedded in the AST as a node.
        assert!(
            adapted
                .ast
                .nodes()
                .iter()
                .all(|n| n.kind_name() != "lineComment"),
            "comment should not appear as an AST node"
        );
    }
}

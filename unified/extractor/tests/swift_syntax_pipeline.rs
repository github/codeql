//! Integration test for the swift-syntax front-end pipeline:
//!
//!   swift-syntax JSON -> `swift_adapter::json_to_ast` -> yeast `Ast`
//!   -> `Desugarer::run_from_ast` (the real Swift translation rules) -> dump.
//!
//! This exercises the whole chain *without* the Swift toolchain: the JSON
//! fixture is a real `parse_to_json` dump (see the file header) fed through the
//! pure-Rust adapter module. It verifies the desugarer runs end-to-end over an
//! externally-built AST.

use yeast::dump::dump_ast;

#[path = "../src/languages/mod.rs"]
mod languages;

/// A real `swift-syntax-rs` JSON dump of the Swift source `let x = 1`.
const LET_X_JSON: &str = include_str!("fixtures/let_x.swiftsyntax.json");

const IMPORT_FOUNDATION_JSON: &str = r#"{
    "$lineStarts": [0],
    "$pos": 0,
    "$end": 17,
    "kind": "sourceFile",
    "statements": [
        {
            "$pos": 0,
            "$end": 17,
            "kind": "codeBlockItem",
            "item": {
                "$pos": 0,
                "$end": 17,
                "kind": "importDecl",
                "importKeyword": {
                    "$pos": 0,
                    "$end": 6,
                    "kind": "token",
                    "tokenKind": "keyword(SwiftSyntax.Keyword.import)",
                    "text": "import"
                },
                "path": [
                    {
                        "$pos": 7,
                        "$end": 17,
                        "kind": "importPathComponent",
                        "name": {
                            "$pos": 7,
                            "$end": 17,
                            "kind": "token",
                            "tokenKind": "identifier(\"Foundation\")",
                            "text": "Foundation"
                        }
                    }
                ]
            }
        }
    ]
}"#;

#[test]
fn swift_syntax_json_runs_through_the_desugarer() {
    let lang = languages::all_language_specs()
        .into_iter()
        .find(|l| l.file_globs.iter().any(|g| g.contains("swift")))
        .expect("swift language spec");
    let desugarer = lang.desugarer.as_ref();

    // Adapt the swift-syntax JSON into a yeast AST (pure Rust, no Swift FFI).
    let adapted =
        languages::swift_adapter::json_to_ast(LET_X_JSON).expect("adapter should succeed");
    assert_eq!(
        adapted
            .ast
            .get_node(adapted.ast.get_root())
            .unwrap()
            .kind_name(),
        "sourceFile"
    );

    // Run the real Swift desugaring rules over the externally-built AST. The
    // top-level swift-syntax rules map `sourceFile` to `top_level`/`block`;
    // kinds without swift-syntax rules yet fall back to `unsupported_node`.
    let desugared = desugarer
        .run_from_ast(adapted.ast)
        .expect("desugaring an externally-built AST should not error");

    let dump = dump_ast(&desugared, desugared.get_root(), "");
    assert!(dump.contains("top_level"), "unexpected dump: {dump}");
    assert!(dump.contains("block"), "unexpected dump: {dump}");
}

#[test]
fn import_name_expr_location_excludes_import_keyword() {
    let lang = languages::all_language_specs()
        .into_iter()
        .find(|l| l.file_globs.iter().any(|g| g.contains("swift")))
        .expect("swift language spec");
    let desugarer = lang.desugarer.as_ref();
    let adapted = languages::swift_adapter::json_to_ast(IMPORT_FOUNDATION_JSON)
        .expect("adapter should succeed");

    let desugared = desugarer
        .run_from_ast(adapted.ast)
        .expect("desugaring an import should not error");

    let name_expr_ids: Vec<yeast::Id> = desugared
        .reachable_node_ids()
        .into_iter()
        .filter(|&id| {
            desugared
                .get_node(id)
                .is_some_and(|node| node.kind_name() == "name_expr")
        })
        .collect();
    assert_eq!(
        name_expr_ids.len(),
        1,
        "expected exactly one reachable name_expr"
    );

    let name_expr = desugared.get_node(name_expr_ids[0]).unwrap();
    assert_eq!(name_expr.start_byte(), 7);
    assert_eq!(name_expr.end_byte(), 17);
}

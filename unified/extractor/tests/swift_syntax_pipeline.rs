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

#[test]
fn swift_syntax_json_runs_through_the_desugarer() {
    let lang = languages::all_language_specs()
        .into_iter()
        .find(|l| l.file_globs.iter().any(|g| g.contains("swift")))
        .expect("swift language spec");
    let desugarer = lang.desugar.as_deref().expect("swift desugarer");

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

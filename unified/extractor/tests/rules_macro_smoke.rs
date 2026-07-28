/// Smoke test: load a few real Swift translation rules through the new
/// `yeast::rules!` macro using the bare-rule-body syntax, and confirm the
/// input + output schemas accept them. Compiles only — any type-checking
/// error surfaces as a compile-time error.
#[test]
fn rules_macro_compiles_against_real_swift_schemas() {
    let _rules: Vec<yeast::Rule> = yeast::rules! {
        input: "tree-sitter-swift/node-types.yml",
        output: "ast_types.yml",
        [
            (simple_identifier) @name
            =>
            (name_expr
                identifier: (identifier #{name})),

            (integer_literal) @lit
            =>
            (int_literal #{lit}),

            (line_string_literal) @lit
            =>
            (string_literal #{lit}),
        ]
    };
}

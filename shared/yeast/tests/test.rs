#![cfg(test)]

use yeast::dump::{dump_ast, dump_ast_with_type_errors};
use yeast::*;

const OUTPUT_SCHEMA_YAML: &str = include_str!("node-types.yml");

/// Helper: parse Ruby source with no rules, return dump.
fn parse_and_dump(input: &str) -> String {
    let runner: Runner = Runner::new(tree_sitter_ruby::LANGUAGE.into(), &[]);
    let ast = runner.run(input).unwrap();
    dump_ast(&ast, ast.get_root(), input)
}

/// Helper: parse Ruby source with a custom output schema and a single
/// phase of rules, return dump.
fn run_and_dump(input: &str, rules: Vec<Rule>) -> String {
    run_phased_and_dump(input, vec![Phase::new("test", PhaseKind::Repeating, rules)])
}

/// Helper: parse Ruby source with custom rules and return the transformed AST.
fn run_and_ast(input: &str, rules: Vec<Rule>) -> Ast {
    let lang: tree_sitter::Language = tree_sitter_ruby::LANGUAGE.into();
    let schema =
        yeast::node_types_yaml::schema_from_yaml_with_language(OUTPUT_SCHEMA_YAML, &lang).unwrap();
    let phases = vec![Phase::new("test", PhaseKind::Repeating, rules)];
    let runner: Runner = Runner::with_schema(lang, &schema, &phases);
    runner.run(input).unwrap()
}

/// Helper: parse Ruby source with a custom output schema and multiple
/// rule phases, return dump.
fn run_phased_and_dump(input: &str, phases: Vec<Phase>) -> String {
    let lang: tree_sitter::Language = tree_sitter_ruby::LANGUAGE.into();
    let schema =
        yeast::node_types_yaml::schema_from_yaml_with_language(OUTPUT_SCHEMA_YAML, &lang).unwrap();
    let runner: Runner = Runner::with_schema(lang, &schema, &phases);
    let ast = runner.run(input).unwrap();
    dump_ast(&ast, ast.get_root(), input)
}

/// Helper: like `run_and_dump`, but returns the runner error (if any)
/// instead of unwrapping.
fn run_and_get_error(input: &str, rules: Vec<Rule>) -> String {
    let lang: tree_sitter::Language = tree_sitter_ruby::LANGUAGE.into();
    let schema =
        yeast::node_types_yaml::schema_from_yaml_with_language(OUTPUT_SCHEMA_YAML, &lang).unwrap();
    let phases = vec![Phase::new("test", PhaseKind::Repeating, rules)];
    let runner: Runner = Runner::with_schema(lang, &schema, &phases);
    runner
        .run(input)
        .expect_err("expected runner to return an error")
}

/// Helper: parse Ruby source with no rules and dump with schema type errors.
fn parse_and_dump_typed(input: &str, schema_yaml: &str) -> String {
    let runner: Runner = Runner::new(tree_sitter_ruby::LANGUAGE.into(), &[]);
    let ast = runner.run(input).unwrap();
    let schema = yeast::node_types_yaml::schema_from_yaml(schema_yaml).unwrap();
    dump_ast_with_type_errors(&ast, ast.get_root(), input, &schema)
}

/// Helper: parse Ruby source with no rules and dump with schema type errors,
/// building schema with language IDs so field checks align with parser fields.
fn parse_and_dump_typed_with_language(input: &str, schema_yaml: &str) -> String {
    let lang: tree_sitter::Language = tree_sitter_ruby::LANGUAGE.into();
    let runner: Runner = Runner::new(lang.clone(), &[]);
    let ast = runner.run(input).unwrap();
    let schema = yeast::node_types_yaml::schema_from_yaml_with_language(schema_yaml, &lang)
        .unwrap();
    dump_ast_with_type_errors(&ast, ast.get_root(), input, &schema)
}

/// Helper: parse Ruby source with custom rules and dump with schema type errors.
fn run_and_dump_typed(input: &str, rules: Vec<Rule>, schema_yaml: &str) -> String {
    let lang: tree_sitter::Language = tree_sitter_ruby::LANGUAGE.into();
    let schema = yeast::node_types_yaml::schema_from_yaml(schema_yaml).unwrap();
    let phases = vec![Phase::new("test", PhaseKind::Repeating, rules)];
    let runner: Runner = Runner::with_schema(lang, &schema, &phases);
    let ast = runner.run(input).unwrap();
    dump_ast_with_type_errors(&ast, ast.get_root(), input, &schema)
}

/// Assert that a dump equals the expected string, treating the expected
/// string as an indented multiline literal: leading/trailing blank lines
/// are stripped, and the common leading indentation is removed from every
/// line. This lets test assertions place the first line at the same
/// indentation as the rest of the body.
#[track_caller]
fn assert_dump_eq(actual: &str, expected: &str) {
    let min_indent = expected
        .lines()
        .filter(|l| !l.trim().is_empty())
        .map(|l| l.len() - l.trim_start().len())
        .min()
        .unwrap_or(0);
    let dedented: String = expected
        .lines()
        .map(|l| {
            if l.len() >= min_indent {
                &l[min_indent..]
            } else {
                l
            }
        })
        .collect::<Vec<_>>()
        .join("\n");
    assert_eq!(actual.trim(), dedented.trim());
}

// ---- Parsing tests ----

#[test]
fn test_parse_assignment() {
    let dump = parse_and_dump("x = 1");
    assert_dump_eq(
        &dump,
        r#"
        program
          assignment
            left: identifier "x"
            right: integer "1"
    "#,
    );
}

#[test]
fn test_parse_multiple_assignment() {
    let dump = parse_and_dump("x, y = foo()");
    assert_dump_eq(
        &dump,
        r#"
        program
          assignment
            left:
              left_assignment_list
                identifier "x"
                identifier "y"
            right:
              call
                arguments:
                  argument_list
                method: identifier "foo"
    "#,
    );
}

#[test]
fn test_parse_for_loop() {
    let dump = parse_and_dump("for x in list do\n  y\nend");
    assert_dump_eq(
        &dump,
        r#"
        program
          for
            body:
              do
                identifier "y"
            pattern: identifier "x"
            value:
              in
                identifier "list"
    "#,
    );
}

#[test]
fn test_dump_highlights_type_errors_inline() {
        let schema_yaml = r#"
named:
    program:
        $children*: assignment
    assignment:
        left: identifier
        right: identifier
    identifier:
"#;

        let dump = parse_and_dump_typed("x = 1", schema_yaml);
        assert!(dump.contains("integer \"1\" <-- ERROR:"));
}

#[test]
fn test_dump_reports_preserved_unknown_kind_after_transformation() {
        let schema_yaml = r#"
named:
    program:
        $children*: assignment
    assignment:
        left: identifier
        right: identifier
    identifier:
"#;

        // This rewrite runs and preserves the RHS node kind via capture.
        // With schema above, preserving `integer` should be reported inline.
    let rules: Vec<Rule> = vec![yeast::rule!(
                (assignment left: (_) @left right: (_) @right)
                =>
                (assignment
                        left: {left}
                        right: {right}
                )
        )];

        let dump = run_and_dump_typed("x = 1", rules, schema_yaml);
        assert!(dump.contains("integer \"1\" <-- ERROR:"));
        assert!(dump.contains("node kind 'integer' not in schema"));
}

#[test]
fn test_dump_reports_undeclared_field_on_node() {
        let schema_yaml = r#"
named:
    program:
        $children*: assignment
    assignment:
        left: identifier
    identifier:
"#;

        let dump = parse_and_dump_typed_with_language("x = y", schema_yaml);
        assert!(dump.contains("right: identifier \"y\" <-- ERROR:"));
        assert!(dump.contains("the node 'assignment' has no field 'right'"));
}

#[test]
fn test_dump_reports_disallowed_kind_in_field_type() {
        let schema_yaml = r#"
named:
    program:
        $children*: assignment
    assignment:
        left: identifier
        right: identifier
    identifier:
    integer:
"#;

        let dump = parse_and_dump_typed_with_language("x = 1", schema_yaml);
        assert!(dump.contains("right: integer \"1\" <-- ERROR:"));
        assert!(dump.contains("should contain"));
        assert!(dump.contains("but got integer"));
}

// ---- Query tests ----

#[test]
fn test_query_match() {
    let runner: Runner = Runner::new(tree_sitter_ruby::LANGUAGE.into(), &[]);
    let ast = runner.run("x = 1").unwrap();

    let query = yeast::query!(
        (program
            child: (assignment
                left: (_) @left
                right: (_) @right
            )
        )
    );

    let mut captures = yeast::captures::Captures::new();
    let matched = query.do_match(&ast, ast.get_root(), &mut captures).unwrap();
    assert!(matched);
    assert!(captures.get_var("left").is_ok());
    assert!(captures.get_var("right").is_ok());
}

#[test]
fn test_query_no_match() {
    let runner: Runner = Runner::new(tree_sitter_ruby::LANGUAGE.into(), &[]);
    let ast = runner.run("x = 1").unwrap();

    let query = yeast::query!(
        (program
            child: (call
                method: (_) @m
            )
        )
    );

    let mut captures = yeast::captures::Captures::new();
    let matched = query.do_match(&ast, ast.get_root(), &mut captures).unwrap();
    assert!(!matched);
}

#[test]
fn test_query_skips_extras_in_positional_match() {
    // Regression test: positional wildcards `(_)` must not bind to
    // tree-sitter `extras` (e.g. comments) during forward-scan; extras
    // are conceptually invisible between siblings, matching tree-sitter
    // query semantics. Without this, a later rule that translates a
    // captured comment to nothing (a common idiom, e.g.
    // `(comment) => ()` in Swift) leaves the capture's match-list empty
    // and causes the transform to fail with "Variable X has 0 matches".
    let runner: Runner = Runner::new(tree_sitter_ruby::LANGUAGE.into(), &[]);
    let ast = runner.run("[1, # comment\n2]").unwrap();

    // Navigate to the `array` node: program -> array.
    let mut cursor = AstCursor::new(&ast);
    cursor.goto_first_child();
    let array_id = cursor.node_id();
    assert_eq!(ast.get_node(array_id).unwrap().kind(), "array");

    // Two positional wildcards should bind to the two integers, skipping
    // the comment that sits between them.
    let query = yeast::query!((array (_) @a (_) @b));
    let mut captures = yeast::captures::Captures::new();
    let matched = query.do_match(&ast, array_id, &mut captures).unwrap();
    assert!(matched);
    assert_eq!(
        ast.get_node(captures.get_var("a").unwrap())
            .unwrap()
            .kind(),
        "integer"
    );
    assert_eq!(
        ast.get_node(captures.get_var("b").unwrap())
            .unwrap()
            .kind(),
        "integer"
    );
}

#[test]
fn test_reachable_nodes_excludes_orphaned_rewrite_nodes() {
    let lang: tree_sitter::Language = tree_sitter_ruby::LANGUAGE.into();
    let schema = yeast::node_types_yaml::schema_from_yaml_with_language(OUTPUT_SCHEMA_YAML, &lang)
        .unwrap();
    let phases: Vec<Phase> = vec![Phase::new(
        "test",
        PhaseKind::Repeating,
        vec![yeast::rule!((integer) => (identifier "replaced"))],
    )];
    let runner: Runner = Runner::with_schema(lang, &schema, &phases);

    let input = "x = 1";
    let ast = runner.run(input).unwrap();
    let reachable_ids = ast.reachable_node_ids();

    assert!(
        ast.nodes().len() > reachable_ids.len(),
        "expected rewrite to leave orphaned arena nodes"
    );

    let dump = dump_ast(&ast, ast.get_root(), input);
    assert!(dump.contains("identifier \"replaced\""));
    assert!(!dump.contains("integer \"1\""));
}

#[test]
fn test_query_repeated_capture() {
    let runner: Runner = Runner::new(tree_sitter_ruby::LANGUAGE.into(), &[]);
    let ast = runner.run("x, y, z = 1").unwrap();

    let query = yeast::query!(
        (assignment
            left: (left_assignment_list
                (identifier)* @names
            )
        )
    );

    // Match against the assignment node (first named child of program)
    let mut cursor = AstCursor::new(&ast);
    cursor.goto_first_child();
    let assignment_id = cursor.node_id();

    let mut captures = yeast::captures::Captures::new();
    let matched = query.do_match(&ast, assignment_id, &mut captures).unwrap();
    assert!(matched);
    assert_eq!(captures.get_all("names").len(), 3);
}

#[test]
fn test_capture_unnamed_node_parenthesized() {
    // `("=") @op` captures the unnamed `=` token between left and right.
    let runner: Runner = Runner::new(tree_sitter_ruby::LANGUAGE.into(), &[]);
    let ast = runner.run("x = 1").unwrap();

    let query = yeast::query!(
        (assignment
            left: (_) @lhs
            ("=") @op
            right: (_) @rhs
        )
    );

    let mut cursor = AstCursor::new(&ast);
    cursor.goto_first_child();
    let assignment_id = cursor.node_id();

    let mut captures = yeast::captures::Captures::new();
    let matched = query.do_match(&ast, assignment_id, &mut captures).unwrap();
    assert!(matched);
    let op_id = captures.get_var("op").unwrap();
    let op_node = ast.get_node(op_id).unwrap();
    assert_eq!(op_node.kind(), "=");
    assert!(!op_node.is_named());
}

#[test]
fn test_capture_bare_underscore_repeated() {
    // `_` matches named and unnamed nodes in bare-child position. On this
    // assignment shape, bare children correspond to unnamed tokens (the `=`).
    let runner: Runner = Runner::new(tree_sitter_ruby::LANGUAGE.into(), &[]);
    let ast = runner.run("x = 1").unwrap();

    let query = yeast::query!((assignment _* @all));

    let mut cursor = AstCursor::new(&ast);
    cursor.goto_first_child();
    let assignment_id = cursor.node_id();

    let mut captures = yeast::captures::Captures::new();
    let matched = query.do_match(&ast, assignment_id, &mut captures).unwrap();
    assert!(matched);

    let all = captures.get_all("all");
    assert_eq!(all.len(), 1);
    assert_eq!(ast.get_node(all[0]).unwrap().kind(), "=");
    assert!(!ast.get_node(all[0]).unwrap().is_named());
}

#[test]
fn test_capture_unnamed_node_bare_literal() {
    // `"=" @op` (without surrounding parens) is the same as `("=") @op`.
    let runner: Runner = Runner::new(tree_sitter_ruby::LANGUAGE.into(), &[]);
    let ast = runner.run("x = 1").unwrap();

    let query = yeast::query!(
        (assignment
            left: (_) @lhs
            "=" @op
            right: (_) @rhs
        )
    );

    let mut cursor = AstCursor::new(&ast);
    cursor.goto_first_child();
    let assignment_id = cursor.node_id();

    let mut captures = yeast::captures::Captures::new();
    let matched = query.do_match(&ast, assignment_id, &mut captures).unwrap();
    assert!(matched);
    let op_id = captures.get_var("op").unwrap();
    let op_node = ast.get_node(op_id).unwrap();
    assert_eq!(op_node.kind(), "=");
    assert!(!op_node.is_named());
}

#[test]
fn test_bare_underscore_matches_unnamed() {
    // Bare `_` matches any node, including unnamed tokens, while `(_)`
    // matches only named nodes. Demonstrate by matching the unnamed `=`
    // token in the implicit `child` field of an `assignment`.
    let runner: Runner = Runner::new(tree_sitter_ruby::LANGUAGE.into(), &[]);
    let ast = runner.run("x = 1").unwrap();

    let mut cursor = AstCursor::new(&ast);
    cursor.goto_first_child();
    let assignment_id = cursor.node_id();

    // `(_)` skips unnamed children, so a query containing a single `(_)`
    // bare pattern fails to match the assignment (whose only unfielded
    // child is the unnamed `=`).
    let query_named = yeast::query!((assignment (_) @any));
    let mut captures = yeast::captures::Captures::new();
    let matched = query_named
        .do_match(&ast, assignment_id, &mut captures)
        .unwrap();
    assert!(
        !matched,
        "(_) should skip the unnamed `=` and fail to match"
    );

    // Bare `_` accepts the next child whatever it is, so it matches the
    // unnamed `=` token.
    let query_any = yeast::query!((assignment _ @any));
    let mut captures = yeast::captures::Captures::new();
    let matched = query_any
        .do_match(&ast, assignment_id, &mut captures)
        .unwrap();
    assert!(matched, "_ should match the unnamed `=`");
    let any_node = ast.get_node(captures.get_var("any").unwrap()).unwrap();
    assert_eq!(any_node.kind(), "=");
    assert!(!any_node.is_named());
}

#[test]
fn test_bare_forms_in_field_position() {
    // The bare `_` and bare-literal forms should be accepted as a
    // field's value, not just in the bare-children position. This is
    // syntactic sugar for `(_)` / `("…")` and goes through the same
    // code paths.
    let runner: Runner = Runner::new(tree_sitter_ruby::LANGUAGE.into(), &[]);
    let ast = runner.run("x = 1").unwrap();

    let mut cursor = AstCursor::new(&ast);
    cursor.goto_first_child();
    let assignment_id = cursor.node_id();

    // Bare `_` in field position. Captures the named `identifier "x"`
    // child of the `left` field — bare `_` admits unnamed too, but the
    // first child of `left` happens to be named.
    let query = yeast::query!((assignment left: _ @lhs));
    let mut captures = yeast::captures::Captures::new();
    let matched = query.do_match(&ast, assignment_id, &mut captures).unwrap();
    assert!(matched);
    assert_eq!(
        ast.get_node(captures.get_var("lhs").unwrap())
            .unwrap()
            .kind(),
        "identifier"
    );

    // Bare literal in field position. Equivalent to `("=") @op`.
    let query = yeast::query!((assignment child: "=" @op));
    let mut captures = yeast::captures::Captures::new();
    let matched = query.do_match(&ast, assignment_id, &mut captures).unwrap();
    assert!(matched);
    let op = ast.get_node(captures.get_var("op").unwrap()).unwrap();
    assert_eq!(op.kind(), "=");
    assert!(!op.is_named());
}

#[test]
fn test_forward_scan_finds_unnamed_token_late() {
    // The `do` named-wrapper node has three children in its implicit
    // `child` field, in source order: `do` (unnamed kw), the body
    // identifier, and `end` (unnamed kw). Forward-scan semantics let a
    // query for `("end")` skip past the first two and match the third.
    // Without forward-scan, the matcher took the first child unconditionally
    // and failed.
    let runner: Runner = Runner::new(tree_sitter_ruby::LANGUAGE.into(), &[]);
    let ast = runner.run("for x in list do\n  y\nend").unwrap();

    // Navigate: program > for > do (the body wrapper).
    let mut cursor = AstCursor::new(&ast);
    cursor.goto_first_child(); // for
    cursor.goto_first_child(); // do (the body)
    while cursor.node().kind() != "do" || !cursor.node().is_named() {
        assert!(cursor.goto_next_sibling(), "expected to find named `do`");
    }
    let do_id = cursor.node_id();

    let query = yeast::query!((do ("end") @kw));
    let mut captures = yeast::captures::Captures::new();
    let matched = query.do_match(&ast, do_id, &mut captures).unwrap();
    assert!(matched, "forward-scan should find the `end` keyword");
    let kw = ast.get_node(captures.get_var("kw").unwrap()).unwrap();
    assert_eq!(kw.kind(), "end");
    assert!(!kw.is_named());
}

#[test]
fn test_forward_scan_preserves_order() {
    // Bare patterns are scanned left-to-right and consume positions in
    // order. A query for ("end") then ("do") should fail because `do`
    // appears before `end` in the source order; once forward-scan has
    // consumed `end`, the iterator is exhausted.
    let runner: Runner = Runner::new(tree_sitter_ruby::LANGUAGE.into(), &[]);
    let ast = runner.run("for x in list do\n  y\nend").unwrap();

    let mut cursor = AstCursor::new(&ast);
    cursor.goto_first_child();
    cursor.goto_first_child();
    while cursor.node().kind() != "do" || !cursor.node().is_named() {
        assert!(cursor.goto_next_sibling(), "expected to find named `do`");
    }
    let do_id = cursor.node_id();

    let query = yeast::query!((do ("end") @first ("do") @second));
    let mut captures = yeast::captures::Captures::new();
    let matched = query.do_match(&ast, do_id, &mut captures).unwrap();
    assert!(!matched, "scan must not go backwards");
}

// ---- Tree builder tests ----

#[test]
fn test_tree_builder() {
    let runner: Runner = Runner::new(tree_sitter_ruby::LANGUAGE.into(), &[]);
    let mut ast = runner.run("x = 1").unwrap();
    let input = "x = 1";

    let query = yeast::query!(
        (program
            child: (assignment
                left: (_) @left
                right: (_) @right
            )
        )
    );

    let mut captures = yeast::captures::Captures::new();
    query.do_match(&ast, ast.get_root(), &mut captures).unwrap();

    // Swap left and right
    let fresh = yeast::tree_builder::FreshScope::new();
    let mut user_ctx = ();
    let mut ctx = yeast::build::BuildCtx::new(&mut ast, &captures, &fresh, &mut user_ctx);
    let new_id = yeast::tree!(ctx,
        (program
            child: (assignment
                left: {ctx.capture("right")}
                right: {ctx.capture("left")}
            )
        )
    );

    let dump = dump_ast(ctx.ast, new_id, input);
    assert_dump_eq(
        &dump,
        r#"
        program
          assignment
            left: integer "1"
            right: identifier "x"
    "#,
    );
}

// ---- Rule tests ----

// These rules use field names from node-types.yml, which extends the
// tree-sitter-ruby grammar with named fields for nodes that only have
// unnamed children in tree-sitter (e.g. block_body.stmt, block_parameters.parameter).
fn ruby_rules() -> Vec<Rule> {
    let assign_rule: Rule = yeast::rule!(
        (assignment
            left: (left_assignment_list
                (identifier)* @left
            )
            right: (_) @right
        )
        =>
        (assignment
            left: (identifier $tmp)
            right: {right}
        )
        {..left.iter().enumerate().map(|(i, &lhs)|
            yeast::tree!(
                (assignment
                    left: {lhs}
                    right: (element_reference
                        object: (identifier $tmp)
                        index: (integer #{i})
                    )
                )
            )
        )}
    );

    let for_rule: Rule = yeast::rule!(
        (for
            pattern: (_) @pat
            value: (in (_) @val)
            body: (do (_)* @body)
        )
        =>
        (call
            receiver: {val}
            method: (identifier "each")
            block: (block
                parameters: (block_parameters
                    parameter: (identifier $tmp)
                )
                body: (block_body
                    stmt: (assignment
                        left: {pat}
                        right: (identifier $tmp)
                    )
                    stmt: {..body}
                )
            )
        )
    );

    vec![assign_rule, for_rule]
}

#[test]
fn test_desugar_multiple_assignment() {
    let dump = run_and_dump("x, y = e", ruby_rules());
    assert_dump_eq(
        &dump,
        r#"
        program
          assignment
            left: identifier "$tmp-0"
            right: identifier "e"
          assignment
            left: identifier "x"
            right:
              element_reference
                object: identifier "$tmp-0"
                index: integer "0"
          assignment
            left: identifier "y"
            right:
              element_reference
                object: identifier "$tmp-0"
                index: integer "1"
    "#,
    );
}

#[test]
fn test_desugar_for_loop() {
    let dump = run_and_dump("for x in list do\n  y\nend", ruby_rules());
    assert_dump_eq(
        &dump,
        r#"
        program
          call
            block:
              block
                body:
                  block_body
                    stmt:
                      assignment
                        left: identifier "x"
                        right: identifier "$tmp-0"
                      identifier "y"
                parameters:
                  block_parameters
                    parameter: identifier "$tmp-0"
            method: identifier "each"
            receiver: identifier "list"
    "#,
    );
}

#[test]
fn test_shorthand_rule() {
    let rule: Rule = yeast::rule!(
        (assignment
            left: (_) @method
            right: (_) @receiver
        )
        => call
    );

    let dump = run_and_dump("x = 1", vec![rule]);
    assert_dump_eq(
        &dump,
        r#"
        program
          call
            method: identifier "x"
            receiver: integer "1"
    "#,
    );
}

#[test]
fn test_chained_rules_output_only_kind() {
    // Exercise rule chaining where an intermediate kind exists only in the
    // output schema (not in the input tree-sitter grammar):
    //   assignment        → first_node          (input → output-only)
    //   first_node        → second_node         (output-only → output-only)
    // The matcher must look up `first_node` against the schema, which only
    // knows about it via the YAML node-types file.
    let assignment_to_first = yeast::rule!(
        (assignment
            left: (_) @left
            right: (_) @right
        )
        => first_node
    );
    let first_to_second = yeast::rule!(
        (first_node
            left: (_) @left
            right: (_) @right
        )
        => second_node
    );

    let dump = run_and_dump("x = 1", vec![assignment_to_first, first_to_second]);
    assert_dump_eq(
        &dump,
        r#"
        program
          second_node
            left: identifier "x"
            right: integer "1"
    "#,
    );
}

// A rule that swaps `assignment.left` and `assignment.right`. Each
// application produces another `assignment` whose query the rule
// matches again, so without the once-per-node default it would loop.
fn swap_assignment_rule() -> Rule {
    yeast::rule!(
        (assignment
            left: (_) @left
            right: (_) @right
        )
        =>
        (assignment
            left: {right}
            right: {left}
        )
    )
}

#[test]
fn test_repeated_rule_hits_depth_limit() {
    // With `.repeated()` the rule is allowed to fire on its own output,
    // which cycles forever and trips the rewrite-depth safety net.
    let err = run_and_get_error("x = 1", vec![swap_assignment_rule().repeated()]);
    assert!(
        err.contains("exceeded maximum rewrite depth"),
        "expected depth-limit error, got: {err}"
    );
}

#[test]
fn test_default_rule_fires_at_most_once_per_node() {
    // Without `.repeated()` (the default), a rule fires at most once on a
    // given node. The swap therefore happens exactly once and the desugaring
    // terminates cleanly.
    let dump = run_and_dump("x = 1", vec![swap_assignment_rule()]);
    assert_dump_eq(
        &dump,
        r#"
        program
          assignment
            left: integer "1"
            right: identifier "x"
    "#,
    );
}

// ---- Phase tests ----

#[test]
fn test_phased_desugaring() {
    // Two phases that could equally have been a single one with chained
    // rules. Splitting them makes the intent (cleanup, then desugar)
    // explicit and provides per-phase error messages.
    let cleanup = vec![yeast::rule!(
        (assignment
            left: (_) @left
            right: (_) @right
        )
        => first_node
    )];
    let desugar = vec![yeast::rule!(
        (first_node
            left: (_) @left
            right: (_) @right
        )
        => second_node
    )];

    let dump = run_phased_and_dump(
        "x = 1",
        vec![
            Phase::new("cleanup", PhaseKind::Repeating, cleanup),
            Phase::new("desugar", PhaseKind::Repeating, desugar),
        ],
    );
    assert_dump_eq(
        &dump,
        r#"
        program
          second_node
            left: identifier "x"
            right: integer "1"
    "#,
    );
}

#[test]
fn test_phase_error_includes_phase_name() {
    // A repeated rule that loops; the error message should identify the
    // phase that tripped the depth limit.
    let lang: tree_sitter::Language = tree_sitter_ruby::LANGUAGE.into();
    let schema =
        yeast::node_types_yaml::schema_from_yaml_with_language(OUTPUT_SCHEMA_YAML, &lang).unwrap();
    let phases = vec![Phase::new(
        "buggy",
        PhaseKind::Repeating,
        vec![swap_assignment_rule().repeated()],
    )];
    let runner: Runner = Runner::with_schema(lang, &schema, &phases);
    let err = runner
        .run("x = 1")
        .expect_err("expected runner to return an error");
    assert!(
        err.contains("Phase `buggy`"),
        "error should mention the failing phase, got: {err}"
    );
    assert!(
        err.contains("exceeded maximum rewrite depth"),
        "error should mention the depth limit, got: {err}"
    );
}

/// Helper: an exhaustive set of OneShot rules covering every node reachable
/// (via captures) when translating `"x = 1"`.
fn one_shot_xeq1_rules() -> Vec<Rule> {
    vec![
        yeast::rule!(
            (program (_)* @stmts)
            =>
            (program stmt: {..stmts})
        ),
        yeast::rule!(
            (assignment left: (_) @left right: (_) @right)
            =>
            (first_node left: {left} right: {right})
        ),
        yeast::rule!((identifier) => (identifier "ID")),
        yeast::rule!((integer) => (integer "INT")),
    ]
}

#[test]
fn test_one_shot_phase() {
    let lang: tree_sitter::Language = tree_sitter_ruby::LANGUAGE.into();
    let schema =
        yeast::node_types_yaml::schema_from_yaml_with_language(OUTPUT_SCHEMA_YAML, &lang).unwrap();
    let phases = vec![Phase::new(
        "translate",
        PhaseKind::OneShot,
        one_shot_xeq1_rules(),
    )];
    let runner: Runner = Runner::with_schema(lang, &schema, &phases);

    let input = "x = 1";
    let ast = runner.run(input).unwrap();
    let dump = dump_ast(&ast, ast.get_root(), input);
    assert_dump_eq(
        &dump,
        r#"
        program
          stmt:
            first_node
              left: identifier "ID"
              right: integer "INT"
    "#,
    );
}

#[test]
fn test_one_shot_phase_errors_when_no_rule_matches() {
    let lang: tree_sitter::Language = tree_sitter_ruby::LANGUAGE.into();
    let schema =
        yeast::node_types_yaml::schema_from_yaml_with_language(OUTPUT_SCHEMA_YAML, &lang).unwrap();
    // Drop the `integer` rule so the recursion has no rule for `integer`.
    let mut rules = one_shot_xeq1_rules();
    rules.pop();
    let phases = vec![Phase::new("translate", PhaseKind::OneShot, rules)];
    let runner: Runner = Runner::with_schema(lang, &schema, &phases);

    let err = runner
        .run("x = 1")
        .expect_err("expected OneShot to error on unmatched node");
    assert!(
        err.contains("Phase `translate`"),
        "error should name the phase, got: {err}"
    );
    assert!(
        err.contains("no rule matched") && err.contains("integer"),
        "error should describe the unmatched node kind, got: {err}"
    );
}

/// OneShot recursion must apply rules to *captured* nodes, even if the rule
/// returns a captured child verbatim. A buggy implementation that only
/// recurses into the children of the rule's output (rather than into the
/// captures) would leave the returned capture untransformed.
#[test]
fn test_one_shot_recurses_into_returned_capture() {
    let lang: tree_sitter::Language = tree_sitter_ruby::LANGUAGE.into();
    let schema =
        yeast::node_types_yaml::schema_from_yaml_with_language(OUTPUT_SCHEMA_YAML, &lang).unwrap();
    let rules: Vec<Rule> = vec![
        yeast::rule!(
            (program (_)* @stmts)
            =>
            (program stmt: {..stmts})
        ),
        // Returns the captured `left` verbatim, discarding `right`.
        yeast::rule!(
            (assignment left: (_) @left right: (_) @right)
            =>
            {left}
        ),
        yeast::rule!((identifier) => (identifier "ID")),
        yeast::rule!((integer) => (integer "INT")),
    ];
    let phases = vec![Phase::new("translate", PhaseKind::OneShot, rules)];
    let runner: Runner = Runner::with_schema(lang, &schema, &phases);

    let input = "x = 1";
    let ast = runner.run(input).unwrap();
    let dump = dump_ast(&ast, ast.get_root(), input);
    // `left` is an `identifier`; OneShot must apply the identifier rule to
    // it before the assignment transform returns it verbatim.
    assert_dump_eq(
        &dump,
        r#"
        program
          stmt: identifier "ID"
    "#,
    );
}

/// OneShot recursion must NOT descend into the children of the rule's output.
/// A rule may legitimately wrap a captured node in fresh output-schema nodes
/// that have no matching rule of their own (since rule patterns target the
/// input schema). Recursing into the output would erroneously try to find
/// rules for those wrapper kinds and fail.
#[test]
fn test_one_shot_does_not_recurse_into_wrapper_output() {
    let lang: tree_sitter::Language = tree_sitter_ruby::LANGUAGE.into();
    let schema =
        yeast::node_types_yaml::schema_from_yaml_with_language(OUTPUT_SCHEMA_YAML, &lang).unwrap();
    let rules: Vec<Rule> = vec![
        yeast::rule!(
            (program (_)* @stmts)
            =>
            (program stmt: {..stmts})
        ),
        // Wraps `left` in nested `first_node`/`second_node` output kinds.
        // Neither wrapper kind has a matching rule, so a buggy implementation
        // that recurses into the wrapper's children would error.
        yeast::rule!(
            (assignment left: (_) @left right: (_) @right)
            =>
            (first_node
                left: (second_node left: {left} right: {right})
                right: {left}
            )
        ),
        yeast::rule!((identifier) => (identifier "ID")),
        yeast::rule!((integer) => (integer "INT")),
    ];
    let phases = vec![Phase::new("translate", PhaseKind::OneShot, rules)];
    let runner: Runner = Runner::with_schema(lang, &schema, &phases);

    let input = "x = 1";
    let ast = runner.run(input).unwrap();
    let dump = dump_ast(&ast, ast.get_root(), input);
    assert_dump_eq(
        &dump,
        r#"
        program
          stmt:
            first_node
              left:
                second_node
                  left: identifier "ID"
                  right: integer "INT"
              right: identifier "ID"
    "#,
    );
}

// ---- Cursor tests ----

#[test]
fn test_cursor_navigation() {
    let runner: Runner = Runner::new(tree_sitter_ruby::LANGUAGE.into(), &[]);
    let ast = runner.run("x = 1").unwrap();
    let mut cursor = AstCursor::new(&ast);

    // Start at root
    assert_eq!(cursor.node().kind(), "program");

    // Go to first child (assignment)
    assert!(cursor.goto_first_child());
    assert_eq!(cursor.node().kind(), "assignment");

    // No sibling
    assert!(!cursor.goto_next_sibling());

    // Go to first child of assignment
    assert!(cursor.goto_first_child());
    assert!(cursor.node().is_named());

    // Go back up
    assert!(cursor.goto_parent());
    assert_eq!(cursor.node().kind(), "assignment");

    assert!(cursor.goto_parent());
    assert_eq!(cursor.node().kind(), "program");

    // Can't go further up
    assert!(!cursor.goto_parent());
}

#[test]
fn test_desugar_for_with_multiple_assignment() {
    let dump = run_and_dump("for a, b in list do\n  x\nend", ruby_rules());
    assert_dump_eq(
        &dump,
        r#"
        program
          call
            block:
              block
                body:
                  block_body
                    stmt:
                      assignment
                        left: identifier "$tmp-1"
                        right: identifier "$tmp-0"
                      assignment
                        left: identifier "a"
                        right:
                          element_reference
                            object: identifier "$tmp-1"
                            index: integer "0"
                      assignment
                        left: identifier "b"
                        right:
                          element_reference
                            object: identifier "$tmp-1"
                            index: integer "1"
                      identifier "x"
                parameters:
                  block_parameters
                    parameter: identifier "$tmp-0"
            method: identifier "each"
            receiver: identifier "list"
    "#,
    );
}

/// Regression test: `#{capture}` in a template must render the *source text*
/// of the captured node, not its arena `Id`. Previously, captures were bound
/// as `usize`, so `#{cap}` printed the integer id (e.g. `"3"`) via `Display`.
/// Captures are now bound as `NodeRef`, which has no `Display` impl and
/// resolves to the captured node's source text via `YeastDisplay`.
#[test]
fn test_hash_brace_renders_capture_source_text() {
    let rule: Rule = rule!(
        (call
            method: (identifier) @name
            receiver: (identifier) @recv
        )
        =>
        (call
            method: (identifier #{name})
            receiver: (identifier #{recv})
            arguments: (argument_list)
        )
    );
    let dump = run_and_dump("foo.bar()", vec![rule]);
    assert_dump_eq(
        &dump,
        r#"
        program
          call
            arguments: argument_list "foo.bar()"
            method: identifier "bar"
            receiver: identifier "foo"
    "#,
    );
}

/// Regression test: non-`NodeRef` values in `#{expr}` still render via their
/// `Display` impl (covered by `YeastDisplay`'s blanket impls for primitives).
#[test]
fn test_hash_brace_renders_integer_expression() {
    let rule: Rule = rule!(
        (identifier) @_
        =>
        (identifier #{1 + 2})
    );
    let dump = run_and_dump("foo", vec![rule]);
    assert_dump_eq(
        &dump,
        r#"
        program
          identifier "3"
    "#,
    );
}

/// Regression test: `(kind #{capture})` should inherit the captured node's
/// source location, not the full source range of the matched rule root.
#[test]
fn test_hash_brace_uses_capture_location_for_leaf() {
    let rule: Rule = rule!(
        (call
            method: (identifier) @name
            receiver: (identifier) @recv
        )
        =>
        (call
            method: (identifier #{name})
            receiver: (identifier #{recv})
            arguments: (argument_list)
        )
    );

    let ast = run_and_ast("foo.bar()", vec![rule]);

    let mut bar_ids: Vec<usize> = Vec::new();
    for id in ast.reachable_node_ids() {
        let Some(node) = ast.get_node(id) else { continue; };
        if node.kind() == "identifier" && ast.source_text(id) == "bar" {
            bar_ids.push(id);
        }
    }

    assert_eq!(bar_ids.len(), 1, "expected exactly one identifier 'bar'");
    let bar = ast.get_node(bar_ids[0]).unwrap();

    assert_eq!(bar.start_byte(), 4);
    assert_eq!(bar.end_byte(), 7);
}

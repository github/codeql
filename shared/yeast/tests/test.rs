#![cfg(test)]

use yeast::dump::dump_ast;
use yeast::*;

const OUTPUT_SCHEMA_YAML: &str = include_str!("node-types.yml");

/// Helper: parse Ruby source with no rules, return dump.
fn parse_and_dump(input: &str) -> String {
    let runner = Runner::new(tree_sitter_ruby::LANGUAGE.into(), &[]);
    let ast = runner.run(input).unwrap();
    dump_ast(&ast, ast.get_root(), input)
}

/// Helper: parse Ruby source with a custom output schema and rules, return dump.
fn run_and_dump(input: &str, rules: Vec<Rule>) -> String {
    let lang: tree_sitter::Language = tree_sitter_ruby::LANGUAGE.into();
    let schema =
        yeast::node_types_yaml::schema_from_yaml_with_language(OUTPUT_SCHEMA_YAML, &lang).unwrap();
    let runner = Runner::with_schema(lang, &schema, &rules);
    let ast = runner.run(input).unwrap();
    dump_ast(&ast, ast.get_root(), input)
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

// ---- Query tests ----

#[test]
fn test_query_match() {
    let runner = Runner::new(tree_sitter_ruby::LANGUAGE.into(), &[]);
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
    let runner = Runner::new(tree_sitter_ruby::LANGUAGE.into(), &[]);
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
fn test_query_repeated_capture() {
    let runner = Runner::new(tree_sitter_ruby::LANGUAGE.into(), &[]);
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
    let assignment_id = cursor.node().id();

    let mut captures = yeast::captures::Captures::new();
    let matched = query.do_match(&ast, assignment_id, &mut captures).unwrap();
    assert!(matched);
    assert_eq!(captures.get_all("names").len(), 3);
}

#[test]
fn test_capture_unnamed_node_parenthesized() {
    // `("=") @op` captures the unnamed `=` token between left and right.
    let runner = Runner::new(tree_sitter_ruby::LANGUAGE.into(), &[]);
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
    let assignment_id = cursor.node().id();

    let mut captures = yeast::captures::Captures::new();
    let matched = query.do_match(&ast, assignment_id, &mut captures).unwrap();
    assert!(matched);
    let op_id = captures.get_var("op").unwrap();
    let op_node = ast.get_node(op_id).unwrap();
    assert_eq!(op_node.kind(), "=");
    assert!(!op_node.is_named());
}

#[test]
fn test_capture_unnamed_node_bare_literal() {
    // `"=" @op` (without surrounding parens) is the same as `("=") @op`.
    let runner = Runner::new(tree_sitter_ruby::LANGUAGE.into(), &[]);
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
    let assignment_id = cursor.node().id();

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
    let runner = Runner::new(tree_sitter_ruby::LANGUAGE.into(), &[]);
    let ast = runner.run("x = 1").unwrap();

    let mut cursor = AstCursor::new(&ast);
    cursor.goto_first_child();
    let assignment_id = cursor.node().id();

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
    let runner = Runner::new(tree_sitter_ruby::LANGUAGE.into(), &[]);
    let ast = runner.run("x = 1").unwrap();

    let mut cursor = AstCursor::new(&ast);
    cursor.goto_first_child();
    let assignment_id = cursor.node().id();

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
    let runner = Runner::new(tree_sitter_ruby::LANGUAGE.into(), &[]);
    let ast = runner.run("for x in list do\n  y\nend").unwrap();

    // Navigate: program > for > do (the body wrapper).
    let mut cursor = AstCursor::new(&ast);
    cursor.goto_first_child(); // for
    cursor.goto_first_child(); // do (the body)
    while cursor.node().kind() != "do" || !cursor.node().is_named() {
        assert!(cursor.goto_next_sibling(), "expected to find named `do`");
    }
    let do_id = cursor.node().id();

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
    let runner = Runner::new(tree_sitter_ruby::LANGUAGE.into(), &[]);
    let ast = runner.run("for x in list do\n  y\nend").unwrap();

    let mut cursor = AstCursor::new(&ast);
    cursor.goto_first_child();
    cursor.goto_first_child();
    while cursor.node().kind() != "do" || !cursor.node().is_named() {
        assert!(cursor.goto_next_sibling(), "expected to find named `do`");
    }
    let do_id = cursor.node().id();

    let query = yeast::query!((do ("end") @first ("do") @second));
    let mut captures = yeast::captures::Captures::new();
    let matched = query.do_match(&ast, do_id, &mut captures).unwrap();
    assert!(!matched, "scan must not go backwards");
}

// ---- Tree builder tests ----

#[test]
fn test_tree_builder() {
    let runner = Runner::new(tree_sitter_ruby::LANGUAGE.into(), &[]);
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
    let mut ctx = yeast::build::BuildCtx::new(&mut ast, &captures, &fresh);
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
    let assign_rule = yeast::rule!(
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

    let for_rule = yeast::rule!(
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
    let rule = yeast::rule!(
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

// ---- Cursor tests ----

#[test]
fn test_cursor_navigation() {
    let runner = Runner::new(tree_sitter_ruby::LANGUAGE.into(), &[]);
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

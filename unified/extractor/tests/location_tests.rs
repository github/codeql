use yeast::Ast;

#[path = "../src/languages/mod.rs"]
mod languages;

fn desugar(source: &str) -> Ast {
    let lang = languages::all_language_specs()
        .into_iter()
        .find(|language| {
            language
                .file_globs
                .iter()
                .any(|glob| glob.contains("swift"))
        })
        .expect("Swift language spec");
    let parsed = (lang.parser)(source.as_bytes()).expect("Swift should parse");
    lang.desugarer
        .run_from_ast(parsed.ast)
        .expect("Swift should desugar")
}

fn spans(ast: &Ast, source: &str, kind: &str, content: Option<&str>) -> Vec<String> {
    ranges(ast, kind, content)
        .into_iter()
        .filter_map(|range| source.get(range).map(str::to_owned))
        .collect()
}

fn ranges(ast: &Ast, kind: &str, content: Option<&str>) -> Vec<std::ops::Range<usize>> {
    ast.reachable_node_ids()
        .into_iter()
        .filter_map(|id| {
            let node = ast.get_node(id)?;
            if node.kind_name() != kind
                || content
                    .is_some_and(|content| node.opt_string_content().as_deref() != Some(content))
            {
                return None;
            }
            node.source_range()
                .map(|range| range.start_byte..range.end_byte)
        })
        .collect()
}

fn assert_has_span(ast: &Ast, source: &str, kind: &str, content: Option<&str>, expected: &str) {
    let spans = spans(ast, source, kind, content);
    assert!(
        spans.iter().any(|span| span == expected),
        "expected {kind} {content:?} to span {expected:?}, got {spans:?}"
    );
}

fn assert_has_empty_span(ast: &Ast, kind: &str, content: Option<&str>, expected_offset: usize) {
    let ranges = ranges(ast, kind, content);
    assert!(
        ranges
            .iter()
            .any(|range| range.start == expected_offset && range.end == expected_offset),
        "expected {kind} {content:?} to have an empty span at {expected_offset}, got {ranges:?}"
    );
}

#[test]
fn generic_type_children_have_local_ranges() {
    let source = "let x = C<Foo>()";
    let ast = desugar(source);

    assert_has_span(&ast, source, "generic_type_expr", None, "C<Foo>");
    assert_has_span(&ast, source, "identifier", Some("C"), "C");
    assert_has_span(&ast, source, "identifier", Some("Foo"), "Foo");
}

#[test]
fn nested_calls_include_their_delimiters() {
    let source = r#"sink(source("first"), source("second"))"#;
    let ast = desugar(source);

    assert_has_span(&ast, source, "call_expr", None, r#"source("first")"#);
    assert_has_span(&ast, source, "call_expr", None, r#"source("second")"#);
}

#[test]
fn enum_case_constructors_include_their_parameter_clause() {
    let source = "enum Result<T> { case success(T) }";
    let ast = desugar(source);

    assert_has_span(&ast, source, "constructor_declaration", None, "success(T)");
}

#[test]
fn synthesized_condition_and_switch_nodes_use_child_ranges() {
    let source = "if a, b { c }\nswitch x { case a, b: c }";
    let ast = desugar(source);

    assert_has_span(&ast, source, "binary_expr", None, "a, b");
    assert_has_empty_span(
        &ast,
        "infix_operator",
        Some("&&"),
        source.find(',').unwrap(),
    );
    assert_has_span(&ast, source, "or_pattern", None, "a, b");
    assert_has_span(&ast, source, "block", None, "c");
}

#[test]
fn declaration_and_operator_tokens_keep_precise_ranges() {
    let source = "func f() { return x }\nlet y = try? await value! as? T\nlet z = value is T";
    let ast = desugar(source);

    assert_has_span(&ast, source, "block", None, "{ return x }");
    assert_has_span(&ast, source, "return_expr", None, "return x");
    assert_has_span(&ast, source, "prefix_operator", Some("try?"), "try?");
    assert_has_span(&ast, source, "prefix_operator", Some("await"), "await");
    assert_has_span(&ast, source, "postfix_operator", Some("!"), "!");
    assert_has_span(&ast, source, "infix_operator", Some("as?"), "as?");
    assert_has_span(&ast, source, "infix_operator", Some("is"), "is");
}

#[test]
fn synthetic_optional_binding_nodes_anchor_to_binding_keyword() {
    let source = "if let value = optional {}";
    let ast = desugar(source);
    let binding_start = source.find("let").unwrap();

    assert_has_empty_span(&ast, "member_access_expr", None, binding_start);
    assert_has_empty_span(&ast, "identifier", Some("Optional"), binding_start);
    assert_has_empty_span(&ast, "identifier", Some("some"), binding_start);
    assert_has_span(&ast, source, "modifier", Some("let"), "let");
}

#[test]
fn synthetic_type_and_modifier_nodes_use_empty_scope_start_ranges() {
    let source = "let array: [T]\nlet optional: T?\nenum E { case a, b }";
    let ast = desugar(source);

    assert_has_empty_span(&ast, "identifier", Some("Array"), source.find('[').unwrap());
    assert_has_empty_span(
        &ast,
        "identifier",
        Some("Optional"),
        source.find("T?").unwrap(),
    );
    let case_a = source.find("a, b").unwrap();
    let case_b = case_a + "a, ".len();
    assert_has_empty_span(&ast, "modifier", Some("enum_case"), case_a);
    assert_has_empty_span(&ast, "modifier", Some("enum_case"), case_b);
    assert_has_empty_span(&ast, "modifier", Some("chained_declaration"), case_b);
}

#[test]
fn import_member_chain_excludes_import_keyword() {
    let source = "import Foundation.Networking.URLSession";
    let ast = desugar(source);

    assert_has_span(
        &ast,
        source,
        "member_access_expr",
        None,
        "Foundation.Networking",
    );
    assert_has_span(
        &ast,
        source,
        "member_access_expr",
        None,
        "Foundation.Networking.URLSession",
    );
    assert_has_span(
        &ast,
        source,
        "import_declaration",
        None,
        "import Foundation.Networking.URLSession",
    );
}

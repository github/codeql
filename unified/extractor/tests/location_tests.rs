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
            Some(node.byte_range())
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
    assert_has_empty_span(&ast, "bulk_importing_pattern", None, 0);
}

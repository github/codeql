use std::fmt::Write;

use crate::{schema::Schema, Ast, Id, Node, NodeContent, CHILD_FIELD};

#[derive(Clone, Copy)]
struct TypeCheckContext<'a> {
    schema: &'a Schema,
    expected: Option<&'a [crate::schema::NodeType]>,
    parent_field: Option<(&'a str, &'a str)>,
}

/// Options for controlling AST dump output.
pub struct DumpOptions {
    /// Whether to include source locations in the output.
    pub show_locations: bool,
    /// Whether to include source text for leaf nodes.
    pub show_content: bool,
    /// Whether to include each node's source range with direct-child ranges
    /// replaced by their field names in `⟨angle brackets⟩`.
    pub show_abridged_source: bool,
}

impl Default for DumpOptions {
    fn default() -> Self {
        Self {
            show_locations: false,
            show_content: true,
            show_abridged_source: false,
        }
    }
}

/// Dump a yeast AST as a human-readable indented text format.
///
/// Output format:
/// ```text
/// program
///   assignment
///     left:
///       left_assignment_list
///         identifier "x"
///         identifier "y"
///     right:
///       call
///         method:
///           identifier "foo"
/// ```
pub fn dump_ast(ast: &Ast, root: Id, source: &str) -> String {
    dump_ast_with_options(ast, root, source, &DumpOptions::default())
}

pub fn dump_ast_with_options(ast: &Ast, root: Id, source: &str, options: &DumpOptions) -> String {
    let mut out = String::new();
    dump_node(ast, root, source, options, 0, None, &mut out);
    out
}

/// Dump an AST and annotate type mismatches against a schema inline.
///
/// Any node that does not match the expected type set for its parent field is
/// rendered with a trailing `" <-- ERROR: ..."` annotation on the same line.
pub fn dump_ast_with_type_errors(ast: &Ast, root: Id, source: &str, schema: &Schema) -> String {
    dump_ast_with_type_errors_and_options(ast, root, source, schema, &DumpOptions::default())
}

/// Dump an AST and annotate type mismatches against a schema inline.
///
/// Any node that does not match the expected type set for its parent field is
/// rendered with a trailing `" <-- ERROR: ..."` annotation on the same line.
pub fn dump_ast_with_type_errors_and_options(
    ast: &Ast,
    root: Id,
    source: &str,
    schema: &Schema,
    options: &DumpOptions,
) -> String {
    let mut out = String::new();
    dump_node(
        ast,
        root,
        source,
        options,
        0,
        Some(TypeCheckContext {
            schema,
            expected: None,
            parent_field: None,
        }),
        &mut out,
    );
    out
}

fn format_node_types(node_types: &[crate::schema::NodeType]) -> String {
    node_types
        .iter()
        .map(|t| {
            if t.named {
                t.kind.clone()
            } else {
                format!("\"{}\"", t.kind)
            }
        })
        .collect::<Vec<_>>()
        .join(" | ")
}

const EMPTY_NODE_TYPES: &[crate::schema::NodeType] = &[];

/// Generate a type-checking error message for a node if it doesn't match expected types.
///
/// # Arguments
/// - `schema`: The AST schema to validate against.
/// - `node`: The node being checked.
/// - `expected`: The set of allowed types for this node, or `None` if type-checking is disabled.
/// - `parent_field`: Optional tuple of (parent_kind, field_name) for context in error messages.
///
/// # Returns
/// `Some(error_message)` if the node violates the schema (e.g., wrong kind, missing field declaration).
/// `None` if the node matches the expected types or if type-checking is disabled.
fn type_error_for_node(
    schema: &Schema,
    node: &Node,
    expected: Option<&[crate::schema::NodeType]>,
    parent_field: Option<(&str, &str)>,
) -> Option<String> {
    if schema.id_for_node_kind(node.kind_name()).is_none()
        && schema.id_for_unnamed_node_kind(node.kind_name()).is_none()
    {
        return Some(format!("node kind '{}' not in schema", node.kind_name()));
    }

    let expected = expected?;
    if expected.is_empty() {
        if let Some((kind, field)) = parent_field {
            return Some(format!("the node '{kind}' has no field '{field}'"));
        }
        return Some("field not declared in schema for this parent node".to_string());
    }
    if schema.node_matches_types(node.kind_name(), node.is_named(), expected) {
        None
    } else {
        let actual = if node.is_named() {
            node.kind_name().to_string()
        } else {
            format!("\"{}\"", node.kind_name())
        };

        if let Some((kind, field)) = parent_field {
            Some(format!(
                "The field {}.{} should contain {}, but got {}",
                kind,
                field,
                format_node_types(expected),
                actual
            ))
        } else {
            Some(format!(
                "expected {}, got {}",
                format_node_types(expected),
                actual
            ))
        }
    }
}

/// Look up the allowed types for a field in the schema.
///
/// # Arguments
/// - `schema`: The AST schema to query.
/// - `parent_kind`: The node kind of the parent that contains this field.
/// - `field_id`: The field ID within that parent node.
///
/// # Returns
/// `Some(&[NodeType])` if the field is declared in the schema and has type constraints.
/// `None` if the field is not declared or has no constraints (undeclared field).
fn expected_for_field<'a>(
    schema: &'a Schema,
    parent_kind: &str,
    field_name: &str,
) -> Option<&'a [crate::schema::NodeType]> {
    // Resolve the field NAME in the validation schema's own id space, so the
    // AST being dumped and the validation schema stay completely independent:
    // they need not share field ids, only field names.
    let field_id = schema.field_id_for_name(field_name)?;
    schema
        .field_types(parent_kind, field_id)
        .map(|v| v.as_slice())
}

fn dump_node(
    ast: &Ast,
    id: Id,
    source: &str,
    options: &DumpOptions,
    indent: usize,
    type_check: Option<TypeCheckContext<'_>>,
    out: &mut String,
) {
    let node = match ast.get_node(id) {
        Some(n) => n,
        None => return,
    };

    let prefix = "  ".repeat(indent);

    // Node kind
    write!(out, "{}{}", prefix, node.kind_name()).unwrap();

    // Location
    if options.show_locations {
        let start = node.start_position();
        let end = node.end_position();
        write!(
            out,
            " [{},{}]-[{},{}]",
            start.row + 1,
            start.column + 1,
            end.row + 1,
            end.column + 1
        )
        .unwrap();
    }

    // Content for leaf nodes
    if options.show_content && node.is_named() && is_leaf(node) {
        let content = node_content(node, source);
        if !content.is_empty() {
            write!(out, " {content:?}").unwrap();
        }
    }

    if options.show_abridged_source {
        write_source_skeleton(ast, node, source, out);
    }

    if let Some(context) = type_check {
        if let Some(err) =
            type_error_for_node(context.schema, node, context.expected, context.parent_field)
        {
            write!(out, " <-- ERROR: {err}").unwrap();
        }
    }

    writeln!(out).unwrap();

    // Named fields first, in the schema's declared order when available
    // (front-end-independent), else in field-id order. Any present fields not
    // covered by the declared order are appended in field-id order.
    //
    // The declared order lives in the validation schema, keyed by *its* field
    // ids; the AST being dumped may key the same field names under different
    // ids. So map the declared order through field NAMES into this AST's own id
    // space, keeping the two schemas independent (they share names, not ids).
    let named_field_ids: Vec<u16> = {
        let present: Vec<u16> = node
            .fields
            .keys()
            .copied()
            .filter(|&f| f != CHILD_FIELD)
            .collect();
        match type_check.and_then(|context| {
            context
                .schema
                .field_order(node.kind_name())
                .map(|order| (context.schema, order))
        }) {
            Some((schema, order)) => {
                let mut result: Vec<u16> = order
                    .iter()
                    .filter_map(|&f| schema.field_name_for_id(f))
                    .filter_map(|name| ast.field_id_for_name(name))
                    .filter(|&f| f != CHILD_FIELD && node.fields.contains_key(&f))
                    .collect();
                for &f in &present {
                    if !result.contains(&f) {
                        result.push(f);
                    }
                }
                result
            }
            None => present,
        }
    };
    for field_id in named_field_ids {
        let children = &node.fields[&field_id];
        let field_name = ast.field_name_for_id(field_id).unwrap_or("?");
        let child_type_check = type_check.map(|context| {
            let expected = expected_for_field(context.schema, node.kind_name(), field_name)
                .or(Some(EMPTY_NODE_TYPES));
            let parent_field = Some((node.kind_name(), field_name));
            TypeCheckContext {
                schema: context.schema,
                expected,
                parent_field,
            }
        });

        if children.len() == 1 {
            write!(out, "{prefix}  {field_name}:").unwrap();
            // Inline single child
            let child = ast.get_node(children[0]);
            if child.is_some_and(is_leaf) {
                write!(out, " ").unwrap();
                dump_node_inline(ast, children[0], source, options, child_type_check, out);
            } else {
                writeln!(out).unwrap();
                dump_node(
                    ast,
                    children[0],
                    source,
                    options,
                    indent + 2,
                    child_type_check,
                    out,
                );
            }
        } else {
            writeln!(out, "{prefix}  {field_name}:").unwrap();
            for &child_id in children {
                dump_node(
                    ast,
                    child_id,
                    source,
                    options,
                    indent + 2,
                    child_type_check,
                    out,
                );
            }
        }
    }

    // Check for required fields that are absent
    if let Some(context) = type_check {
        for (_field_id, field_name) in context.schema.required_fields_for_kind(node.kind_name()) {
            let present = match field_name {
                Some(n) => ast
                    .field_id_for_name(n)
                    .is_some_and(|fid| node.fields.contains_key(&fid)),
                None => node.fields.contains_key(&CHILD_FIELD),
            };
            if !present {
                let name = field_name.unwrap_or("child");
                writeln!(out, "{prefix}  <-- ERROR: missing required field '{name}'").unwrap();
            }
        }
    }

    // Unnamed children — skip unnamed tokens (keywords, punctuation)
    if let Some(children) = node.fields.get(&CHILD_FIELD) {
        let child_type_check = type_check.map(|context| {
            let expected = context
                .schema
                .field_types(node.kind_name(), CHILD_FIELD)
                .map(|v| v.as_slice())
                .or(Some(EMPTY_NODE_TYPES));
            let parent_field = Some((node.kind_name(), "children"));
            TypeCheckContext {
                schema: context.schema,
                expected,
                parent_field,
            }
        });
        for &child_id in children {
            if let Some(child) = ast.get_node(child_id) {
                if child.is_named() {
                    dump_node(
                        ast,
                        child_id,
                        source,
                        options,
                        indent + 1,
                        child_type_check,
                        out,
                    );
                }
            }
        }
    }
}

/// Dump a leaf node inline (no newline prefix, caller provides context).
fn dump_node_inline(
    ast: &Ast,
    id: Id,
    source: &str,
    options: &DumpOptions,
    type_check: Option<TypeCheckContext<'_>>,
    out: &mut String,
) {
    let node = match ast.get_node(id) {
        Some(n) => n,
        None => return,
    };

    write!(out, "{}", node.kind_name()).unwrap();

    if options.show_locations {
        let start = node.start_position();
        let end = node.end_position();
        write!(
            out,
            " [{},{}]-[{},{}]",
            start.row + 1,
            start.column + 1,
            end.row + 1,
            end.column + 1
        )
        .unwrap();
    }

    if options.show_content && node.is_named() {
        let content = node_content(node, source);
        if !content.is_empty() {
            write!(out, " {content:?}").unwrap();
        }
    }

    if options.show_abridged_source {
        write_source_skeleton(ast, node, source, out);
    }

    if let Some(context) = type_check {
        if let Some(err) =
            type_error_for_node(context.schema, node, context.expected, context.parent_field)
        {
            write!(out, " <-- ERROR: {err}").unwrap();
        }
    }

    writeln!(out).unwrap();
}

fn is_leaf(node: &Node) -> bool {
    node.fields.is_empty()
}

enum SourceSkeleton {
    Missing,
    Text(String),
    Invalid(String),
}

fn write_source_skeleton(ast: &Ast, node: &Node, source: &str, out: &mut String) {
    match source_skeleton(ast, node, source) {
        SourceSkeleton::Missing => write!(out, " source=<no location>").unwrap(),
        SourceSkeleton::Text(text) => write!(out, " source={text:?}").unwrap(),
        SourceSkeleton::Invalid(error) => write!(out, " source=<invalid: {error}>").unwrap(),
    }
}

fn node_source_range(node: &Node) -> Option<crate::Range> {
    match node.content {
        NodeContent::Range(range) => Some(range),
        _ => node.source_range,
    }
}

fn source_skeleton(ast: &Ast, node: &Node, source: &str) -> SourceSkeleton {
    let Some(parent) = node_source_range(node) else {
        return SourceSkeleton::Missing;
    };
    let parent = parent.start_byte..parent.end_byte;
    if parent.start > parent.end || source.get(parent.clone()).is_none() {
        return SourceSkeleton::Invalid(format!(
            "node range {}..{} is outside the source or not on UTF-8 boundaries",
            parent.start, parent.end
        ));
    }

    let mut children = Vec::new();
    for (field_id, child_ids) in &node.fields {
        let field_name = if *field_id == CHILD_FIELD {
            "child"
        } else {
            ast.field_name_for_id(*field_id).unwrap_or("?")
        };
        for child_id in child_ids {
            let Some(child) = ast.get_node(*child_id) else {
                continue;
            };
            if !child.is_named() {
                continue;
            }
            let Some(child) = node_source_range(child) else {
                continue;
            };
            let child = child.start_byte..child.end_byte;
            if child.start > child.end || source.get(child.clone()).is_none() {
                return SourceSkeleton::Invalid(format!(
                    "child range {}..{} is outside the source or not on UTF-8 boundaries",
                    child.start, child.end
                ));
            }
            if child.start < parent.start || child.end > parent.end {
                return SourceSkeleton::Invalid(format!(
                    "child range {}..{} is outside node range {}..{}",
                    child.start, child.end, parent.start, parent.end
                ));
            }
            if child.start == child.end {
                continue;
            }
            children.push((child, field_name));
        }
    }
    children.sort_by_key(|(range, field_name)| (range.start, range.end, *field_name));

    let mut result = String::new();
    let mut cursor = parent.start;
    for (range, field_name) in children {
        if cursor < range.start {
            result.push_str(source.get(cursor..range.start).unwrap());
        }
        result.push('⟨');
        result.push_str(field_name);
        result.push('⟩');
        cursor = cursor.max(range.end);
    }
    result.push_str(source.get(cursor..parent.end).unwrap());
    SourceSkeleton::Text(result)
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::{NodeContent, Point, Range};
    use std::collections::BTreeMap;

    fn range(start: usize, end: usize) -> Range {
        Range {
            start_byte: start,
            end_byte: end,
            start_point: Point::new(0, start),
            end_point: Point::new(0, end),
        }
    }

    fn dump_with_children(source: &str, parent_range: Range, children: &[(&str, Range)]) -> String {
        let mut ast = Ast::with_schema(crate::schema::Schema::new());
        let parent_kind = ast.register_kind("parent");
        let child_kind = ast.register_kind("child");
        let mut fields = BTreeMap::new();
        for (field_name, range) in children {
            let field = ast.register_field(field_name);
            let child = ast.create_node_with_range(
                child_kind,
                NodeContent::Range(*range),
                BTreeMap::new(),
                true,
                None,
            );
            fields.entry(field).or_insert_with(Vec::new).push(child);
        }
        let parent = ast.create_node_with_range(
            parent_kind,
            NodeContent::Range(parent_range),
            fields,
            true,
            None,
        );
        ast.set_root(parent);

        dump_ast_with_options(
            &ast,
            parent,
            source,
            &DumpOptions {
                show_locations: false,
                show_content: false,
                show_abridged_source: true,
            },
        )
    }

    #[test]
    fn source_skeleton_elides_direct_children_and_ignores_empty_ranges() {
        let source = "αbefore(child)afterω";
        let child_start = source.find("child").unwrap();
        let child_end = child_start + "child".len();
        let dump = dump_with_children(
            source,
            range(0, source.len()),
            &[
                ("value", range(child_start, child_end)),
                ("marker", range(child_start, child_start)),
            ],
        );

        assert!(dump.starts_with("parent source=\"αbefore(⟨value⟩)afterω\"\n"));
    }

    #[test]
    fn source_skeleton_preserves_unnamed_tokens() {
        let source = "x = 1";
        let runner: crate::Runner = crate::Runner::new(tree_sitter_ruby::LANGUAGE.into(), &[]);
        let ast = runner.run(source).unwrap();
        let dump = dump_ast_with_options(
            &ast,
            ast.get_root(),
            source,
            &DumpOptions {
                show_locations: false,
                show_content: false,
                show_abridged_source: true,
            },
        );

        assert!(dump.contains("assignment source=\"⟨left⟩ = ⟨right⟩\""));
    }

    #[test]
    fn source_skeleton_validates_empty_child_ranges() {
        let cases = [
            (
                "abcdef",
                range(0, 3),
                range(4, 4),
                "child range 4..4 is outside node range 0..3",
            ),
            (
                "abcdef",
                range(0, 6),
                range(7, 7),
                "child range 7..7 is outside the source or not on UTF-8 boundaries",
            ),
            (
                "αbc",
                range(0, 4),
                range(1, 1),
                "child range 1..1 is outside the source or not on UTF-8 boundaries",
            ),
        ];

        for (source, parent, child, error) in cases {
            let dump = dump_with_children(source, parent, &[("marker", child)]);
            assert!(
                dump.starts_with(&format!("parent source=<invalid: {error}>\n")),
                "unexpected dump: {dump}"
            );
        }
    }

    #[test]
    fn source_skeleton_keeps_adjacent_child_fields_separate() {
        let source = "abcdef";
        let dump = dump_with_children(
            source,
            range(0, source.len()),
            &[("left", range(1, 3)), ("right", range(3, 5))],
        );

        assert!(dump.starts_with("parent source=\"a⟨left⟩⟨right⟩f\"\n"));
    }

    #[test]
    fn source_skeleton_keeps_overlapping_child_fields_separate() {
        let source = "abcdef";
        let dump = dump_with_children(
            source,
            range(0, source.len()),
            &[("left", range(1, 4)), ("right", range(3, 5))],
        );

        assert!(dump.starts_with("parent source=\"a⟨left⟩⟨right⟩f\"\n"));
    }

    #[test]
    fn source_skeleton_reports_children_outside_the_parent() {
        let source = "abcdefghi";
        let dump = dump_with_children(source, range(0, 6), &[("child", range(7, 9))]);

        assert!(dump
            .starts_with("parent source=<invalid: child range 7..9 is outside node range 0..6>\n"));
    }
}

fn node_content(node: &Node, source: &str) -> String {
    match &node.content {
        NodeContent::DynamicString(s) if !s.is_empty() => s.clone(),
        _ => {
            let range = node.byte_range();
            if range.start < source.len() && range.end <= source.len() {
                source[range.start..range.end].to_string()
            } else {
                String::new()
            }
        }
    }
}

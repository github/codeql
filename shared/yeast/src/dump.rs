use std::fmt::Write;

use crate::{schema::Schema, Ast, Node, NodeContent, CHILD_FIELD};

/// Options for controlling AST dump output.
pub struct DumpOptions {
    /// Whether to include source locations in the output.
    pub show_locations: bool,
    /// Whether to include source text for leaf nodes.
    pub show_content: bool,
}

impl Default for DumpOptions {
    fn default() -> Self {
        Self {
            show_locations: false,
            show_content: true,
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
pub fn dump_ast(ast: &Ast, root: usize, source: &str) -> String {
    dump_ast_with_options(ast, root, source, &DumpOptions::default())
}

pub fn dump_ast_with_options(
    ast: &Ast,
    root: usize,
    source: &str,
    options: &DumpOptions,
) -> String {
    let mut out = String::new();
    dump_node(ast, root, source, options, 0, None, &mut out);
    out
}

/// Dump an AST and annotate type mismatches against a schema inline.
///
/// Any node that does not match the expected type set for its parent field is
/// rendered with a trailing `" <-- ERROR: ..."` annotation on the same line.
pub fn dump_ast_with_type_errors(
    ast: &Ast,
    root: usize,
    source: &str,
    schema: &Schema,
) -> String {
    dump_ast_with_type_errors_and_options(ast, root, source, schema, &DumpOptions::default())
}

/// Dump an AST and annotate type mismatches against a schema inline.
///
/// Any node that does not match the expected type set for its parent field is
/// rendered with a trailing `" <-- ERROR: ..."` annotation on the same line.
pub fn dump_ast_with_type_errors_and_options(
    ast: &Ast,
    root: usize,
    source: &str,
    schema: &Schema,
    options: &DumpOptions,
) -> String {
    let mut out = String::new();
    dump_node(ast, root, source, options, 0, Some((schema, None, None)), &mut out);
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
    field_id: u16,
) -> Option<&'a [crate::schema::NodeType]> {
    schema
        .field_types(parent_kind, field_id)
        .map(|v| v.as_slice())
}

fn dump_node(
    ast: &Ast,
    id: usize,
    source: &str,
    options: &DumpOptions,
    indent: usize,
    type_check: Option<(
        &Schema,
        Option<&[crate::schema::NodeType]>,
        Option<(&str, &str)>,
    )>,
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

    if let Some((schema, expected, parent_field)) = type_check {
        if let Some(err) = type_error_for_node(schema, node, expected, parent_field) {
            write!(out, " <-- ERROR: {err}").unwrap();
        }
    }

    writeln!(out).unwrap();

    // Named fields first
    for (&field_id, children) in &node.fields {
        if field_id == CHILD_FIELD {
            continue; // Handle unnamed children last
        }
        let field_name = ast.field_name_for_id(field_id).unwrap_or("?");
        let child_type_check = type_check.map(|(schema, _, _)| {
            let expected = expected_for_field(schema, node.kind_name(), field_id)
                .or(Some(EMPTY_NODE_TYPES));
            let parent_field = Some((node.kind_name(), field_name));
            (schema, expected, parent_field)
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
    if let Some((schema, _, _)) = type_check {
        for (field_id, field_name) in schema.required_fields_for_kind(node.kind_name()) {
            if !node.fields.contains_key(&field_id) {
                let name = field_name.unwrap_or("child");
                writeln!(out, "{prefix}  <-- ERROR: missing required field '{name}'").unwrap();
            }
        }
    }

    // Unnamed children — skip unnamed tokens (keywords, punctuation)
    if let Some(children) = node.fields.get(&CHILD_FIELD) {
        let child_type_check = type_check.map(|(schema, _, _)| {
            let expected = expected_for_field(schema, node.kind_name(), CHILD_FIELD)
                .or(Some(EMPTY_NODE_TYPES));
            let parent_field = Some((node.kind_name(), "children"));
            (schema, expected, parent_field)
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
    id: usize,
    source: &str,
    options: &DumpOptions,
    type_check: Option<(
        &Schema,
        Option<&[crate::schema::NodeType]>,
        Option<(&str, &str)>,
    )>,
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

    if let Some((schema, expected, parent_field)) = type_check {
        if let Some(err) = type_error_for_node(schema, node, expected, parent_field) {
            write!(out, " <-- ERROR: {err}").unwrap();
        }
    }

    writeln!(out).unwrap();
}

fn is_leaf(node: &Node) -> bool {
    node.fields.is_empty()
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

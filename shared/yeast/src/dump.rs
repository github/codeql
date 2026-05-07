use std::fmt::Write;

use crate::{Ast, Node, NodeContent, CHILD_FIELD};

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
    dump_node(ast, root, source, options, 0, &mut out);
    out
}

fn dump_node(
    ast: &Ast,
    id: usize,
    source: &str,
    options: &DumpOptions,
    indent: usize,
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

    writeln!(out).unwrap();

    // Named fields first
    for (&field_id, children) in &node.fields {
        if field_id == CHILD_FIELD {
            continue; // Handle unnamed children last
        }
        let field_name = ast.field_name_for_id(field_id).unwrap_or("?");
        if children.len() == 1 {
            write!(out, "{prefix}  {field_name}:").unwrap();
            // Inline single child
            let child = ast.get_node(children[0]);
            if child.is_some_and(is_leaf) {
                write!(out, " ").unwrap();
                dump_node_inline(ast, children[0], source, options, out);
            } else {
                writeln!(out).unwrap();
                dump_node(ast, children[0], source, options, indent + 2, out);
            }
        } else {
            writeln!(out, "{prefix}  {field_name}:").unwrap();
            for &child_id in children {
                dump_node(ast, child_id, source, options, indent + 2, out);
            }
        }
    }

    // Unnamed children — skip unnamed tokens (keywords, punctuation)
    if let Some(children) = node.fields.get(&CHILD_FIELD) {
        for &child_id in children {
            if let Some(child) = ast.get_node(child_id) {
                if child.is_named() {
                    dump_node(ast, child_id, source, options, indent + 1, out);
                }
            }
        }
    }
}

/// Dump a leaf node inline (no newline prefix, caller provides context).
fn dump_node_inline(ast: &Ast, id: usize, source: &str, options: &DumpOptions, out: &mut String) {
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

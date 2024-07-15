use crate::diagnostics;
use crate::file_paths;
use crate::node_types::{self, EntryKind, Field, NodeTypeMap, Storage, TypeName};
use crate::trap;
use std::collections::BTreeMap as Map;
use std::collections::BTreeSet as Set;
use std::env;
use std::path::Path;

use tree_sitter::{Language, Node, Parser, Range, Tree};

pub mod simple;

/// Sets the tracing level based on the environment variables
/// `RUST_LOG` and `CODEQL_VERBOSITY` (prioritized in that order),
/// falling back to `warn` if neither is set.
pub fn set_tracing_level(language: &str) {
    tracing_subscriber::fmt()
        .with_target(false)
        .without_time()
        .with_level(true)
        .with_env_filter(
            tracing_subscriber::EnvFilter::try_from_default_env().unwrap_or_else(
                |_| -> tracing_subscriber::EnvFilter {
                    let verbosity = env::var("CODEQL_VERBOSITY")
                        .map(|v| match v.to_lowercase().as_str() {
                            "off" | "errors" => "error",
                            "warnings" => "warn",
                            "info" | "progress" => "info",
                            "debug" | "progress+" => "debug",
                            "trace" | "progress++" | "progress+++" => "trace",
                            _ => "warn",
                        })
                        .unwrap_or_else(|_| "warn");
                    tracing_subscriber::EnvFilter::new(format!(
                        "{language}_extractor={verbosity},codeql_extractor={verbosity}"
                    ))
                },
            ),
        )
        .init();
}

pub fn populate_file(writer: &mut trap::Writer, absolute_path: &Path) -> trap::Label {
    let (file_label, fresh) = writer.global_id(&trap::full_id_for_file(
        &file_paths::normalize_path(absolute_path),
    ));
    if fresh {
        writer.add_tuple(
            "files",
            vec![
                trap::Arg::Label(file_label),
                trap::Arg::String(file_paths::normalize_path(absolute_path)),
            ],
        );
        populate_parent_folders(writer, file_label, absolute_path.parent());
    }
    file_label
}

fn populate_empty_file(writer: &mut trap::Writer) -> trap::Label {
    let (file_label, fresh) = writer.global_id("empty;sourcefile");
    if fresh {
        writer.add_tuple(
            "files",
            vec![
                trap::Arg::Label(file_label),
                trap::Arg::String("".to_string()),
            ],
        );
    }
    file_label
}

pub fn populate_empty_location(writer: &mut trap::Writer) {
    let file_label = populate_empty_file(writer);
    let loc_label = global_location(
        writer,
        file_label,
        trap::Location {
            start_line: 0,
            start_column: 0,
            end_line: 0,
            end_column: 0,
        },
    );
    writer.add_tuple("empty_location", vec![trap::Arg::Label(loc_label)]);
}

pub fn populate_parent_folders(
    writer: &mut trap::Writer,
    child_label: trap::Label,
    path: Option<&Path>,
) {
    let mut path = path;
    let mut child_label = child_label;
    loop {
        match path {
            None => break,
            Some(folder) => {
                let (folder_label, fresh) = writer.global_id(&trap::full_id_for_folder(
                    &file_paths::normalize_path(folder),
                ));
                writer.add_tuple(
                    "containerparent",
                    vec![
                        trap::Arg::Label(folder_label),
                        trap::Arg::Label(child_label),
                    ],
                );
                if fresh {
                    writer.add_tuple(
                        "folders",
                        vec![
                            trap::Arg::Label(folder_label),
                            trap::Arg::String(file_paths::normalize_path(folder)),
                        ],
                    );
                    path = folder.parent();
                    child_label = folder_label;
                } else {
                    break;
                }
            }
        }
    }
}

/** Get the label for the given location, defining it a global ID if it doesn't exist yet. */
fn global_location(
    writer: &mut trap::Writer,
    file_label: trap::Label,
    location: trap::Location,
) -> trap::Label {
    let (loc_label, fresh) = writer.global_id(&format!(
        "loc,{{{}}},{},{},{},{}",
        file_label,
        location.start_line,
        location.start_column,
        location.end_line,
        location.end_column
    ));
    if fresh {
        writer.add_tuple(
            "locations_default",
            vec![
                trap::Arg::Label(loc_label),
                trap::Arg::Label(file_label),
                trap::Arg::Int(location.start_line),
                trap::Arg::Int(location.start_column),
                trap::Arg::Int(location.end_line),
                trap::Arg::Int(location.end_column),
            ],
        );
    }
    loc_label
}

/** Get the label for the given location, creating it as a fresh ID if we haven't seen the location
 * yet for this file. */
fn location_label(
    writer: &mut trap::Writer,
    file_label: trap::Label,
    location: trap::Location,
) -> trap::Label {
    let (loc_label, fresh) = writer.location_label(location);
    if fresh {
        writer.add_tuple(
            "locations_default",
            vec![
                trap::Arg::Label(loc_label),
                trap::Arg::Label(file_label),
                trap::Arg::Int(location.start_line),
                trap::Arg::Int(location.start_column),
                trap::Arg::Int(location.end_line),
                trap::Arg::Int(location.end_column),
            ],
        );
    }
    loc_label
}

/// Extracts the source file at `path`, which is assumed to be canonicalized.
pub fn extract(
    language: &Language,
    language_prefix: &str,
    schema: &NodeTypeMap,
    diagnostics_writer: &mut diagnostics::LogWriter,
    trap_writer: &mut trap::Writer,
    path: &Path,
    source: &[u8],
    ranges: &[Range],
) {
    let path_str = file_paths::normalize_path(path);
    let span = tracing::span!(
        tracing::Level::TRACE,
        "extract",
        file = %path_str
    );

    let _enter = span.enter();

    tracing::info!("extracting: {}", path_str);

    let mut parser = Parser::new();
    parser.set_language(language).unwrap();
    parser.set_included_ranges(ranges).unwrap();
    let tree = parser.parse(source, None).expect("Failed to parse file");
    trap_writer.comment(format!("Auto-generated TRAP file for {}", path_str));
    let file_label = populate_file(trap_writer, path);
    let mut visitor = Visitor::new(
        source,
        diagnostics_writer,
        trap_writer,
        // TODO: should we handle path strings that are not valid UTF8 better?
        &path_str,
        file_label,
        language_prefix,
        schema,
    );
    traverse(&tree, &mut visitor);

    parser.reset();
}

struct ChildNode {
    field_name: Option<&'static str>,
    label: trap::Label,
    type_name: TypeName,
}

struct Visitor<'a> {
    /// The file path of the source code (as string)
    path: &'a str,
    /// The label to use whenever we need to refer to the `@file` entity of this
    /// source file.
    file_label: trap::Label,
    /// The source code as a UTF-8 byte array
    source: &'a [u8],
    /// A diagnostics::LogWriter to write diagnostic messages
    diagnostics_writer: &'a mut diagnostics::LogWriter,
    /// A trap::Writer to accumulate trap entries
    trap_writer: &'a mut trap::Writer,
    /// Language-specific name of the AST location table
    ast_node_location_table_name: String,
    /// Language-specific name of the AST parent table
    ast_node_parent_table_name: String,
    /// Language-specific name of the tokeninfo table
    tokeninfo_table_name: String,
    /// A lookup table from type name to node types
    schema: &'a NodeTypeMap,
    /// A stack for gathering information from child nodes. Whenever a node is
    /// entered the parent's [Label], child counter, and an empty list is pushed.
    /// All children append their data to the list. When the visitor leaves a
    /// node the list containing the child data is popped from the stack and
    /// matched against the dbscheme for the node. If the expectations are met
    /// the corresponding row definitions are added to the trap_output.
    stack: Vec<(trap::Label, usize, Vec<ChildNode>)>,
}

impl<'a> Visitor<'a> {
    fn new(
        source: &'a [u8],
        diagnostics_writer: &'a mut diagnostics::LogWriter,
        trap_writer: &'a mut trap::Writer,
        path: &'a str,
        file_label: trap::Label,
        language_prefix: &str,
        schema: &'a NodeTypeMap,
    ) -> Visitor<'a> {
        Visitor {
            path,
            file_label,
            source,
            diagnostics_writer,
            trap_writer,
            ast_node_location_table_name: format!("{}_ast_node_location", language_prefix),
            ast_node_parent_table_name: format!("{}_ast_node_parent", language_prefix),
            tokeninfo_table_name: format!("{}_tokeninfo", language_prefix),
            schema,
            stack: Vec::new(),
        }
    }

    fn record_parse_error(&mut self, loc: trap::Label, mesg: &diagnostics::DiagnosticMessage) {
        self.diagnostics_writer.write(mesg);
        let id = self.trap_writer.fresh_id();
        let full_error_message = mesg.full_error_message();
        let severity_code = match mesg.severity {
            Some(diagnostics::Severity::Error) => 40,
            Some(diagnostics::Severity::Warning) => 30,
            Some(diagnostics::Severity::Note) => 20,
            None => 10,
        };
        self.trap_writer.add_tuple(
            "diagnostics",
            vec![
                trap::Arg::Label(id),
                trap::Arg::Int(severity_code),
                trap::Arg::String("parse_error".to_string()),
                trap::Arg::String(mesg.plaintext_message.to_owned()),
                trap::Arg::String(full_error_message),
                trap::Arg::Label(loc),
            ],
        );
    }

    fn record_parse_error_for_node(
        &mut self,
        message: &str,
        args: &[diagnostics::MessageArg],
        node: Node,
        status_page: bool,
    ) {
        let loc = location_for(self, node);
        let loc_label = location_label(self.trap_writer, self.file_label, loc);
        let mut mesg = self.diagnostics_writer.new_entry(
            "parse-error",
            "Could not process some files due to syntax errors",
        );
        mesg.severity(diagnostics::Severity::Warning)
            .location(
                self.path,
                loc.start_line,
                loc.start_column,
                loc.end_line,
                loc.end_column,
            )
            .message(message, args);
        if status_page {
            mesg.status_page();
        }
        self.record_parse_error(loc_label, &mesg);
    }

    fn enter_node(&mut self, node: Node) -> bool {
        if node.is_missing() {
            self.record_parse_error_for_node(
                "A parse error occurred (expected {} symbol). Check the syntax of the file. If the file is invalid, correct the error or {} the file from analysis.",
                &[diagnostics::MessageArg::Code(node.kind()), diagnostics::MessageArg::Link("exclude", "https://docs.github.com/en/code-security/code-scanning/automatically-scanning-your-code-for-vulnerabilities-and-errors/customizing-code-scanning")],
                node,
                true,
            );
            return false;
        }
        if node.is_error() {
            self.record_parse_error_for_node(
                "A parse error occurred. Check the syntax of the file. If the file is invalid, correct the error or {} the file from analysis.",
                &[diagnostics::MessageArg::Link("exclude", "https://docs.github.com/en/code-security/code-scanning/automatically-scanning-your-code-for-vulnerabilities-and-errors/customizing-code-scanning")],
                node,
                true,
            );
            return false;
        };

        let id = self.trap_writer.fresh_id();

        self.stack.push((id, 0, Vec::new()));
        true
    }

    fn leave_node(&mut self, field_name: Option<&'static str>, node: Node) {
        if node.is_error() || node.is_missing() {
            return;
        }
        let (id, _, child_nodes) = self.stack.pop().expect("Vistor: empty stack");
        let loc = location_for(self, node);
        let loc_label = location_label(self.trap_writer, self.file_label, loc);
        let table = self
            .schema
            .get(&TypeName {
                kind: node.kind().to_owned(),
                named: node.is_named(),
            })
            .unwrap();
        let mut valid = true;
        let parent_info = match self.stack.last_mut() {
            Some(p) if !node.is_extra() => {
                p.1 += 1;
                Some((p.0, p.1 - 1))
            }
            _ => None,
        };
        match &table.kind {
            EntryKind::Token { kind_id, .. } => {
                self.trap_writer.add_tuple(
                    &self.ast_node_location_table_name,
                    vec![trap::Arg::Label(id), trap::Arg::Label(loc_label)],
                );
                if let Some((parent_id, parent_index)) = parent_info {
                    self.trap_writer.add_tuple(
                        &self.ast_node_parent_table_name,
                        vec![
                            trap::Arg::Label(id),
                            trap::Arg::Label(parent_id),
                            trap::Arg::Int(parent_index),
                        ],
                    );
                };
                self.trap_writer.add_tuple(
                    &self.tokeninfo_table_name,
                    vec![
                        trap::Arg::Label(id),
                        trap::Arg::Int(*kind_id),
                        sliced_source_arg(self.source, node),
                    ],
                );
            }
            EntryKind::Table {
                fields,
                name: table_name,
            } => {
                if let Some(args) = self.complex_node(&node, fields, &child_nodes, id) {
                    self.trap_writer.add_tuple(
                        &self.ast_node_location_table_name,
                        vec![trap::Arg::Label(id), trap::Arg::Label(loc_label)],
                    );
                    if let Some((parent_id, parent_index)) = parent_info {
                        self.trap_writer.add_tuple(
                            &self.ast_node_parent_table_name,
                            vec![
                                trap::Arg::Label(id),
                                trap::Arg::Label(parent_id),
                                trap::Arg::Int(parent_index),
                            ],
                        );
                    };
                    let mut all_args = vec![trap::Arg::Label(id)];
                    all_args.extend(args);
                    self.trap_writer.add_tuple(table_name, all_args);
                }
            }
            _ => {
                self.record_parse_error(
                    loc_label,
                    self.diagnostics_writer
                        .new_entry(
                            "parse-error",
                            "Could not process some files due to syntax errors",
                        )
                        .severity(diagnostics::Severity::Warning)
                        .location(
                            self.path,
                            loc.start_line,
                            loc.start_column,
                            loc.end_line,
                            loc.end_column,
                        )
                        .message(
                            "Unknown table type: {}",
                            &[diagnostics::MessageArg::Code(node.kind())],
                        ),
                );

                valid = false;
            }
        }
        if valid && !node.is_extra() {
            // Extra nodes are independent root nodes and do not belong to the parent node
            // Therefore we should not register them in the parent vector
            if let Some(parent) = self.stack.last_mut() {
                parent.2.push(ChildNode {
                    field_name,
                    label: id,
                    type_name: TypeName {
                        kind: node.kind().to_owned(),
                        named: node.is_named(),
                    },
                });
            };
        }
    }

    fn complex_node(
        &mut self,
        node: &Node,
        fields: &[Field],
        child_nodes: &[ChildNode],
        parent_id: trap::Label,
    ) -> Option<Vec<trap::Arg>> {
        let mut map: Map<&Option<String>, (&Field, Vec<trap::Arg>)> = Map::new();
        for field in fields {
            map.insert(&field.name, (field, Vec::new()));
        }
        for child_node in child_nodes {
            if let Some((field, values)) = map.get_mut(&child_node.field_name.map(|x| x.to_owned()))
            {
                //TODO: handle error and missing nodes
                if self.type_matches(&child_node.type_name, &field.type_info) {
                    if let node_types::FieldTypeInfo::ReservedWordInt(int_mapping) =
                        &field.type_info
                    {
                        // We can safely unwrap because type_matches checks the key is in the map.
                        let (int_value, _) = int_mapping.get(&child_node.type_name.kind).unwrap();
                        values.push(trap::Arg::Int(*int_value));
                    } else {
                        values.push(trap::Arg::Label(child_node.label));
                    }
                } else if field.name.is_some() {
                    self.record_parse_error_for_node(
                        "Type mismatch for field {}::{} with type {} != {}",
                        &[
                            diagnostics::MessageArg::Code(node.kind()),
                            diagnostics::MessageArg::Code(child_node.field_name.unwrap_or("child")),
                            diagnostics::MessageArg::Code(&format!("{:?}", child_node.type_name)),
                            diagnostics::MessageArg::Code(&format!("{:?}", field.type_info)),
                        ],
                        *node,
                        false,
                    );
                }
            } else if child_node.field_name.is_some() || child_node.type_name.named {
                self.record_parse_error_for_node(
                    "Value for unknown field: {}::{} and type {}",
                    &[
                        diagnostics::MessageArg::Code(node.kind()),
                        diagnostics::MessageArg::Code(child_node.field_name.unwrap_or("child")),
                        diagnostics::MessageArg::Code(&format!("{:?}", child_node.type_name)),
                    ],
                    *node,
                    false,
                );
            }
        }
        let mut args = Vec::new();
        let mut is_valid = true;
        for field in fields {
            let child_values = &map.get(&field.name).unwrap().1;
            match &field.storage {
                Storage::Column { name: column_name } => {
                    if child_values.len() == 1 {
                        args.push(child_values.first().unwrap().clone());
                    } else {
                        is_valid = false;
                        let error_message = format!(
                            "{} for field: {}::{}",
                            if child_values.is_empty() {
                                "Missing value"
                            } else {
                                "Too many values"
                            },
                            node.kind(),
                            column_name
                        );
                        self.record_parse_error_for_node(&error_message, &[], *node, false);
                    }
                }
                Storage::Table {
                    name: table_name,
                    has_index,
                    column_name: _,
                } => {
                    for (index, child_value) in child_values.iter().enumerate() {
                        if !*has_index && index > 0 {
                            self.record_parse_error_for_node(
                                "Too many values for field: {}::{}",
                                &[
                                    diagnostics::MessageArg::Code(node.kind()),
                                    diagnostics::MessageArg::Code(table_name),
                                ],
                                *node,
                                false,
                            );
                            break;
                        }
                        let mut args = vec![trap::Arg::Label(parent_id)];
                        if *has_index {
                            args.push(trap::Arg::Int(index))
                        }
                        args.push(child_value.clone());
                        self.trap_writer.add_tuple(table_name, args);
                    }
                }
            }
        }
        if is_valid {
            Some(args)
        } else {
            None
        }
    }

    fn type_matches(&self, tp: &TypeName, type_info: &node_types::FieldTypeInfo) -> bool {
        match type_info {
            node_types::FieldTypeInfo::Single(single_type) => {
                if tp == single_type {
                    return true;
                }
                if let EntryKind::Union { members } = &self.schema.get(single_type).unwrap().kind {
                    if self.type_matches_set(tp, members) {
                        return true;
                    }
                }
            }
            node_types::FieldTypeInfo::Multiple { types, .. } => {
                return self.type_matches_set(tp, types);
            }

            node_types::FieldTypeInfo::ReservedWordInt(int_mapping) => {
                return !tp.named && int_mapping.contains_key(&tp.kind)
            }
        }
        false
    }

    fn type_matches_set(&self, tp: &TypeName, types: &Set<TypeName>) -> bool {
        if types.contains(tp) {
            return true;
        }
        for other in types.iter() {
            if let EntryKind::Union { members } = &self.schema.get(other).unwrap().kind {
                if self.type_matches_set(tp, members) {
                    return true;
                }
            }
        }
        false
    }
}

// Emit a slice of a source file as an Arg.
fn sliced_source_arg(source: &[u8], n: Node) -> trap::Arg {
    let range = n.byte_range();
    trap::Arg::String(String::from_utf8_lossy(&source[range.start..range.end]).into_owned())
}

// Emit a pair of `TrapEntry`s for the provided node, appropriately calibrated.
// The first is the location and label definition, and the second is the
// 'Located' entry.
fn location_for(visitor: &mut Visitor, n: Node) -> trap::Location {
    // Tree-sitter row, column values are 0-based while CodeQL starts
    // counting at 1. In addition Tree-sitter's row and column for the
    // end position are exclusive while CodeQL's end positions are inclusive.
    // This means that all values should be incremented by 1 and in addition the
    // end position needs to be shift 1 to the left. In most cases this means
    // simply incrementing all values except the end column except in cases where
    // the end column is 0 (start of a line). In such cases the end position must be
    // set to the end of the previous line.
    let start_line = n.start_position().row + 1;
    let start_column = n.start_position().column + 1;
    let mut end_line = n.end_position().row + 1;
    let mut end_column = n.end_position().column;
    if start_line > end_line || start_line == end_line && start_column > end_column {
        // the range is empty, clip it to sensible values
        end_line = start_line;
        end_column = start_column - 1;
    } else if end_column == 0 {
        let source = visitor.source;
        // end_column = 0 means that we are at the start of a line
        // unfortunately 0 is invalid as column number, therefore
        // we should update the end location to be the end of the
        // previous line
        let mut index = n.end_byte();
        if index > 0 && index <= source.len() {
            index -= 1;
            if source[index] != b'\n' {
                visitor.diagnostics_writer.write(
                    visitor
                        .diagnostics_writer
                        .new_entry("internal-error", "Internal error")
                        .message("Expecting a line break symbol, but none found while correcting end column value", &[])
                        .severity(diagnostics::Severity::Error),
                );
            }
            end_line -= 1;
            end_column = 1;
            while index > 0 && source[index - 1] != b'\n' {
                index -= 1;
                end_column += 1;
            }
        } else {
            visitor.diagnostics_writer.write(
                visitor
                    .diagnostics_writer
                    .new_entry("internal-error", "Internal error")
                    .message(
                        "Cannot correct end column value: end_byte index {} is not in range [1,{}].",
                        &[
                            diagnostics::MessageArg::Code(&index.to_string()),
                            diagnostics::MessageArg::Code(&source.len().to_string()),
                        ],
                    )
                    .severity(diagnostics::Severity::Error),
            );
        }
    }
    trap::Location {
        start_line,
        start_column,
        end_line,
        end_column,
    }
}

fn traverse(tree: &Tree, visitor: &mut Visitor) {
    let cursor = &mut tree.walk();
    visitor.enter_node(cursor.node());
    let mut recurse = true;
    loop {
        if recurse && cursor.goto_first_child() {
            recurse = visitor.enter_node(cursor.node());
        } else {
            visitor.leave_node(cursor.field_name(), cursor.node());

            if cursor.goto_next_sibling() {
                recurse = visitor.enter_node(cursor.node());
            } else if cursor.goto_parent() {
                recurse = false;
            } else {
                break;
            }
        }
    }
}

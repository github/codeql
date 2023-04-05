pub mod dbscheme;
pub mod language;
pub mod ql;
pub mod ql_gen;

use std::collections::BTreeMap as Map;
use std::collections::BTreeSet as Set;

use crate::node_types;

/// Given the name of the parent node, and its field information, returns a pair,
/// the first of which is the field's type. The second is an optional dbscheme
/// entry that should be added.
fn make_field_type<'a>(
    parent_name: &'a str,
    field: &'a node_types::Field,
    nodes: &'a node_types::NodeTypeMap,
) -> (ql::Type<'a>, Option<dbscheme::Entry<'a>>) {
    match &field.type_info {
        node_types::FieldTypeInfo::Multiple {
            types,
            dbscheme_union,
            ql_class: _,
        } => {
            // This field can have one of several types. Create an ad-hoc QL union
            // type to represent them.
            let members: Set<&str> = types
                .iter()
                .map(|t| nodes.get(t).unwrap().dbscheme_name.as_str())
                .collect();
            (
                ql::Type::At(dbscheme_union),
                Some(dbscheme::Entry::Union(dbscheme::Union {
                    name: dbscheme_union,
                    members,
                })),
            )
        }
        node_types::FieldTypeInfo::Single(t) => {
            let dbscheme_name = &nodes.get(t).unwrap().dbscheme_name;
            (ql::Type::At(dbscheme_name), None)
        }
        node_types::FieldTypeInfo::ReservedWordInt(int_mapping) => {
            // The field will be an `int` in the db, and we add a case split to
            // create other db types for each integer value.
            let mut branches: Vec<(usize, &'a str)> = Vec::new();
            for (value, name) in int_mapping.values() {
                branches.push((*value, name));
            }
            let case = dbscheme::Entry::Case(dbscheme::Case {
                name: parent_name,
                column: match &field.storage {
                    node_types::Storage::Column { name } => name,
                    node_types::Storage::Table { name, .. } => name,
                },
                branches,
            });
            (ql::Type::Int, Some(case))
        }
    }
}

fn add_field_for_table_storage<'a>(
    field: &'a node_types::Field,
    table_name: &'a str,
    column_name: &'a str,
    has_index: bool,
    nodes: &'a node_types::NodeTypeMap,
) -> (dbscheme::Table<'a>, Option<dbscheme::Entry<'a>>) {
    let parent_name = &nodes.get(&field.parent).unwrap().dbscheme_name;
    // This field can appear zero or multiple times, so put
    // it in an auxiliary table.
    let (field_ql_type, field_type_entry) = make_field_type(parent_name, field, nodes);
    let parent_column = dbscheme::Column {
        unique: !has_index,
        db_type: dbscheme::DbColumnType::Int,
        name: parent_name,
        ql_type: ql::Type::At(parent_name),
        ql_type_is_ref: true,
    };
    let index_column = dbscheme::Column {
        unique: false,
        db_type: dbscheme::DbColumnType::Int,
        name: "index",
        ql_type: ql::Type::Int,
        ql_type_is_ref: true,
    };
    let field_column = dbscheme::Column {
        unique: true,
        db_type: dbscheme::DbColumnType::Int,
        name: column_name,
        ql_type: field_ql_type,
        ql_type_is_ref: true,
    };
    let field_table = dbscheme::Table {
        name: table_name,
        columns: if has_index {
            vec![parent_column, index_column, field_column]
        } else {
            vec![parent_column, field_column]
        },
        // In addition to the field being unique, the combination of
        // parent+index is unique, so add a keyset for them.
        keysets: if has_index {
            Some(vec![parent_name, "index"])
        } else {
            None
        },
    };
    (field_table, field_type_entry)
}

fn add_field_for_column_storage<'a>(
    parent_name: &'a str,
    field: &'a node_types::Field,
    column_name: &'a str,
    nodes: &'a node_types::NodeTypeMap,
) -> (dbscheme::Column<'a>, Option<dbscheme::Entry<'a>>) {
    // This field must appear exactly once, so we add it as
    // a column to the main table for the node type.
    let (field_ql_type, field_type_entry) = make_field_type(parent_name, field, nodes);
    (
        dbscheme::Column {
            unique: false,
            db_type: dbscheme::DbColumnType::Int,
            name: column_name,
            ql_type: field_ql_type,
            ql_type_is_ref: true,
        },
        field_type_entry,
    )
}

/// Converts the given tree-sitter node types into CodeQL dbscheme entries.
/// Returns a tuple containing:
///
/// 1. A vector of dbscheme entries.
/// 2. A set of names of the members of the `<lang>_ast_node` union.
/// 3. A map where the keys are the dbscheme names for token kinds, and the
/// values are their integer representations.
pub fn convert_nodes(
    nodes: &node_types::NodeTypeMap,
) -> (Vec<dbscheme::Entry>, Set<&str>, Map<&str, usize>) {
    let mut entries: Vec<dbscheme::Entry> = Vec::new();
    let mut ast_node_members: Set<&str> = Set::new();
    let token_kinds: Map<&str, usize> = nodes
        .iter()
        .filter_map(|(_, node)| match &node.kind {
            node_types::EntryKind::Token { kind_id } => {
                Some((node.dbscheme_name.as_str(), *kind_id))
            }
            _ => None,
        })
        .collect();
    for node in nodes.values() {
        match &node.kind {
            node_types::EntryKind::Union { members: n_members } => {
                // It's a tree-sitter supertype node, for which we create a union
                // type.
                let members: Set<&str> = n_members
                    .iter()
                    .map(|n| nodes.get(n).unwrap().dbscheme_name.as_str())
                    .collect();
                entries.push(dbscheme::Entry::Union(dbscheme::Union {
                    name: &node.dbscheme_name,
                    members,
                }));
            }
            node_types::EntryKind::Table { name, fields } => {
                // It's a product type, defined by a table.
                let mut main_table = dbscheme::Table {
                    name,
                    columns: vec![dbscheme::Column {
                        db_type: dbscheme::DbColumnType::Int,
                        name: "id",
                        unique: true,
                        ql_type: ql::Type::At(&node.dbscheme_name),
                        ql_type_is_ref: false,
                    }],
                    keysets: None,
                };
                ast_node_members.insert(&node.dbscheme_name);

                // If the type also has fields or children, then we create either
                // auxiliary tables or columns in the defining table for them.
                for field in fields {
                    match &field.storage {
                        node_types::Storage::Column { name: column_name } => {
                            let (field_column, field_type_entry) = add_field_for_column_storage(
                                &node.dbscheme_name,
                                field,
                                column_name,
                                nodes,
                            );
                            if let Some(field_type_entry) = field_type_entry {
                                entries.push(field_type_entry);
                            }
                            main_table.columns.push(field_column);
                        }
                        node_types::Storage::Table {
                            name,
                            has_index,
                            column_name,
                        } => {
                            let (field_table, field_type_entry) = add_field_for_table_storage(
                                field,
                                name,
                                column_name,
                                *has_index,
                                nodes,
                            );
                            if let Some(field_type_entry) = field_type_entry {
                                entries.push(field_type_entry);
                            }
                            entries.push(dbscheme::Entry::Table(field_table));
                        }
                    }
                }

                if fields.is_empty() {
                    // There were no fields and no children, so it's a leaf node in
                    // the TS grammar. Add a column for the node text.
                    main_table.columns.push(dbscheme::Column {
                        unique: false,
                        db_type: dbscheme::DbColumnType::String,
                        name: "text",
                        ql_type: ql::Type::String,
                        ql_type_is_ref: true,
                    });
                }

                entries.push(dbscheme::Entry::Table(main_table));
            }
            node_types::EntryKind::Token { .. } => {}
        }
    }

    (entries, ast_node_members, token_kinds)
}

/// Creates a dbscheme table specifying the parent node and location for each
/// AST node.
///
/// # Arguments
/// - `name` - the name of the table to create.
/// - `parent_name` - the name of the parent type.
/// - `ast_node_name` - the name of the node child type.
pub fn create_ast_node_info_table<'a>(
    name: &'a str,
    parent_name: &'a str,
    ast_node_name: &'a str,
) -> dbscheme::Table<'a> {
    dbscheme::Table {
        name,
        columns: vec![
            dbscheme::Column {
                db_type: dbscheme::DbColumnType::Int,
                name: "node",
                unique: true,
                ql_type: ql::Type::At(ast_node_name),
                ql_type_is_ref: true,
            },
            dbscheme::Column {
                db_type: dbscheme::DbColumnType::Int,
                name: "parent",
                unique: false,
                ql_type: ql::Type::At(parent_name),
                ql_type_is_ref: true,
            },
            dbscheme::Column {
                unique: false,
                db_type: dbscheme::DbColumnType::Int,
                name: "parent_index",
                ql_type: ql::Type::Int,
                ql_type_is_ref: true,
            },
            dbscheme::Column {
                unique: false,
                db_type: dbscheme::DbColumnType::Int,
                name: "loc",
                ql_type: ql::Type::At("location"),
                ql_type_is_ref: true,
            },
        ],
        keysets: Some(vec!["parent", "parent_index"]),
    }
}

pub fn create_tokeninfo<'a>(name: &'a str, type_name: &'a str) -> dbscheme::Table<'a> {
    dbscheme::Table {
        name,
        keysets: None,
        columns: vec![
            dbscheme::Column {
                db_type: dbscheme::DbColumnType::Int,
                name: "id",
                unique: true,
                ql_type: ql::Type::At(type_name),
                ql_type_is_ref: false,
            },
            dbscheme::Column {
                unique: false,
                db_type: dbscheme::DbColumnType::Int,
                name: "kind",
                ql_type: ql::Type::Int,
                ql_type_is_ref: true,
            },
            dbscheme::Column {
                unique: false,
                db_type: dbscheme::DbColumnType::String,
                name: "value",
                ql_type: ql::Type::String,
                ql_type_is_ref: true,
            },
        ],
    }
}

pub fn create_token_case<'a>(
    name: &'a str,
    token_kinds: Map<&'a str, usize>,
) -> dbscheme::Case<'a> {
    let branches: Vec<(usize, &str)> = token_kinds
        .iter()
        .map(|(&name, kind_id)| (*kind_id, name))
        .collect();
    dbscheme::Case {
        name,
        column: "kind",
        branches,
    }
}

pub fn create_location_union<'a>() -> dbscheme::Entry<'a> {
    dbscheme::Entry::Union(dbscheme::Union {
        name: "location",
        members: vec!["location_default"].into_iter().collect(),
    })
}

pub fn create_files_table<'a>() -> dbscheme::Entry<'a> {
    dbscheme::Entry::Table(dbscheme::Table {
        name: "files",
        keysets: None,
        columns: vec![
            dbscheme::Column {
                unique: true,
                db_type: dbscheme::DbColumnType::Int,
                name: "id",
                ql_type: ql::Type::At("file"),
                ql_type_is_ref: false,
            },
            dbscheme::Column {
                db_type: dbscheme::DbColumnType::String,
                name: "name",
                unique: false,
                ql_type: ql::Type::String,
                ql_type_is_ref: true,
            },
        ],
    })
}
pub fn create_folders_table<'a>() -> dbscheme::Entry<'a> {
    dbscheme::Entry::Table(dbscheme::Table {
        name: "folders",
        keysets: None,
        columns: vec![
            dbscheme::Column {
                unique: true,
                db_type: dbscheme::DbColumnType::Int,
                name: "id",
                ql_type: ql::Type::At("folder"),
                ql_type_is_ref: false,
            },
            dbscheme::Column {
                db_type: dbscheme::DbColumnType::String,
                name: "name",
                unique: false,
                ql_type: ql::Type::String,
                ql_type_is_ref: true,
            },
        ],
    })
}

pub fn create_locations_default_table<'a>() -> dbscheme::Entry<'a> {
    dbscheme::Entry::Table(dbscheme::Table {
        name: "locations_default",
        keysets: None,
        columns: vec![
            dbscheme::Column {
                unique: true,
                db_type: dbscheme::DbColumnType::Int,
                name: "id",
                ql_type: ql::Type::At("location_default"),
                ql_type_is_ref: false,
            },
            dbscheme::Column {
                unique: false,
                db_type: dbscheme::DbColumnType::Int,
                name: "file",
                ql_type: ql::Type::At("file"),
                ql_type_is_ref: true,
            },
            dbscheme::Column {
                unique: false,
                db_type: dbscheme::DbColumnType::Int,
                name: "start_line",
                ql_type: ql::Type::Int,
                ql_type_is_ref: true,
            },
            dbscheme::Column {
                unique: false,
                db_type: dbscheme::DbColumnType::Int,
                name: "start_column",
                ql_type: ql::Type::Int,
                ql_type_is_ref: true,
            },
            dbscheme::Column {
                unique: false,
                db_type: dbscheme::DbColumnType::Int,
                name: "end_line",
                ql_type: ql::Type::Int,
                ql_type_is_ref: true,
            },
            dbscheme::Column {
                unique: false,
                db_type: dbscheme::DbColumnType::Int,
                name: "end_column",
                ql_type: ql::Type::Int,
                ql_type_is_ref: true,
            },
        ],
    })
}

pub fn create_container_union<'a>() -> dbscheme::Entry<'a> {
    dbscheme::Entry::Union(dbscheme::Union {
        name: "container",
        members: vec!["folder", "file"].into_iter().collect(),
    })
}

pub fn create_containerparent_table<'a>() -> dbscheme::Entry<'a> {
    dbscheme::Entry::Table(dbscheme::Table {
        name: "containerparent",
        columns: vec![
            dbscheme::Column {
                unique: false,
                db_type: dbscheme::DbColumnType::Int,
                name: "parent",
                ql_type: ql::Type::At("container"),
                ql_type_is_ref: true,
            },
            dbscheme::Column {
                unique: true,
                db_type: dbscheme::DbColumnType::Int,
                name: "child",
                ql_type: ql::Type::At("container"),
                ql_type_is_ref: true,
            },
        ],
        keysets: None,
    })
}

pub fn create_source_location_prefix_table<'a>() -> dbscheme::Entry<'a> {
    dbscheme::Entry::Table(dbscheme::Table {
        name: "sourceLocationPrefix",
        keysets: None,
        columns: vec![dbscheme::Column {
            unique: false,
            db_type: dbscheme::DbColumnType::String,
            name: "prefix",
            ql_type: ql::Type::String,
            ql_type_is_ref: true,
        }],
    })
}

pub fn create_diagnostics<'a>() -> (dbscheme::Case<'a>, dbscheme::Table<'a>) {
    let table = dbscheme::Table {
        name: "diagnostics",
        keysets: None,
        columns: vec![
            dbscheme::Column {
                unique: true,
                db_type: dbscheme::DbColumnType::Int,
                name: "id",
                ql_type: ql::Type::At("diagnostic"),
                ql_type_is_ref: false,
            },
            dbscheme::Column {
                unique: false,
                db_type: dbscheme::DbColumnType::Int,
                name: "severity",
                ql_type: ql::Type::Int,
                ql_type_is_ref: true,
            },
            dbscheme::Column {
                unique: false,
                db_type: dbscheme::DbColumnType::String,
                name: "error_tag",
                ql_type: ql::Type::String,
                ql_type_is_ref: true,
            },
            dbscheme::Column {
                unique: false,
                db_type: dbscheme::DbColumnType::String,
                name: "error_message",
                ql_type: ql::Type::String,
                ql_type_is_ref: true,
            },
            dbscheme::Column {
                unique: false,
                db_type: dbscheme::DbColumnType::String,
                name: "full_error_message",
                ql_type: ql::Type::String,
                ql_type_is_ref: true,
            },
            dbscheme::Column {
                unique: false,
                db_type: dbscheme::DbColumnType::Int,
                name: "location",
                ql_type: ql::Type::At("location_default"),
                ql_type_is_ref: true,
            },
        ],
    };
    let severities: Vec<(usize, &str)> = vec![
        (10, "diagnostic_debug"),
        (20, "diagnostic_info"),
        (30, "diagnostic_warning"),
        (40, "diagnostic_error"),
    ];
    let case = dbscheme::Case {
        name: "diagnostic",
        column: "severity",
        branches: severities,
    };
    (case, table)
}

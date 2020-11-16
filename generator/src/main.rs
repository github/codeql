mod dbscheme;
mod language;
mod ql;
mod ql_gen;

use language::Language;
use std::collections::BTreeMap as Map;
use std::collections::BTreeSet as Set;
use std::fs::File;
use std::io::LineWriter;
use std::path::PathBuf;
use tracing::{error, info};

/// Given the name of the parent node, and its field information, returns the
/// name of the field's type. This may be an ad-hoc union of all the possible
/// types the field can take, in which case the union is added to `entries`.
fn make_field_type(
    field: &node_types::Field,
    entries: &mut Vec<dbscheme::Entry>,
    nodes: &node_types::NodeTypeMap,
) -> String {
    match &field.type_info {
        node_types::FieldTypeInfo::Multiple {
            types,
            dbscheme_union,
            ql_class: _,
        } => {
            // This field can have one of several types. Create an ad-hoc QL union
            // type to represent them.
            let members: Set<String> = types
                .iter()
                .map(|t| nodes.get(t).unwrap().dbscheme_name.clone())
                .collect();
            entries.push(dbscheme::Entry::Union(dbscheme::Union {
                name: dbscheme_union.clone(),
                members,
            }));
            dbscheme_union.clone()
        }
        node_types::FieldTypeInfo::Single(t) => nodes.get(&t).unwrap().dbscheme_name.clone(),
    }
}

/// Adds the appropriate dbscheme information for the given field, either as a
/// column on `main_table`, or as an auxiliary table.
fn add_field(
    main_table: &mut dbscheme::Table,
    field: &node_types::Field,
    entries: &mut Vec<dbscheme::Entry>,
    nodes: &node_types::NodeTypeMap,
) {
    let parent_name = &nodes.get(&field.parent).unwrap().dbscheme_name;
    match &field.storage {
        node_types::Storage::Table {
            name: table_name,
            has_index,
        } => {
            // This field can appear zero or multiple times, so put
            // it in an auxiliary table.
            let field_type = make_field_type(&field, entries, nodes);
            let parent_column = dbscheme::Column {
                unique: !*has_index,
                db_type: dbscheme::DbColumnType::Int,
                name: parent_name.clone(),
                ql_type: ql::Type::AtType(parent_name.clone()),
                ql_type_is_ref: true,
            };
            let index_column = dbscheme::Column {
                unique: false,
                db_type: dbscheme::DbColumnType::Int,
                name: "index".to_string(),
                ql_type: ql::Type::Int,
                ql_type_is_ref: true,
            };
            let field_column = dbscheme::Column {
                unique: true,
                db_type: dbscheme::DbColumnType::Int,
                name: field_type.clone(),
                ql_type: ql::Type::AtType(field_type),
                ql_type_is_ref: true,
            };
            let field_table = dbscheme::Table {
                name: table_name.clone(),
                columns: if *has_index {
                    vec![parent_column, index_column, field_column]
                } else {
                    vec![parent_column, field_column]
                },
                // In addition to the field being unique, the combination of
                // parent+index is unique, so add a keyset for them.
                keysets: if *has_index {
                    Some(vec![parent_name.clone(), "index".to_string()])
                } else {
                    None
                },
            };
            entries.push(dbscheme::Entry::Table(field_table));
        }
        node_types::Storage::Column { name: column_name } => {
            // This field must appear exactly once, so we add it as
            // a column to the main table for the node type.
            let field_type = make_field_type(&field, entries, nodes);
            main_table.columns.push(dbscheme::Column {
                unique: false,
                db_type: dbscheme::DbColumnType::Int,
                name: column_name.clone(),
                ql_type: ql::Type::AtType(field_type),
                ql_type_is_ref: true,
            });
        }
    }
}

/// Converts the given tree-sitter node types into CodeQL dbscheme entries.
fn convert_nodes(nodes: &node_types::NodeTypeMap) -> Vec<dbscheme::Entry> {
    let mut entries: Vec<dbscheme::Entry> = vec![
        create_location_union(),
        create_locations_default_table(),
        create_sourceline_union(),
        create_numlines_table(),
        create_files_table(),
        create_folders_table(),
        create_container_union(),
        create_containerparent_table(),
        create_source_location_prefix_table(),
    ];
    let mut ast_node_members: Set<String> = Set::new();
    let token_kinds: Map<String, usize> = nodes
        .iter()
        .filter_map(|(_, node)| match &node.kind {
            node_types::EntryKind::Token { kind_id } => {
                Some((node.dbscheme_name.clone(), *kind_id))
            }
            _ => None,
        })
        .collect();
    ast_node_members.insert("token".to_owned());

    for (_, node) in nodes {
        match &node.kind {
            node_types::EntryKind::Union { members: n_members } => {
                // It's a tree-sitter supertype node, for which we create a union
                // type.
                let members: Set<String> = n_members
                    .iter()
                    .map(|n| nodes.get(n).unwrap().dbscheme_name.clone())
                    .collect();
                entries.push(dbscheme::Entry::Union(dbscheme::Union {
                    name: node.dbscheme_name.clone(),
                    members,
                }));
            }
            node_types::EntryKind::Table { name, fields } => {
                // It's a product type, defined by a table.
                let mut main_table = dbscheme::Table {
                    name: name.clone(),
                    columns: vec![dbscheme::Column {
                        db_type: dbscheme::DbColumnType::Int,
                        name: "id".to_string(),
                        unique: true,
                        ql_type: ql::Type::AtType(node.dbscheme_name.clone()),
                        ql_type_is_ref: false,
                    }],
                    keysets: None,
                };
                ast_node_members.insert(node.dbscheme_name.clone());

                // If the type also has fields or children, then we create either
                // auxiliary tables or columns in the defining table for them.
                for field in fields {
                    add_field(&mut main_table, &field, &mut entries, nodes);
                }

                if fields.is_empty() {
                    // There were no fields and no children, so it's a leaf node in
                    // the TS grammar. Add a column for the node text.
                    main_table.columns.push(dbscheme::Column {
                        unique: false,
                        db_type: dbscheme::DbColumnType::String,
                        name: "text".to_string(),
                        ql_type: ql::Type::String,
                        ql_type_is_ref: true,
                    });
                }

                // Finally, the type's defining table also includes the location.
                main_table.columns.push(dbscheme::Column {
                    unique: false,
                    db_type: dbscheme::DbColumnType::Int,
                    name: "loc".to_string(),
                    ql_type: ql::Type::AtType("location".to_string()),
                    ql_type_is_ref: true,
                });

                entries.push(dbscheme::Entry::Table(main_table));
            }
            node_types::EntryKind::Token { .. } => {}
        }
    }

    // Add the tokeninfo table
    add_tokeninfo_table(&mut entries, token_kinds);

    // Create a union of all database types.
    entries.push(dbscheme::Entry::Union(dbscheme::Union {
        name: "ast_node".to_string(),
        members: ast_node_members,
    }));

    entries
}

fn add_tokeninfo_table(entries: &mut Vec<dbscheme::Entry>, token_kinds: Map<String, usize>) {
    entries.push(dbscheme::Entry::Table(dbscheme::Table {
        name: "tokeninfo".to_owned(),
        keysets: None,
        columns: vec![
            dbscheme::Column {
                db_type: dbscheme::DbColumnType::Int,
                name: "id".to_string(),
                unique: true,
                ql_type: ql::Type::AtType("token".to_owned()),
                ql_type_is_ref: false,
            },
            dbscheme::Column {
                unique: false,
                db_type: dbscheme::DbColumnType::Int,
                name: "kind".to_string(),
                ql_type: ql::Type::Int,
                ql_type_is_ref: true,
            },
            dbscheme::Column {
                unique: false,
                db_type: dbscheme::DbColumnType::Int,
                name: "file".to_string(),
                ql_type: ql::Type::AtType("file".to_string()),
                ql_type_is_ref: true,
            },
            dbscheme::Column {
                unique: false,
                db_type: dbscheme::DbColumnType::Int,
                name: "idx".to_string(),
                ql_type: ql::Type::Int,
                ql_type_is_ref: true,
            },
            dbscheme::Column {
                unique: false,
                db_type: dbscheme::DbColumnType::String,
                name: "value".to_string(),
                ql_type: ql::Type::String,
                ql_type_is_ref: true,
            },
            dbscheme::Column {
                unique: false,
                db_type: dbscheme::DbColumnType::Int,
                name: "loc".to_string(),
                ql_type: ql::Type::AtType("location".to_string()),
                ql_type_is_ref: true,
            },
        ],
    }));
    let branches: Vec<(usize, String)> = token_kinds
        .iter()
        .map(|(name, kind_id)| (*kind_id, name.clone()))
        .collect();
    entries.push(dbscheme::Entry::Case(dbscheme::Case {
        name: "token".to_owned(),
        column: "kind".to_owned(),
        branches: branches,
    }));
}

fn write_dbscheme(language: &Language, entries: &[dbscheme::Entry]) -> std::io::Result<()> {
    info!(
        "Writing database schema for {} to '{}'",
        &language.name,
        match language.dbscheme_path.to_str() {
            None => "<undisplayable>",
            Some(p) => p,
        }
    );
    let file = File::create(&language.dbscheme_path)?;
    let mut file = LineWriter::new(file);
    dbscheme::write(&language.name, &mut file, &entries)
}

fn create_location_union() -> dbscheme::Entry {
    dbscheme::Entry::Union(dbscheme::Union {
        name: "location".to_owned(),
        members: vec!["location_default".to_owned()].into_iter().collect(),
    })
}

fn create_files_table() -> dbscheme::Entry {
    dbscheme::Entry::Table(dbscheme::Table {
        name: "files".to_owned(),
        keysets: None,
        columns: vec![
            dbscheme::Column {
                unique: true,
                db_type: dbscheme::DbColumnType::Int,
                name: "id".to_owned(),
                ql_type: ql::Type::AtType("file".to_owned()),
                ql_type_is_ref: false,
            },
            dbscheme::Column {
                db_type: dbscheme::DbColumnType::String,
                name: "name".to_owned(),
                unique: false,
                ql_type: ql::Type::String,
                ql_type_is_ref: true,
            },
            dbscheme::Column {
                db_type: dbscheme::DbColumnType::String,
                name: "simple".to_owned(),
                unique: false,
                ql_type: ql::Type::String,
                ql_type_is_ref: true,
            },
            dbscheme::Column {
                db_type: dbscheme::DbColumnType::String,
                name: "ext".to_owned(),
                unique: false,
                ql_type: ql::Type::String,
                ql_type_is_ref: true,
            },
            dbscheme::Column {
                db_type: dbscheme::DbColumnType::Int,
                name: "fromSource".to_owned(),
                unique: false,
                ql_type: ql::Type::Int,
                ql_type_is_ref: true,
            },
        ],
    })
}
fn create_folders_table() -> dbscheme::Entry {
    dbscheme::Entry::Table(dbscheme::Table {
        name: "folders".to_owned(),
        keysets: None,
        columns: vec![
            dbscheme::Column {
                unique: true,
                db_type: dbscheme::DbColumnType::Int,
                name: "id".to_owned(),
                ql_type: ql::Type::AtType("folder".to_owned()),
                ql_type_is_ref: false,
            },
            dbscheme::Column {
                db_type: dbscheme::DbColumnType::String,
                name: "name".to_owned(),
                unique: false,
                ql_type: ql::Type::String,
                ql_type_is_ref: true,
            },
            dbscheme::Column {
                db_type: dbscheme::DbColumnType::String,
                name: "simple".to_owned(),
                unique: false,
                ql_type: ql::Type::String,
                ql_type_is_ref: true,
            },
        ],
    })
}

fn create_locations_default_table() -> dbscheme::Entry {
    dbscheme::Entry::Table(dbscheme::Table {
        name: "locations_default".to_string(),
        keysets: None,
        columns: vec![
            dbscheme::Column {
                unique: true,
                db_type: dbscheme::DbColumnType::Int,
                name: "id".to_string(),
                ql_type: ql::Type::AtType("location_default".to_string()),
                ql_type_is_ref: false,
            },
            dbscheme::Column {
                unique: false,
                db_type: dbscheme::DbColumnType::Int,
                name: "file".to_string(),
                ql_type: ql::Type::AtType("file".to_owned()),
                ql_type_is_ref: true,
            },
            dbscheme::Column {
                unique: false,
                db_type: dbscheme::DbColumnType::Int,
                name: "start_line".to_string(),
                ql_type: ql::Type::Int,
                ql_type_is_ref: true,
            },
            dbscheme::Column {
                unique: false,
                db_type: dbscheme::DbColumnType::Int,
                name: "start_column".to_string(),
                ql_type: ql::Type::Int,
                ql_type_is_ref: true,
            },
            dbscheme::Column {
                unique: false,
                db_type: dbscheme::DbColumnType::Int,
                name: "end_line".to_string(),
                ql_type: ql::Type::Int,
                ql_type_is_ref: true,
            },
            dbscheme::Column {
                unique: false,
                db_type: dbscheme::DbColumnType::Int,
                name: "end_column".to_string(),
                ql_type: ql::Type::Int,
                ql_type_is_ref: true,
            },
        ],
    })
}

fn create_sourceline_union() -> dbscheme::Entry {
    dbscheme::Entry::Union(dbscheme::Union {
        name: "sourceline".to_owned(),
        members: vec!["file".to_owned()].into_iter().collect(),
    })
}

fn create_numlines_table() -> dbscheme::Entry {
    dbscheme::Entry::Table(dbscheme::Table {
        name: "numlines".to_owned(),
        columns: vec![
            dbscheme::Column {
                unique: false,
                db_type: dbscheme::DbColumnType::Int,
                name: "element_id".to_string(),
                ql_type: ql::Type::AtType("sourceline".to_owned()),
                ql_type_is_ref: true,
            },
            dbscheme::Column {
                unique: false,
                db_type: dbscheme::DbColumnType::Int,
                name: "num_lines".to_string(),
                ql_type: ql::Type::Int,
                ql_type_is_ref: true,
            },
            dbscheme::Column {
                unique: false,
                db_type: dbscheme::DbColumnType::Int,
                name: "num_code".to_string(),
                ql_type: ql::Type::Int,
                ql_type_is_ref: true,
            },
            dbscheme::Column {
                unique: false,
                db_type: dbscheme::DbColumnType::Int,
                name: "num_comment".to_string(),
                ql_type: ql::Type::Int,
                ql_type_is_ref: true,
            },
        ],
        keysets: None,
    })
}

fn create_container_union() -> dbscheme::Entry {
    dbscheme::Entry::Union(dbscheme::Union {
        name: "container".to_owned(),
        members: vec!["folder".to_owned(), "file".to_owned()]
            .into_iter()
            .collect(),
    })
}

fn create_containerparent_table() -> dbscheme::Entry {
    dbscheme::Entry::Table(dbscheme::Table {
        name: "containerparent".to_owned(),
        columns: vec![
            dbscheme::Column {
                unique: false,
                db_type: dbscheme::DbColumnType::Int,
                name: "parent".to_string(),
                ql_type: ql::Type::AtType("container".to_owned()),
                ql_type_is_ref: true,
            },
            dbscheme::Column {
                unique: true,
                db_type: dbscheme::DbColumnType::Int,
                name: "child".to_string(),
                ql_type: ql::Type::AtType("container".to_owned()),
                ql_type_is_ref: true,
            },
        ],
        keysets: None,
    })
}

fn create_source_location_prefix_table() -> dbscheme::Entry {
    dbscheme::Entry::Table(dbscheme::Table {
        name: "sourceLocationPrefix".to_string(),
        keysets: None,
        columns: vec![dbscheme::Column {
            unique: false,
            db_type: dbscheme::DbColumnType::String,
            name: "prefix".to_string(),
            ql_type: ql::Type::String,
            ql_type_is_ref: true,
        }],
    })
}

fn main() {
    tracing_subscriber::fmt()
        .with_target(false)
        .without_time()
        .with_level(true)
        .with_env_filter(tracing_subscriber::EnvFilter::from_default_env())
        .init();

    // TODO: figure out proper dbscheme output path and/or take it from the
    // command line.
    let ruby = Language {
        name: "Ruby".to_string(),
        node_types: tree_sitter_ruby::NODE_TYPES,
        dbscheme_path: PathBuf::from("ql/src/ruby.dbscheme"),
        ql_library_path: PathBuf::from("ql/src/codeql_ruby/ast.qll"),
    };
    match node_types::read_node_types_str(&ruby.node_types) {
        Err(e) => {
            error!("Failed to read node-types JSON for {}: {}", ruby.name, e);
            std::process::exit(1);
        }
        Ok(nodes) => {
            let dbscheme_entries = convert_nodes(&nodes);

            if let Err(e) = write_dbscheme(&ruby, &dbscheme_entries) {
                error!("Failed to write dbscheme: {}", e);
                std::process::exit(2);
            }

            let classes = ql_gen::convert_nodes(&nodes);

            if let Err(e) = ql_gen::write(&ruby, &classes) {
                println!("Failed to write QL library: {}", e);
                std::process::exit(3);
            }
        }
    }
}

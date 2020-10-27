mod dbscheme;
mod language;

use language::Language;
use node_types;
use std::collections::BTreeSet as Set;
use std::fs::File;
use std::io::LineWriter;
use std::path::PathBuf;
use tracing::{error, info};

/// Given the name of the parent node, and its field information, returns the
/// name of the field's type. This may be an ad-hoc union of all the possible
/// types the field can take, in which case the union is added to `entries`.
fn make_field_type(
    parent_name: &str,
    field_name: &str,
    types: &Set<node_types::TypeName>,
    entries: &mut Vec<dbscheme::Entry>,
) -> String {
    if types.len() == 1 {
        // This field can only have a single type.
        let t = types.iter().next().unwrap();
        node_types::escape_name(&node_types::node_type_name(&t.kind, t.named))
    } else {
        // This field can have one of several types. Create an ad-hoc QL union
        // type to represent them.
        let field_union_name = format!("{}_{}_type", parent_name, field_name);
        let field_union_name = node_types::escape_name(&field_union_name);
        let mut members: Vec<String> = Vec::new();
        for field_type in types {
            members.push(node_types::escape_name(&node_types::node_type_name(
                &field_type.kind,
                field_type.named,
            )));
        }
        entries.push(dbscheme::Entry::Union(dbscheme::Union {
            name: field_union_name.clone(),
            members,
        }));
        field_union_name
    }
}

/// Adds the appropriate dbscheme information for the given field, either as a
/// column on `main_table`, or as an auxiliary table.
fn add_field(
    main_table: &mut dbscheme::Table,
    field: &node_types::Field,
    entries: &mut Vec<dbscheme::Entry>,
) {
    let field_name = match &field.name {
        None => "child".to_owned(),
        Some(x) => x.to_owned(),
    };
    let parent_name = node_types::node_type_name(&field.parent.kind, field.parent.named);
    match field.storage {
        node_types::Storage::Table { .. } => {
            // This field can appear zero or multiple times, so put
            // it in an auxiliary table.
            let field_type = make_field_type(&parent_name, &field_name, &field.types, entries);
            let field_table = dbscheme::Table {
                name: format!("{}_{}", parent_name, field_name),
                columns: vec![
                    // First column is a reference to the parent.
                    dbscheme::Column {
                        unique: false,
                        db_type: dbscheme::DbColumnType::Int,
                        name: node_types::escape_name(&parent_name),
                        ql_type: dbscheme::QlColumnType::Custom(node_types::escape_name(
                            &parent_name,
                        )),
                        ql_type_is_ref: true,
                    },
                    // Then an index column.
                    dbscheme::Column {
                        unique: false,
                        db_type: dbscheme::DbColumnType::Int,
                        name: "index".to_string(),
                        ql_type: dbscheme::QlColumnType::Int,
                        ql_type_is_ref: true,
                    },
                    // And then the field
                    dbscheme::Column {
                        unique: true,
                        db_type: dbscheme::DbColumnType::Int,
                        name: field_type.clone(),
                        ql_type: dbscheme::QlColumnType::Custom(field_type),
                        ql_type_is_ref: true,
                    },
                ],
                // In addition to the field being unique, the combination of
                // parent+index is unique, so add a keyset for them.
                keysets: Some(vec![
                    node_types::escape_name(&parent_name),
                    "index".to_string(),
                ]),
            };
            entries.push(dbscheme::Entry::Table(field_table));
        }
        node_types::Storage::Column => {
            // This field must appear exactly once, so we add it as
            // a column to the main table for the node type.
            let field_type = make_field_type(&parent_name, &field_name, &field.types, entries);
            main_table.columns.push(dbscheme::Column {
                unique: false,
                db_type: dbscheme::DbColumnType::Int,
                name: field_name,
                ql_type: dbscheme::QlColumnType::Custom(field_type),
                ql_type_is_ref: true,
            });
        }
    }
}

/// Converts the given tree-sitter node types into CodeQL dbscheme entries.
fn convert_nodes(nodes: &Vec<node_types::Entry>) -> Vec<dbscheme::Entry> {
    let mut entries: Vec<dbscheme::Entry> = Vec::new();
    let mut top_members: Vec<String> = Vec::new();

    for node in nodes {
        match &node {
            node_types::Entry::Union {
                type_name,
                members: n_members,
            } => {
                // It's a tree-sitter supertype node, for which we create a union
                // type.
                let mut members: Vec<String> = Vec::new();
                for n_member in n_members {
                    members.push(node_types::escape_name(&node_types::node_type_name(
                        &n_member.kind,
                        n_member.named,
                    )))
                }
                entries.push(dbscheme::Entry::Union(dbscheme::Union {
                    name: node_types::escape_name(&node_types::node_type_name(
                        &type_name.kind,
                        type_name.named,
                    )),
                    members,
                }));
            }
            node_types::Entry::Table { type_name, fields } => {
                // It's a product type, defined by a table.
                let name = node_types::node_type_name(&type_name.kind, type_name.named);
                let mut main_table = dbscheme::Table {
                    name: node_types::escape_name(&(format!("{}_def", name))),
                    columns: vec![dbscheme::Column {
                        db_type: dbscheme::DbColumnType::Int,
                        name: "id".to_string(),
                        unique: true,
                        ql_type: dbscheme::QlColumnType::Custom(node_types::escape_name(&name)),
                        ql_type_is_ref: false,
                    }],
                    keysets: None,
                };
                top_members.push(node_types::escape_name(&name));

                // If the type also has fields or children, then we create either
                // auxiliary tables or columns in the defining table for them.
                for field in fields {
                    add_field(&mut main_table, &field, &mut entries);
                }

                if fields.is_empty() {
                    // There were no fields and no children, so it's a leaf node in
                    // the TS grammar. Add a column for the node text.
                    main_table.columns.push(dbscheme::Column {
                        unique: false,
                        db_type: dbscheme::DbColumnType::String,
                        name: "text".to_string(),
                        ql_type: dbscheme::QlColumnType::String,
                        ql_type_is_ref: true,
                    });
                }

                // Finally, the type's defining table also includes the location.
                main_table.columns.push(dbscheme::Column {
                    unique: false,
                    db_type: dbscheme::DbColumnType::Int,
                    name: "loc".to_string(),
                    ql_type: dbscheme::QlColumnType::Custom("location".to_string()),
                    ql_type_is_ref: true,
                });

                entries.push(dbscheme::Entry::Table(main_table));
            }
        }
    }

    // Create a union of all database types.
    entries.push(dbscheme::Entry::Union(dbscheme::Union {
        name: "top".to_string(),
        members: top_members,
    }));

    entries
}

fn write_dbscheme(language: &Language, entries: &[dbscheme::Entry]) -> std::io::Result<()> {
    info!(
        "Writing to '{}'",
        match language.dbscheme_path.to_str() {
            None => "<undisplayable>",
            Some(p) => p,
        }
    );
    let file = File::create(&language.dbscheme_path)?;
    let mut file = LineWriter::new(file);
    dbscheme::write(&language.name, &mut file, &entries)
}

fn create_location_entry() -> dbscheme::Entry {
    dbscheme::Entry::Table(dbscheme::Table {
        name: "location".to_string(),
        keysets: None,
        columns: vec![
            dbscheme::Column {
                unique: true,
                db_type: dbscheme::DbColumnType::Int,
                name: "id".to_string(),
                ql_type: dbscheme::QlColumnType::Custom("location".to_string()),
                ql_type_is_ref: false,
            },
            dbscheme::Column {
                unique: false,
                db_type: dbscheme::DbColumnType::String,
                name: "file_path".to_string(),
                ql_type: dbscheme::QlColumnType::String,
                ql_type_is_ref: true,
            },
            dbscheme::Column {
                unique: false,
                db_type: dbscheme::DbColumnType::Int,
                name: "start_line".to_string(),
                ql_type: dbscheme::QlColumnType::Int,
                ql_type_is_ref: true,
            },
            dbscheme::Column {
                unique: false,
                db_type: dbscheme::DbColumnType::Int,
                name: "start_column".to_string(),
                ql_type: dbscheme::QlColumnType::Int,
                ql_type_is_ref: true,
            },
            dbscheme::Column {
                unique: false,
                db_type: dbscheme::DbColumnType::Int,
                name: "end_line".to_string(),
                ql_type: dbscheme::QlColumnType::Int,
                ql_type_is_ref: true,
            },
            dbscheme::Column {
                unique: false,
                db_type: dbscheme::DbColumnType::Int,
                name: "end_column".to_string(),
                ql_type: dbscheme::QlColumnType::Int,
                ql_type_is_ref: true,
            },
        ],
    })
}

fn create_source_location_prefix_entry() -> dbscheme::Entry {
    dbscheme::Entry::Table(dbscheme::Table {
        name: "sourceLocationPrefix".to_string(),
        keysets: None,
        columns: vec![dbscheme::Column {
            unique: false,
            db_type: dbscheme::DbColumnType::String,
            name: "prefix".to_string(),
            ql_type: dbscheme::QlColumnType::String,
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
        node_types_path: PathBuf::from("tree-sitter-ruby/src/node-types.json"),
        dbscheme_path: PathBuf::from("ruby.dbscheme"),
    };
    match node_types::read_node_types(&ruby.node_types_path) {
        Err(e) => {
            error!("Failed to read '{}': {}", ruby.node_types_path.display(), e);
            std::process::exit(1);
        }
        Ok(nodes) => {
            let mut dbscheme_entries = convert_nodes(&nodes);
            dbscheme_entries.push(create_location_entry());
            dbscheme_entries.push(create_source_location_prefix_entry());
            match write_dbscheme(&ruby, &dbscheme_entries) {
                Err(e) => {
                    error!("Failed to write dbscheme: {}", e);
                    std::process::exit(2);
                }
                Ok(()) => {}
            }
        }
    }
}

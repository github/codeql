use std::fs::File;
use std::io::LineWriter;
use std::path::Path;

mod dbscheme;
mod node_types;
use node_types::{FieldInfo, NodeInfo};

fn read_node_types() -> Option<Vec<NodeInfo>> {
    let json_data = match std::fs::read_to_string(Path::new("tree-sitter-ruby/src/node-types.json"))
    {
        Ok(s) => s,
        Err(_) => return None,
    };
    let nodes: Vec<NodeInfo> = match serde_json::from_str(&json_data) {
        Ok(n) => n,
        Err(_) => return None,
    };

    Some(nodes)
}

/// Given a tree-sitter node type's (kind, named) pair, returns a single string
/// representing the (unescaped) name we'll use to refer to corresponding QL
/// type.
fn node_type_name(kind: &str, named: bool) -> String {
    if named {
        kind.to_string()
    } else {
        format!("{}_unnamed", kind)
    }
}

/// Given the name of the parent node, and its field information, returns the
/// name of the field's type. This may be an ad-hoc union of all the possible
/// types the field can take, in which case the union is added to `entries`.
fn make_field_type(
    parent_name: &str,
    field_name: &str,
    field_info: &FieldInfo,
    entries: &mut Vec<dbscheme::Entry>,
) -> String {
    if field_info.types.len() == 1 {
        // This field can only have a single type.
        let t = &field_info.types[0];
        dbscheme::escape_name(&node_type_name(&t.kind, t.named))
    } else {
        // This field can have one of several types. Create an ad-hoc QL union
        // type to represent them.
        let field_union_name = format!("{}_{}_type", parent_name, field_name);
        let field_union_name = dbscheme::escape_name(&field_union_name);
        let mut members: Vec<String> = Vec::new();
        for field_type in &field_info.types {
            members.push(dbscheme::escape_name(&node_type_name(
                &field_type.kind,
                field_type.named,
            )));
        }
        entries.push(dbscheme::Entry::Union {
            name: field_union_name.clone(),
            members,
        });
        field_union_name
    }
}

/// Adds the appropriate dbscheme information for the given field, either as a
/// column on `main_table`, or as an auxiliary table.
fn add_field(
    main_table: &mut dbscheme::Table,
    parent_name: &str,
    field_name: &str,
    field_info: &FieldInfo,
    entries: &mut Vec<dbscheme::Entry>,
) {
    if field_info.multiple || !field_info.required {
        // This field can appear zero or multiple times, so put
        // it in an auxiliary table.
        let field_type = make_field_type(parent_name, field_name, field_info, entries);
        let field_table = dbscheme::Table {
            name: format!("{}_{}", parent_name, field_name),
            columns: vec![
                // First column is a reference to the parent.
                dbscheme::Column {
                    unique: false,
                    db_type: dbscheme::DbColumnType::Int,
                    name: dbscheme::escape_name(parent_name),
                    ql_type: dbscheme::QlColumnType::Custom(dbscheme::escape_name(parent_name)),
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
            keysets: vec![vec![
                dbscheme::escape_name(parent_name),
                "index".to_string(),
            ]],
        };
        entries.push(dbscheme::Entry::Table(field_table));
    } else {
        // This field must appear exactly once, so we add it as
        // a column to the main table for the node type.
        let field_type = make_field_type(parent_name, field_name, field_info, entries);
        main_table.columns.push(dbscheme::Column {
            unique: false,
            db_type: dbscheme::DbColumnType::Int,
            name: String::from(field_name),
            ql_type: dbscheme::QlColumnType::Custom(field_type),
            ql_type_is_ref: true,
        });
    }
}

/// Converts the given tree-sitter node types into CodeQL dbscheme entries.
fn convert_nodes(nodes: &[NodeInfo]) -> Vec<dbscheme::Entry> {
    let mut entries: Vec<dbscheme::Entry> = Vec::new();
    let mut top_members: Vec<String> = Vec::new();

    for node in nodes {
        if let Some(subtypes) = &node.subtypes {
            // It's a tree-sitter supertype node, for which we create a union
            // type.
            let mut members: Vec<String> = Vec::new();
            for subtype in subtypes {
                members.push(dbscheme::escape_name(&node_type_name(
                    &subtype.kind,
                    subtype.named,
                )))
            }
            entries.push(dbscheme::Entry::Union {
                name: dbscheme::escape_name(&node_type_name(&node.kind, node.named)),
                members,
            });
        } else {
            // It's a product type, defined by a table.
            let name = node_type_name(&node.kind, node.named);
            let mut main_table = dbscheme::Table {
                name: dbscheme::escape_name(&(format!("{}_def", name))),
                columns: vec![dbscheme::Column {
                    db_type: dbscheme::DbColumnType::Int,
                    name: "id".to_string(),
                    unique: true,
                    ql_type: dbscheme::QlColumnType::Custom(dbscheme::escape_name(&name)),
                    ql_type_is_ref: false,
                }],
                keysets: vec![],
            };
            top_members.push(dbscheme::escape_name(&name));

            let mut is_leaf = true;

            // If the type also has fields or children, then we create either
            // auxiliary tables or columns in the defining table for them.
            if let Some(fields) = &node.fields {
                for (field_name, field_info) in fields {
                    is_leaf = false;
                    add_field(&mut main_table, &name, field_name, field_info, &mut entries);
                }
            }
            if let Some(children) = &node.children {
                is_leaf = false;

                // Treat children as if they were a field called 'child'.
                add_field(&mut main_table, &name, "child", children, &mut entries);
            }

            if is_leaf {
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

    // Create a union of all database types.
    entries.push(dbscheme::Entry::Union {
        name: "top".to_string(),
        members: top_members,
    });

    entries
}

fn write_dbscheme(entries: &[dbscheme::Entry]) -> std::io::Result<()> {
    // TODO: figure out proper output path and/or take it from the command line.
    let path = Path::new("ruby.dbscheme");
    println!(
        "Writing to '{}'",
        match path.to_str() {
            None => "<undisplayable>",
            Some(p) => p,
        }
    );
    let file = File::create(path)?;
    let mut file = LineWriter::new(file);
    dbscheme::write(&mut file, &entries)
}

fn create_location_entry() -> dbscheme::Entry {
    dbscheme::Entry::Table(dbscheme::Table {
        name: "location".to_string(),
        keysets: Vec::new(),
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
        keysets: Vec::new(),
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
    match read_node_types() {
        None => {
            println!("Failed to read node types");
            std::process::exit(1);
        }
        Some(nodes) => {
            let mut dbscheme_entries = convert_nodes(&nodes);
            dbscheme_entries.push(create_location_entry());
            dbscheme_entries.push(create_source_location_prefix_entry());
            match write_dbscheme(&dbscheme_entries) {
                Err(e) => {
                    println!("Failed to write dbscheme: {}", e);
                    std::process::exit(2);
                }
                Ok(()) => {}
            }
        }
    }
}

use crate::language::Language;
use crate::ql;
use std::collections::BTreeSet;
use std::fs::File;
use std::io::LineWriter;

/// Writes the QL AST library for the given library.
///
/// # Arguments
///
/// `language` - the language for which we're generating a library
/// `classes` - the list of classes to write.
pub fn write(language: &Language, classes: &[ql::TopLevel]) -> std::io::Result<()> {
    println!(
        "Writing QL library for {} to '{}'",
        &language.name,
        match language.ql_library_path.to_str() {
            None => "<undisplayable>",
            Some(p) => p,
        }
    );
    let file = File::create(&language.ql_library_path)?;
    let mut file = LineWriter::new(file);
    ql::write(&language.name, &mut file, &classes)
}

/// Creates the hard-coded `AstNode` class that acts as a supertype of all
/// classes we generate.
fn create_ast_node_class() -> ql::Class {
    // Default implementation of `toString` calls `this.describeQlClass()`
    let to_string = ql::Predicate {
        name: "toString".to_owned(),
        overridden: false,
        return_type: Some(ql::Type::String),
        formal_parameters: vec![],
        body: ql::Expression::Equals(
            Box::new(ql::Expression::Var("result".to_owned())),
            Box::new(ql::Expression::Dot(
                Box::new(ql::Expression::Var("this".to_owned())),
                "describeQlClass".to_owned(),
                vec![],
            )),
        ),
    };
    let get_location = create_none_predicate(
        "getLocation",
        false,
        Some(ql::Type::Normal("Location".to_owned())),
        vec![],
    );
    let get_a_field_or_child = create_none_predicate(
        "getAFieldOrChild",
        false,
        Some(ql::Type::Normal("AstNode".to_owned())),
        vec![],
    );
    let describe_ql_class = ql::Predicate {
        name: "describeQlClass".to_owned(),
        overridden: false,
        return_type: Some(ql::Type::String),
        formal_parameters: vec![],
        body: ql::Expression::Equals(
            Box::new(ql::Expression::Var("result".to_owned())),
            Box::new(ql::Expression::String("???".to_owned())),
        ),
    };
    ql::Class {
        name: "AstNode".to_owned(),
        is_abstract: false,
        supertypes: vec![ql::Type::AtType("ast_node".to_owned())]
            .into_iter()
            .collect(),
        characteristic_predicate: None,
        predicates: vec![
            to_string,
            get_location,
            get_a_field_or_child,
            describe_ql_class,
        ],
    }
}

fn create_token_class() -> ql::Class {
    let get_value = ql::Predicate {
        name: "getValue".to_owned(),
        overridden: false,
        return_type: Some(ql::Type::String),
        formal_parameters: vec![],
        body: ql::Expression::Pred(
            "tokeninfo".to_owned(),
            vec![
                ql::Expression::Var("this".to_owned()),
                ql::Expression::Var("_".to_owned()),
                ql::Expression::Var("_".to_owned()),
                ql::Expression::Var("_".to_owned()),
                ql::Expression::Var("result".to_owned()),
                ql::Expression::Var("_".to_owned()),
            ],
        ),
    };
    let get_location = ql::Predicate {
        name: "getLocation".to_owned(),
        overridden: true,
        return_type: Some(ql::Type::Normal("Location".to_owned())),
        formal_parameters: vec![],
        body: ql::Expression::Pred(
            "tokeninfo".to_owned(),
            vec![
                ql::Expression::Var("this".to_owned()),
                ql::Expression::Var("_".to_owned()),
                ql::Expression::Var("_".to_owned()),
                ql::Expression::Var("_".to_owned()),
                ql::Expression::Var("_".to_owned()),
                ql::Expression::Var("result".to_owned()),
            ],
        ),
    };
    let to_string = ql::Predicate {
        name: "toString".to_owned(),
        overridden: true,
        return_type: Some(ql::Type::String),
        formal_parameters: vec![],
        body: ql::Expression::Equals(
            Box::new(ql::Expression::Var("result".to_owned())),
            Box::new(ql::Expression::Pred("getValue".to_owned(), vec![])),
        ),
    };
    ql::Class {
        name: "Token".to_owned(),
        is_abstract: false,
        supertypes: vec![
            ql::Type::AtType("token".to_owned()),
            ql::Type::Normal("AstNode".to_owned()),
        ]
        .into_iter()
        .collect(),
        characteristic_predicate: None,
        predicates: vec![
            get_value,
            get_location,
            to_string,
            create_describe_ql_class("Token"),
        ],
    }
}

// Creates the `ReservedWord` class.
fn create_reserved_word_class() -> ql::Class {
    let db_name = "reserved_word";
    let class_name = "ReservedWord".to_owned();
    let describe_ql_class = create_describe_ql_class(&class_name);
    ql::Class {
        name: class_name,
        is_abstract: false,
        supertypes: vec![
            ql::Type::AtType(db_name.to_owned()),
            ql::Type::Normal("Token".to_owned()),
        ]
        .into_iter()
        .collect(),
        characteristic_predicate: None,
        predicates: vec![describe_ql_class],
    }
}

/// Creates a predicate whose body is `none()`.
fn create_none_predicate(
    name: &str,
    overridden: bool,
    return_type: Option<ql::Type>,
    formal_parameters: Vec<ql::FormalParameter>,
) -> ql::Predicate {
    ql::Predicate {
        name: name.to_owned(),
        overridden,
        return_type,
        formal_parameters,
        body: ql::Expression::Pred("none".to_owned(), vec![]),
    }
}

/// Creates an overridden `describeQlClass` predicate that returns the given
/// name.
fn create_describe_ql_class(class_name: &str) -> ql::Predicate {
    ql::Predicate {
        name: "describeQlClass".to_owned(),
        overridden: true,
        return_type: Some(ql::Type::String),
        formal_parameters: vec![],
        body: ql::Expression::Equals(
            Box::new(ql::Expression::Var("result".to_owned())),
            Box::new(ql::Expression::String(class_name.to_owned())),
        ),
    }
}

/// Creates the `getLocation` predicate.
///
/// # Arguments
///
/// `def_table` - the name of the table that defines the entity and its location.
/// `arity` - the total number of columns in the table
fn create_get_location_predicate(def_table: &str, arity: usize) -> ql::Predicate {
    ql::Predicate {
        name: "getLocation".to_owned(),
        overridden: true,
        return_type: Some(ql::Type::Normal("Location".to_owned())),
        formal_parameters: vec![],
        // body of the form: foo_bar_def(_, _, ..., result)
        body: ql::Expression::Pred(
            def_table.to_owned(),
            [
                vec![ql::Expression::Var("this".to_owned())],
                vec![ql::Expression::Var("_".to_owned()); arity - 2],
                vec![ql::Expression::Var("result".to_owned())],
            ]
            .concat(),
        ),
    }
}

/// Creates the `getText` predicate for a leaf node.
///
/// # Arguments
///
/// `def_table` - the name of the table that defines the entity and its text.
fn create_get_text_predicate(def_table: &str) -> ql::Predicate {
    ql::Predicate {
        name: "getText".to_owned(),
        overridden: false,
        return_type: Some(ql::Type::String),
        formal_parameters: vec![],
        body: ql::Expression::Pred(
            def_table.to_owned(),
            vec![
                ql::Expression::Var("this".to_owned()),
                ql::Expression::Var("result".to_owned()),
                ql::Expression::Var("_".to_owned()),
            ],
        ),
    }
}

/// Returns an expression to get a field that's defined as a column in the parent's table.
///
/// # Arguments
///
/// * `table_name` - the name of parent's defining table
/// * `column_index` - the index in that table that defines the field
/// * `arity` - the total number of columns in the table
fn create_get_field_expr_for_column_storage(
    table_name: &str,
    column_index: usize,
    arity: usize,
) -> ql::Expression {
    let num_underscores_before = column_index - 1;
    let num_underscores_after = arity - 2 - num_underscores_before;
    ql::Expression::Pred(
        table_name.to_owned(),
        [
            vec![ql::Expression::Var("this".to_owned())],
            vec![ql::Expression::Var("_".to_owned()); num_underscores_before],
            vec![ql::Expression::Var("result".to_owned())],
            vec![ql::Expression::Var("_".to_owned()); num_underscores_after],
        ]
        .concat(),
    )
}

/// Returns an expression to get the field with the given index from its
/// auxiliary table. The index name can be "_" so the expression will hold for
/// all indices.
fn create_get_field_expr_for_table_storage(
    table_name: &str,
    index_var_name: Option<&str>,
) -> ql::Expression {
    ql::Expression::Pred(
        table_name.to_owned(),
        match index_var_name {
            Some(index_var_name) => vec![
                ql::Expression::Var("this".to_owned()),
                ql::Expression::Var(index_var_name.to_owned()),
                ql::Expression::Var("result".to_owned()),
            ],
            None => vec![
                ql::Expression::Var("this".to_owned()),
                ql::Expression::Var("result".to_owned()),
            ],
        },
    )
}

/// Creates a pair consisting of a predicate to get the given field, and an
/// expression that will get the same field. When the field can occur multiple
/// times, the predicate will take an index argument, while the expression will
/// use the "don't care" expression to hold for all occurrences.
///
/// # Arguments
///
/// `main_table_name` - the name of the defining table for the parent node
/// `main_table_arity` - the number of columns in the main table
/// `main_table_column_index` - a mutable reference to a column index indicating
/// where the field is in the main table. If this is used (i.e. the field has
/// column storage), then the index is incremented.
/// `parent_name` - the name of the parent node
/// `field` - the field whose getters we are creating
/// `field_type` - the db name of the field's type (possibly being a union we created)
fn create_field_getters(
    main_table_name: &str,
    main_table_arity: usize,
    main_table_column_index: &mut usize,
    parent_name: &str,
    field: &node_types::Field,
    nodes: &node_types::NodeTypeMap,
) -> (ql::Predicate, ql::Expression) {
    let predicate_name = field.get_getter_name();
    let return_type = Some(ql::Type::Normal(match &field.type_info {
        node_types::FieldTypeInfo::Single(t) => nodes.get(&t).unwrap().ql_class_name.clone(),
        node_types::FieldTypeInfo::Multiple {
            types: _,
            dbscheme_union: _,
            ql_class,
        } => ql_class.clone(),
    }));
    match &field.storage {
        node_types::Storage::Column => {
            let result = (
                ql::Predicate {
                    name: predicate_name,
                    overridden: false,
                    return_type,
                    formal_parameters: vec![],
                    body: create_get_field_expr_for_column_storage(
                        &main_table_name,
                        *main_table_column_index,
                        main_table_arity,
                    ),
                },
                create_get_field_expr_for_column_storage(
                    &main_table_name,
                    *main_table_column_index,
                    main_table_arity,
                ),
            );
            *main_table_column_index += 1;
            result
        }
        node_types::Storage::Table(has_index) => {
            let field_table_name = format!("{}_{}", parent_name, &field.get_name());
            (
                ql::Predicate {
                    name: predicate_name,
                    overridden: false,
                    return_type,
                    formal_parameters: if *has_index {
                        vec![ql::FormalParameter {
                            name: "i".to_owned(),
                            param_type: ql::Type::Int,
                        }]
                    } else {
                        vec![]
                    },
                    body: create_get_field_expr_for_table_storage(
                        &field_table_name,
                        if *has_index { Some("i") } else { None },
                    ),
                },
                create_get_field_expr_for_table_storage(
                    &field_table_name,
                    if *has_index { Some("_") } else { None },
                ),
            )
        }
    }
}

/// Converts the given node types into CodeQL classes wrapping the dbscheme.
pub fn convert_nodes(nodes: &node_types::NodeTypeMap) -> Vec<ql::TopLevel> {
    let mut classes: Vec<ql::TopLevel> = vec![
        ql::TopLevel::Import("codeql.files.FileSystem".to_owned()),
        ql::TopLevel::Import("codeql.Locations".to_owned()),
        ql::TopLevel::Class(create_ast_node_class()),
        ql::TopLevel::Class(create_token_class()),
        ql::TopLevel::Class(create_reserved_word_class()),
    ];
    let mut token_kinds = BTreeSet::new();
    for (type_name, node) in nodes {
        if let node_types::EntryKind::Token { .. } = &node.kind {
            if type_name.named {
                token_kinds.insert(type_name.kind.to_owned());
            }
        }
    }

    for (type_name, node) in nodes {
        match &node.kind {
            node_types::EntryKind::Token { kind_id: _ } => {
                if type_name.named {
                    let describe_ql_class = create_describe_ql_class(&node.ql_class_name);
                    let mut supertypes: BTreeSet<ql::Type> = BTreeSet::new();
                    supertypes.insert(ql::Type::AtType(node.flattened_name.to_owned()));
                    supertypes.insert(ql::Type::Normal("Token".to_owned()));
                    classes.push(ql::TopLevel::Class(ql::Class {
                        name: node.ql_class_name.clone(),
                        is_abstract: false,
                        supertypes,
                        characteristic_predicate: None,
                        predicates: vec![describe_ql_class],
                    }));
                }
            }
            node_types::EntryKind::Union { members: _ } => {
                // It's a tree-sitter supertype node, so we're wrapping a dbscheme
                // union type.
                classes.push(ql::TopLevel::Class(ql::Class {
                    name: node.ql_class_name.clone(),
                    is_abstract: false,
                    supertypes: vec![
                        ql::Type::AtType(node_types::escape_name(&node.flattened_name)),
                        ql::Type::Normal("AstNode".to_owned()),
                    ]
                    .into_iter()
                    .collect(),
                    characteristic_predicate: None,
                    predicates: vec![],
                }));
            }
            node_types::EntryKind::Table { fields } => {
                // Count how many columns there will be in the main table.
                // There will be:
                // - one for the id
                // - one for the location
                // - one for each field that's stored as a column
                // - if there are no fields, one for the text column.
                let main_table_arity = 2 + if fields.is_empty() {
                    1
                } else {
                    fields
                        .iter()
                        .filter(|&f| matches!(f.storage, node_types::Storage::Column))
                        .count()
                };

                let escaped_name = node_types::escape_name(&node.flattened_name);
                let main_class_name = &node.ql_class_name;
                let main_table_name =
                    node_types::escape_name(&format!("{}_def", &node.flattened_name));
                let mut main_class = ql::Class {
                    name: main_class_name.clone(),
                    is_abstract: false,
                    supertypes: vec![
                        ql::Type::AtType(escaped_name),
                        ql::Type::Normal("AstNode".to_owned()),
                    ]
                    .into_iter()
                    .collect(),
                    characteristic_predicate: None,
                    predicates: vec![
                        create_describe_ql_class(&main_class_name),
                        create_get_location_predicate(&main_table_name, main_table_arity),
                    ],
                };

                if fields.is_empty() {
                    main_class
                        .predicates
                        .push(create_get_text_predicate(&main_table_name));
                } else {
                    let mut main_table_column_index: usize = 1;
                    let mut get_child_exprs: Vec<ql::Expression> = Vec::new();

                    // Iterate through the fields, creating:
                    // - classes to wrap union types if fields need them,
                    // - predicates to access the fields,
                    // - the QL expressions to access the fields that will be part of getAFieldOrChild.
                    for field in fields {
                        let (get_pred, get_child_expr) = create_field_getters(
                            &main_table_name,
                            main_table_arity,
                            &mut main_table_column_index,
                            &node.flattened_name,
                            field,
                            nodes,
                        );
                        main_class.predicates.push(get_pred);
                        get_child_exprs.push(get_child_expr);
                    }

                    main_class.predicates.push(ql::Predicate {
                        name: "getAFieldOrChild".to_owned(),
                        overridden: true,
                        return_type: Some(ql::Type::Normal("AstNode".to_owned())),
                        formal_parameters: vec![],
                        body: ql::Expression::Or(get_child_exprs),
                    });
                }

                classes.push(ql::TopLevel::Class(main_class));
            }
        }
    }

    classes
}

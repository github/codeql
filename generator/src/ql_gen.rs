use crate::language::Language;
use crate::ql;
use std::collections::{BTreeSet, HashMap};
use std::fs::File;
use std::io::LineWriter;

type SupertypeMap = HashMap<String, BTreeSet<String>>;

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

/// Creates a map from QL class names to their supertypes.
fn create_supertype_map(nodes: &[node_types::Entry]) -> SupertypeMap {
    let mut map = SupertypeMap::new();
    for node in nodes {
        match &node {
            node_types::Entry::Union {
                type_name,
                members: n_members,
            } => {
                let supertype_class_name = dbscheme_name_to_class_name(&node_types::escape_name(
                    &node_types::node_type_name(&type_name.kind, type_name.named),
                ));
                for n_member in n_members {
                    let subtype_class_name = dbscheme_name_to_class_name(&node_types::escape_name(
                        &node_types::node_type_name(&n_member.kind, n_member.named),
                    ));
                    map.entry(subtype_class_name)
                        .or_insert_with(|| BTreeSet::new())
                        .insert(supertype_class_name.clone());
                }
            }
            node_types::Entry::Table { type_name, fields } => {
                let node_name = node_types::node_type_name(&type_name.kind, type_name.named);
                for field in fields {
                    if field.types.len() != 1 {
                        // This field can have one of several types. Since we create an ad-hoc
                        // QL union type to represent them, the class wrapping that union type
                        // will be a supertype of all its members.
                        let field_union_name = format!("{}_{}_type", &node_name, &field.get_name());
                        let field_union_name = node_types::escape_name(&field_union_name);
                        let supertype_name = dbscheme_name_to_class_name(&field_union_name);
                        for field_type in &field.types {
                            let member_name =
                                node_types::node_type_name(&field_type.kind, field_type.named);
                            let member_class_name =
                                dbscheme_name_to_class_name(&node_types::escape_name(&member_name));
                            map.entry(member_class_name)
                                .or_insert_with(|| BTreeSet::new())
                                .insert(supertype_name.clone());
                        }
                    }
                }
            }
            node_types::Entry::Token { .. } => {}
        }
    }

    map
}

fn get_base_classes(name: &str, supertype_map: &SupertypeMap) -> Vec<ql::Type> {
    let mut base_classes: Vec<ql::Type> = vec![ql::Type::Normal("AstNode".to_owned())];

    if let Some(supertypes) = supertype_map.get(name) {
        base_classes.extend(
            supertypes
                .into_iter()
                .map(|st| ql::Type::Normal(st.clone())),
        );
    }

    base_classes
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
        supertypes: vec![ql::Type::AtType("ast_node".to_owned())],
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
    let describe_ql_class = ql::Predicate {
        name: "describeQlClass".to_owned(),
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
        ],
        characteristic_predicate: None,
        predicates: vec![get_value, get_location, describe_ql_class],
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

/// Given the name of the parent node, and its field information, returns the
/// name of the field's type. This may be an ad-hoc union of all the possible
/// types the field can take, in which case we create a new class and push it to
/// `classes`.
fn create_field_class(
    token_kinds: &BTreeSet<String>,
    parent_name: &str,
    field: &node_types::Field,
    classes: &mut Vec<ql::TopLevel>,
    supertype_map: &SupertypeMap,
) -> String {
    if field.types.len() == 1 {
        // This field can only have a single type.
        let t = field.types.iter().next().unwrap();
        if !t.named || token_kinds.contains(&t.kind) {
            "Token".to_owned()
        } else {
            node_types::escape_name(&node_types::node_type_name(&t.kind, t.named))
        }
    } else {
        // This field can have one of several types. The dbscheme contains a
        // union type, so we create a QL class to wrap that.
        let field_union_name = format!("{}_{}_type", parent_name, &field.get_name());
        let field_union_name = node_types::escape_name(&field_union_name);
        let class_name = dbscheme_name_to_class_name(&field_union_name);
        classes.push(ql::TopLevel::Class(ql::Class {
            name: class_name.clone(),
            is_abstract: false,
            supertypes: [
                vec![ql::Type::AtType(field_union_name.clone())],
                get_base_classes(&class_name, &supertype_map),
            ]
            .concat(),
            characteristic_predicate: None,
            predicates: vec![create_describe_ql_class(&class_name)],
        }));
        field_union_name
    }
}

/// Given a valid dbscheme name (i.e. in snake case), produces the equivalent QL
/// name (i.e. in CamelCase). For example, "foo_bar_baz" becomes "FooBarBaz".
fn dbscheme_name_to_class_name(dbscheme_name: &str) -> String {
    fn to_title_case(word: &str) -> String {
        let mut first = true;
        let mut result = String::new();
        for c in word.chars() {
            if first {
                first = false;
                result.push(c.to_ascii_uppercase());
            } else {
                result.push(c);
            }
        }
        result
    }
    dbscheme_name
        .split('_')
        .map(|word| to_title_case(word))
        .collect::<Vec<String>>()
        .join("")
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
    field_type: &str,
) -> (ql::Predicate, ql::Expression) {
    let predicate_name = format!(
        "get{}",
        dbscheme_name_to_class_name(&node_types::escape_name(&field.get_name()))
    );
    let return_type = Some(ql::Type::Normal(dbscheme_name_to_class_name(field_type)));
    match &field.storage {
        node_types::Storage::Column => {
            let result = (
                ql::Predicate {
                    name: predicate_name,
                    overridden: false,
                    return_type: return_type,
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
                    return_type: return_type,
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
pub fn convert_nodes(nodes: &Vec<node_types::Entry>) -> Vec<ql::TopLevel> {
    let supertype_map = create_supertype_map(nodes);
    let mut classes: Vec<ql::TopLevel> = vec![
        ql::TopLevel::Import("codeql.files.FileSystem".to_owned()),
        ql::TopLevel::Import("codeql.Locations".to_owned()),
        ql::TopLevel::Class(create_ast_node_class()),
        ql::TopLevel::Class(create_token_class()),
    ];
    let mut token_kinds = BTreeSet::new();
    for node in nodes {
        if let node_types::Entry::Token { type_name, .. } = node {
            if type_name.named {
                token_kinds.insert(type_name.kind.to_owned());
            }
        }
    }

    for node in nodes {
        match &node {
            node_types::Entry::Token { .. } => {
                // don't generate any QL code for tokens
            }
            node_types::Entry::Union {
                type_name,
                members: _,
            } => {
                // It's a tree-sitter supertype node, so we're wrapping a dbscheme
                // union type.
                let union_name = node_types::escape_name(&node_types::node_type_name(
                    &type_name.kind,
                    type_name.named,
                ));
                let class_name = dbscheme_name_to_class_name(&union_name);
                classes.push(ql::TopLevel::Class(ql::Class {
                    name: class_name.clone(),
                    is_abstract: false,
                    supertypes: [
                        vec![ql::Type::AtType(union_name)],
                        get_base_classes(&class_name, &supertype_map),
                    ]
                    .concat(),
                    characteristic_predicate: None,
                    predicates: vec![create_describe_ql_class(&class_name)],
                }));
            }
            node_types::Entry::Table { type_name, fields } => {
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

                let name = node_types::node_type_name(&type_name.kind, type_name.named);
                let dbscheme_name = node_types::escape_name(&name);
                let ql_type = ql::Type::AtType(dbscheme_name.clone());
                let main_table_name = node_types::escape_name(&(format!("{}_def", name)));
                let main_class_name = dbscheme_name_to_class_name(&dbscheme_name);
                let mut main_class = ql::Class {
                    name: main_class_name.clone(),
                    is_abstract: false,
                    supertypes: [
                        vec![ql_type],
                        get_base_classes(&main_class_name, &supertype_map),
                    ]
                    .concat(),
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
                        let field_type = create_field_class(
                            &token_kinds,
                            &name,
                            field,
                            &mut classes,
                            &supertype_map,
                        );
                        let (get_pred, get_child_expr) = create_field_getters(
                            &main_table_name,
                            main_table_arity,
                            &mut main_table_column_index,
                            &name,
                            field,
                            &field_type,
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

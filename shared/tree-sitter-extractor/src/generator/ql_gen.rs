use std::collections::BTreeMap;
use std::collections::BTreeSet;

use crate::{generator::ql, node_types};

/// Creates the hard-coded `AstNode` class that acts as a supertype of all
/// classes we generate.
pub fn create_ast_node_class<'a>(
    ast_node: &'a str,
    node_location_table: &'a str,
    node_parent_table: &'a str,
) -> ql::Class<'a> {
    // Default implementation of `toString` calls `this.getAPrimaryQlClass()`
    let to_string = ql::Predicate {
        qldoc: Some(String::from(
            "Gets a string representation of this element.",
        )),
        name: "toString",
        overridden: false,
        is_private: false,
        is_final: false,
        return_type: Some(ql::Type::String),
        formal_parameters: vec![],
        body: Some(ql::Expression::Equals(
            Box::new(ql::Expression::Var("result")),
            Box::new(ql::Expression::Dot(
                Box::new(ql::Expression::Var("this")),
                "getAPrimaryQlClass",
                vec![],
            )),
        )),
        overlay: None,
    };
    let get_location = ql::Predicate {
        name: "getLocation",
        qldoc: Some(String::from("Gets the location of this element.")),
        overridden: false,
        is_private: false,
        is_final: true,
        return_type: Some(ql::Type::Normal("L::Location")),
        formal_parameters: vec![],
        body: Some(ql::Expression::Pred(
            node_location_table,
            vec![ql::Expression::Var("this"), ql::Expression::Var("result")],
        )),
        overlay: None,
    };
    let get_a_field_or_child = create_none_predicate(
        Some(String::from("Gets a field or child node of this node.")),
        "getAFieldOrChild",
        false,
        Some(ql::Type::Facade("AstNode")),
    );
    let get_parent = ql::Predicate {
        qldoc: Some(String::from("Gets the parent of this element.")),
        name: "getParent",
        overridden: false,
        is_private: false,
        is_final: true,
        return_type: Some(ql::Type::Facade("AstNode")),
        formal_parameters: vec![],
        body: Some(ql::Expression::Pred(
            node_parent_table,
            vec![
                ql::Expression::Var("this"),
                ql::Expression::Var("result"),
                ql::Expression::Var("_"),
            ],
        )),
        overlay: None,
    };
    let get_parent_index = ql::Predicate {
        qldoc: Some(String::from(
            "Gets the index of this node among the children of its parent.",
        )),
        name: "getParentIndex",
        overridden: false,
        is_private: false,
        is_final: true,
        return_type: Some(ql::Type::Int),
        formal_parameters: vec![],
        body: Some(ql::Expression::Pred(
            node_parent_table,
            vec![
                ql::Expression::Var("this"),
                ql::Expression::Var("_"),
                ql::Expression::Var("result"),
            ],
        )),
        overlay: None,
    };
    let get_a_primary_ql_class = ql::Predicate {
        qldoc: Some(String::from(
            "Gets the name of the primary QL class for this element.",
        )),
        name: "getAPrimaryQlClass",
        overridden: false,
        is_private: false,
        is_final: false,
        return_type: Some(ql::Type::String),
        formal_parameters: vec![],
        body: Some(ql::Expression::Equals(
            Box::new(ql::Expression::Var("result")),
            Box::new(ql::Expression::String("???")),
        )),
        overlay: None,
    };
    let get_primary_ql_classes = ql::Predicate {
        qldoc: Some(
            "Gets a comma-separated list of the names of the primary CodeQL \
             classes to which this element belongs."
                .to_owned(),
        ),
        name: "getPrimaryQlClasses",
        overridden: false,
        is_private: false,
        is_final: false,
        return_type: Some(ql::Type::String),
        formal_parameters: vec![],
        body: Some(ql::Expression::Equals(
            Box::new(ql::Expression::Var("result")),
            Box::new(ql::Expression::Aggregate {
                name: "concat",
                vars: vec![],
                range: None,
                expr: Box::new(ql::Expression::Dot(
                    Box::new(ql::Expression::Var("this")),
                    "getAPrimaryQlClass",
                    vec![],
                )),
                second_expr: Some(Box::new(ql::Expression::String(","))),
            }),
        )),
        overlay: None,
    };
    ql::Class {
        qldoc: Some(String::from("The base class for all AST nodes")),
        name: "AstNode",
        is_abstract: false,
        is_final: false,
        is_private: false,
        alias: None,
        supertypes: vec![ql::Type::At(ast_node)].into_iter().collect(),
        characteristic_predicate: None,
        predicates: vec![
            to_string,
            get_location,
            get_parent,
            get_parent_index,
            get_a_field_or_child,
            get_a_primary_ql_class,
            get_primary_ql_classes,
        ],
    }
}

pub fn create_token_class<'a>(token_type: &'a str, tokeninfo: &'a str) -> ql::Class<'a> {
    let tokeninfo_arity = 3; // id, kind, value
    let get_value = ql::Predicate {
        qldoc: Some(String::from("Gets the value of this token.")),
        name: "getValue",
        overridden: false,
        is_private: false,
        is_final: true,
        return_type: Some(ql::Type::String),
        formal_parameters: vec![],
        body: Some(create_get_field_expr_for_column_storage(
            "result",
            tokeninfo,
            1,
            tokeninfo_arity,
        )),
        overlay: None,
    };
    let to_string = ql::Predicate {
        qldoc: Some(String::from(
            "Gets a string representation of this element.",
        )),
        name: "toString",
        overridden: true,
        is_private: false,
        is_final: true,
        return_type: Some(ql::Type::String),
        formal_parameters: vec![],
        body: Some(ql::Expression::Equals(
            Box::new(ql::Expression::Var("result")),
            Box::new(ql::Expression::Dot(
                Box::new(ql::Expression::Var("this")),
                "getValue",
                vec![],
            )),
        )),
        overlay: None,
    };
    ql::Class {
        qldoc: Some(String::from("A token.")),
        name: "Token",
        is_abstract: false,
        is_final: false,
        is_private: false,
        alias: None,
        supertypes: vec![ql::Type::At(token_type), ql::Type::Facade("AstNode")]
            .into_iter()
            .collect(),
        characteristic_predicate: None,
        predicates: vec![
            get_value,
            to_string,
            create_get_a_primary_ql_class("Token", false),
        ],
    }
}

/// Creates the `TriviaToken` class. Trivia tokens (e.g. comments) are
/// `extra` nodes preserved from the original parse tree even when the tree has
/// been rewritten by a desugaring pass. They are not part of the regular
/// `Token` hierarchy because they do not appear in the (possibly desugared)
/// output schema.
pub fn create_trivia_token_class<'a>(
    trivia_token_type: &'a str,
    trivia_tokeninfo: &'a str,
) -> ql::Class<'a> {
    let trivia_tokeninfo_arity = 3; // id, kind, value
    let get_value = ql::Predicate {
        qldoc: Some(String::from("Gets the source text of this trivia token.")),
        name: "getValue",
        overridden: false,
        is_private: false,
        is_final: true,
        return_type: Some(ql::Type::String),
        formal_parameters: vec![],
        body: Some(create_get_field_expr_for_column_storage(
            "result",
            trivia_tokeninfo,
            1,
            trivia_tokeninfo_arity,
        )),
        overlay: None,
    };
    let to_string = ql::Predicate {
        qldoc: Some(String::from(
            "Gets a string representation of this element.",
        )),
        name: "toString",
        overridden: true,
        is_private: false,
        is_final: true,
        return_type: Some(ql::Type::String),
        formal_parameters: vec![],
        body: Some(ql::Expression::Equals(
            Box::new(ql::Expression::Var("result")),
            Box::new(ql::Expression::Dot(
                Box::new(ql::Expression::Var("this")),
                "getValue",
                vec![],
            )),
        )),
        overlay: None,
    };
    ql::Class {
        qldoc: Some(String::from(
            "A trivia token, such as a comment, preserved from the original parse tree.",
        )),
        name: "TriviaToken",
        is_abstract: false,
        is_final: false,
        is_private: false,
        alias: None,
        supertypes: vec![ql::Type::At(trivia_token_type), ql::Type::Facade("AstNode")]
            .into_iter()
            .collect(),
        characteristic_predicate: None,
        predicates: vec![
            get_value,
            to_string,
            create_get_a_primary_ql_class("TriviaToken", false),
        ],
    }
}

// Creates the `ReservedWord` class.
pub fn create_reserved_word_class(db_name: &str) -> ql::Class<'_> {
    let class_name = "ReservedWord";
    let get_a_primary_ql_class = create_get_a_primary_ql_class(class_name, true);
    ql::Class {
        qldoc: Some(String::from("A reserved word.")),
        name: class_name,
        is_abstract: false,
        is_final: false,
        is_private: false,
        alias: None,
        supertypes: vec![ql::Type::At(db_name), ql::Type::Facade("Token")]
            .into_iter()
            .collect(),
        characteristic_predicate: None,
        predicates: vec![get_a_primary_ql_class],
    }
}

/// Creates a predicate whose body is `none()`.
fn create_none_predicate<'a>(
    qldoc: Option<String>,
    name: &'a str,
    overridden: bool,
    return_type: Option<ql::Type<'a>>,
) -> ql::Predicate<'a> {
    ql::Predicate {
        qldoc,
        name,
        overridden,
        is_private: false,
        is_final: false,
        return_type,
        formal_parameters: Vec::new(),
        body: Some(ql::Expression::Pred("none", vec![])),
        overlay: None,
    }
}

/// Creates an overridden `getAPrimaryQlClass` predicate that returns the given
/// name.
fn create_get_a_primary_ql_class(class_name: &str, is_final: bool) -> ql::Predicate<'_> {
    ql::Predicate {
        qldoc: Some(String::from(
            "Gets the name of the primary QL class for this element.",
        )),
        name: "getAPrimaryQlClass",
        overridden: true,
        is_private: false,
        is_final,
        return_type: Some(ql::Type::String),
        formal_parameters: vec![],
        body: Some(ql::Expression::Equals(
            Box::new(ql::Expression::Var("result")),
            Box::new(ql::Expression::String(class_name)),
        )),
        overlay: None,
    }
}

pub fn create_is_overlay_predicate() -> ql::Predicate<'static> {
    ql::Predicate {
        name: "isOverlay",
        qldoc: Some(String::from("Holds if the database is an overlay.")),
        overridden: false,
        is_private: true,
        is_final: false,
        return_type: None,
        overlay: Some(ql::OverlayAnnotation::Local),
        formal_parameters: vec![],
        body: Some(ql::Expression::Pred(
            "databaseMetadata",
            vec![
                ql::Expression::String("isOverlay"),
                ql::Expression::String("true"),
            ],
        )),
    }
}

pub fn create_get_node_file_predicate<'a>(
    ast_node_name: &'a str,
    node_location_table_name: &'a str,
) -> ql::Predicate<'a> {
    ql::Predicate {
        name: "getNodeFile",
        qldoc: Some(String::from("Gets the file containing the given `node`.")),
        overridden: false,
        is_private: true,
        is_final: false,
        overlay: None,
        return_type: Some(ql::Type::At("file")),
        formal_parameters: vec![ql::FormalParameter {
            name: "node",
            param_type: ql::Type::At(ast_node_name),
        }],
        body: Some(ql::Expression::Aggregate {
            name: "exists",
            vars: vec![ql::FormalParameter {
                name: "loc",
                param_type: ql::Type::At("location_default"),
            }],
            range: Some(Box::new(ql::Expression::Pred(
                node_location_table_name,
                vec![ql::Expression::Var("node"), ql::Expression::Var("loc")],
            ))),
            expr: Box::new(ql::Expression::Pred(
                "locations_default",
                vec![
                    ql::Expression::Var("loc"),
                    ql::Expression::Var("result"),
                    ql::Expression::Var("_"),
                    ql::Expression::Var("_"),
                    ql::Expression::Var("_"),
                    ql::Expression::Var("_"),
                ],
            )),
            second_expr: None,
        }),
    }
}

pub fn create_discardable_ast_node_predicate(ast_node_name: &str) -> ql::Predicate<'_> {
    ql::Predicate {
        name: "discardableAstNode",
        qldoc: Some(String::from(
            "Holds if `node` is in the `file` and is part of the overlay base database.",
        )),
        overridden: false,
        is_private: true,
        is_final: false,
        overlay: None,
        return_type: None,
        formal_parameters: vec![
            ql::FormalParameter {
                name: "file",
                param_type: ql::Type::At("file"),
            },
            ql::FormalParameter {
                name: "node",
                param_type: ql::Type::At(ast_node_name),
            },
        ],
        body: Some(ql::Expression::And(vec![
            ql::Expression::Negation(Box::new(ql::Expression::Pred("isOverlay", vec![]))),
            ql::Expression::Equals(
                Box::new(ql::Expression::Var("file")),
                Box::new(ql::Expression::Pred(
                    "getNodeFile",
                    vec![ql::Expression::Var("node")],
                )),
            ),
        ])),
    }
}

pub fn create_discard_ast_node_predicate(ast_node_name: &str) -> ql::Predicate<'_> {
    ql::Predicate {
        name: "discardAstNode",
        qldoc: Some(String::from(
            "Holds if `node` should be discarded, because it is part of the overlay base \
            and is in a file that was also extracted as part of the overlay database.",
        )),
        overridden: false,
        is_private: true,
        is_final: false,
        overlay: Some(ql::OverlayAnnotation::DiscardEntity),
        return_type: None,
        formal_parameters: vec![ql::FormalParameter {
            name: "node",
            param_type: ql::Type::At(ast_node_name),
        }],
        body: Some(ql::Expression::Aggregate {
            name: "exists",
            vars: vec![
                ql::FormalParameter {
                    name: "file",
                    param_type: ql::Type::At("file"),
                },
                ql::FormalParameter {
                    name: "path",
                    param_type: ql::Type::String,
                },
            ],
            range: Some(Box::new(ql::Expression::Pred(
                "files",
                vec![ql::Expression::Var("file"), ql::Expression::Var("path")],
            ))),
            expr: Box::new(ql::Expression::And(vec![
                ql::Expression::Pred(
                    "discardableAstNode",
                    vec![ql::Expression::Var("file"), ql::Expression::Var("node")],
                ),
                ql::Expression::Pred("overlayChangedFiles", vec![ql::Expression::Var("path")]),
            ])),
            second_expr: None,
        }),
    }
}

pub fn create_discardable_location_predicate() -> ql::Predicate<'static> {
    ql::Predicate {
        name: "discardableLocation",
        qldoc: Some(String::from(
            "Holds if `loc` is in the `file` and is part of the overlay base database.",
        )),
        overridden: false,
        is_private: true,
        is_final: false,
        overlay: Some(ql::OverlayAnnotation::Local),
        return_type: None,
        formal_parameters: vec![
            ql::FormalParameter {
                name: "file",
                param_type: ql::Type::At("file"),
            },
            ql::FormalParameter {
                name: "loc",
                param_type: ql::Type::At("location_default"),
            },
        ],
        body: Some(ql::Expression::And(vec![
            ql::Expression::Negation(Box::new(ql::Expression::Pred("isOverlay", vec![]))),
            ql::Expression::Pred(
                "locations_default",
                vec![
                    ql::Expression::Var("loc"),
                    ql::Expression::Var("file"),
                    ql::Expression::Var("_"),
                    ql::Expression::Var("_"),
                    ql::Expression::Var("_"),
                    ql::Expression::Var("_"),
                ],
            ),
        ])),
    }
}

/// Creates a discard predicate for `@location_default` entities. This is necessary because the
/// tree-sitter extractors use `*` IDs for locations, which means that locations don't get shared
/// between the base and overlay databases.
pub fn create_discard_location_predicate() -> ql::Predicate<'static> {
    ql::Predicate {
        name: "discardLocation",
        qldoc: Some(String::from(
            "Holds if `loc` should be discarded, because it is part of the overlay base \
            and is in a file that was also extracted as part of the overlay database.",
        )),
        overridden: false,
        is_private: true,
        is_final: false,
        overlay: Some(ql::OverlayAnnotation::DiscardEntity),
        return_type: None,
        formal_parameters: vec![ql::FormalParameter {
            name: "loc",
            param_type: ql::Type::At("location_default"),
        }],
        body: Some(ql::Expression::Aggregate {
            name: "exists",
            vars: vec![
                ql::FormalParameter {
                    name: "file",
                    param_type: ql::Type::At("file"),
                },
                ql::FormalParameter {
                    name: "path",
                    param_type: ql::Type::String,
                },
            ],
            range: Some(Box::new(ql::Expression::Pred(
                "files",
                vec![ql::Expression::Var("file"), ql::Expression::Var("path")],
            ))),
            expr: Box::new(ql::Expression::And(vec![
                ql::Expression::Pred(
                    "discardableLocation",
                    vec![ql::Expression::Var("file"), ql::Expression::Var("loc")],
                ),
                ql::Expression::Pred("overlayChangedFiles", vec![ql::Expression::Var("path")]),
            ])),
            second_expr: None,
        }),
    }
}

/// Returns an expression to get a field that's defined as a column in the parent's table.
///
/// # Arguments
///
/// * `result_var_name` - the name of the variable to which the resulting value should be bound
/// * `table_name` - the name of parent's defining table
/// * `column_index` - the index in that table that defines the field
/// * `arity` - the total number of columns in the table
fn create_get_field_expr_for_column_storage<'a>(
    result_var_name: &'a str,
    table_name: &'a str,
    column_index: usize,
    arity: usize,
) -> ql::Expression<'a> {
    let num_underscores_before = column_index;
    let num_underscores_after = arity - 2 - num_underscores_before;
    ql::Expression::Pred(
        table_name,
        [
            vec![ql::Expression::Var("this")],
            vec![ql::Expression::Var("_"); num_underscores_before],
            vec![ql::Expression::Var(result_var_name)],
            vec![ql::Expression::Var("_"); num_underscores_after],
        ]
        .concat(),
    )
}

/// Returns an expression to get the field with the given index from its
/// auxiliary table. The index name can be "_" so the expression will hold for
/// all indices.
fn create_get_field_expr_for_table_storage<'a>(
    result_var_name: &'a str,
    table_name: &'a str,
    index_var_name: Option<&'a str>,
) -> ql::Expression<'a> {
    ql::Expression::Pred(
        table_name,
        match index_var_name {
            Some(index_var_name) => vec![
                ql::Expression::Var("this"),
                ql::Expression::Var(index_var_name),
                ql::Expression::Var(result_var_name),
            ],
            None => vec![ql::Expression::Var("this"), ql::Expression::Var("result")],
        },
    )
}

/// Creates a list of predicates to get the given field, and an optional
/// expression that will get the same field. When the field can occur multiple
/// times, this includes an indexed getter and a convenience getter that returns
/// any member; the expression uses the "don't care" expression to hold for all
/// occurrences.
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
fn create_field_getters<'a>(
    main_table_name: &'a str,
    main_table_arity: usize,
    main_table_column_index: &mut usize,
    field: &'a node_types::Field,
    nodes: &'a node_types::NodeTypeMap,
) -> (Vec<ql::Predicate<'a>>, Option<ql::Expression<'a>>) {
    let return_type = match &field.type_info {
        node_types::FieldTypeInfo::Single(t) => {
            Some(ql::Type::Facade(&nodes.get(t).unwrap().ql_class_name))
        }
        node_types::FieldTypeInfo::Multiple {
            types: _,
            dbscheme_union: _,
            ql_class,
        } => Some(ql::Type::Facade(ql_class)),
        node_types::FieldTypeInfo::ReservedWordInt(_) => Some(ql::Type::String),
    };
    let formal_parameters = match &field.storage {
        node_types::Storage::Column { .. } => vec![],
        node_types::Storage::Table { has_index, .. } => {
            if *has_index {
                vec![ql::FormalParameter {
                    name: "i",
                    param_type: ql::Type::Int,
                }]
            } else {
                vec![]
            }
        }
    };

    // For the expression to get a value, what variable name should the result
    // be bound to?
    let get_value_result_var_name = match &field.type_info {
        node_types::FieldTypeInfo::ReservedWordInt(_) => "value",
        node_types::FieldTypeInfo::Single(_) => "result",
        node_types::FieldTypeInfo::Multiple { .. } => "result",
    };

    // Two expressions for getting the value. One that's suitable use in the
    // getter predicate (where there may be a specific index), and another for
    // use in `getAFieldOrChild` (where we use a "don't care" expression to
    // match any index).
    let (get_value, get_value_any_index) = match &field.storage {
        node_types::Storage::Column { name: _ } => {
            let column_index = *main_table_column_index;
            *main_table_column_index += 1;
            (
                create_get_field_expr_for_column_storage(
                    get_value_result_var_name,
                    main_table_name,
                    column_index,
                    main_table_arity,
                ),
                create_get_field_expr_for_column_storage(
                    get_value_result_var_name,
                    main_table_name,
                    column_index,
                    main_table_arity,
                ),
            )
        }
        node_types::Storage::Table {
            name: field_table_name,
            has_index,
            column_name: _,
        } => (
            create_get_field_expr_for_table_storage(
                get_value_result_var_name,
                field_table_name,
                if *has_index { Some("i") } else { None },
            ),
            create_get_field_expr_for_table_storage(
                get_value_result_var_name,
                field_table_name,
                if *has_index { Some("_") } else { None },
            ),
        ),
    };
    let (body, optional_expr) = match &field.type_info {
        node_types::FieldTypeInfo::ReservedWordInt(int_mapping) => {
            // Create an expression that binds the corresponding string to `result` for each `value`, e.g.:
            //   result = "foo" and value = 0 or
            //   result = "bar" and value = 1 or
            //   result = "baz" and value = 2
            let disjuncts = int_mapping
                .iter()
                .map(|(token_str, (value, _))| {
                    ql::Expression::And(vec![
                        ql::Expression::Equals(
                            Box::new(ql::Expression::Var("result")),
                            Box::new(ql::Expression::String(token_str)),
                        ),
                        ql::Expression::Equals(
                            Box::new(ql::Expression::Var("value")),
                            Box::new(ql::Expression::Integer(*value as i64)),
                        ),
                    ])
                })
                .collect();
            (
                ql::Expression::Aggregate {
                    name: "exists",
                    vars: vec![ql::FormalParameter {
                        name: "value",
                        param_type: ql::Type::Int,
                    }],
                    range: Some(Box::new(get_value)),
                    expr: Box::new(ql::Expression::Or(disjuncts)),
                    second_expr: None,
                },
                // Since the getter returns a string and not an AstNode, it won't be part of getAFieldOrChild:
                None,
            )
        }
        node_types::FieldTypeInfo::Single(_) | node_types::FieldTypeInfo::Multiple { .. } => {
            (get_value, Some(get_value_any_index))
        }
    };
    let qldoc = match &field.name {
        Some(name) => format!("Gets the node corresponding to the field `{name}`."),
        None => {
            if formal_parameters.is_empty() {
                "Gets the child of this node.".to_owned()
            } else {
                "Gets the `i`th child of this node.".to_owned()
            }
        }
    };
    let mut predicates = vec![ql::Predicate {
        qldoc: Some(qldoc.clone()),
        name: &field.getter_name,
        overridden: false,
        is_private: false,
        is_final: true,
        return_type: return_type.clone(),
        formal_parameters,
        body: Some(body),
        overlay: None,
    }];

    if let Some(any_getter_name) = &field.any_getter_name {
        predicates.push(ql::Predicate {
            qldoc: Some(qldoc.clone()),
            name: any_getter_name,
            overridden: false,
            is_private: false,
            is_final: true,
            return_type,
            formal_parameters: vec![],
            body: Some(ql::Expression::Equals(
                Box::new(ql::Expression::Var("result")),
                Box::new(ql::Expression::Dot(
                    Box::new(ql::Expression::Var("this")),
                    &field.getter_name,
                    vec![ql::Expression::Var("_")],
                )),
            )),
            overlay: None,
        });
    }

    (predicates, optional_expr)
}

fn compute_direct_supertypes(
    nodes: &node_types::NodeTypeMap,
) -> std::collections::BTreeMap<node_types::TypeName, BTreeSet<&str>> {
    let mut supertypes = std::collections::BTreeMap::new();
    for node in nodes.values() {
        if let node_types::EntryKind::Union { members } = &node.kind {
            for member in members {
                supertypes
                    .entry(member.clone())
                    .or_insert_with(BTreeSet::new)
                    .insert(node.ql_class_name.as_str());
            }
        }
    }
    supertypes
}

fn ast_base_types<'a>(
    type_name: &node_types::TypeName,
    direct_supertypes: &std::collections::BTreeMap<node_types::TypeName, BTreeSet<&'a str>>,
) -> BTreeSet<ql::Type<'a>> {
    match direct_supertypes.get(type_name) {
        Some(supertypes) if !supertypes.is_empty() => supertypes
            .iter()
            .map(|name| ql::Type::Facade(name))
            .collect(),
        _ => vec![ql::Type::Facade("AstNode")].into_iter().collect(),
    }
}

fn class_supertypes<'a>(
    type_name: &node_types::TypeName,
    dbscheme_name: &'a str,
    direct_supertypes: &std::collections::BTreeMap<node_types::TypeName, BTreeSet<&'a str>>,
) -> BTreeSet<ql::Type<'a>> {
    let mut supertypes = ast_base_types(type_name, direct_supertypes);
    supertypes.insert(ql::Type::At(dbscheme_name));
    supertypes
}

/// Returns whether `a` and `b` have the same signature, i.e. the same name,
/// return type, and formal parameters. Predicates with the same signature can
/// override one another.
fn same_predicate_signature(a: &ql::Predicate, b: &ql::Predicate) -> bool {
    a.name == b.name && a.return_type == b.return_type && a.formal_parameters == b.formal_parameters
}

/// Computes, for each tree-sitter supertype (union) node, the list of
/// predicates that are guaranteed to be defined identically (in terms of
/// name, return type, and formal parameters, though not necessarily body) by
/// every one of its members. These are the predicates that can be hoisted to
/// an `abstract` predicate on the union's class, with the corresponding
/// predicates on its members becoming `override`s.
///
/// The result for a given node is memoized in `cache`, and also used to
/// answer the query for any other node that (directly, or transitively
/// through further supertypes) has that node as a member.
fn compute_exposed_predicates<'a>(
    type_name: &node_types::TypeName,
    nodes: &'a node_types::NodeTypeMap,
    field_predicates: &BTreeMap<&node_types::TypeName, Vec<ql::Predicate<'a>>>,
    cache: &mut BTreeMap<node_types::TypeName, Vec<ql::Predicate<'a>>>,
) -> Vec<ql::Predicate<'a>> {
    if let Some(exposed) = cache.get(type_name) {
        return exposed.clone();
    }
    let exposed = match nodes.get(type_name).map(|node| &node.kind) {
        Some(node_types::EntryKind::Table { .. }) => {
            field_predicates.get(type_name).cloned().unwrap_or_default()
        }
        Some(node_types::EntryKind::Union { members }) => {
            let mut members = members.iter();
            let mut common = match members.next() {
                Some(first) => compute_exposed_predicates(first, nodes, field_predicates, cache),
                None => Vec::new(),
            };
            for member in members {
                let member_predicates =
                    compute_exposed_predicates(member, nodes, field_predicates, cache);
                common.retain(|predicate| {
                    member_predicates
                        .iter()
                        .any(|other| same_predicate_signature(predicate, other))
                });
            }
            common
        }
        Some(node_types::EntryKind::Token { .. }) | None => Vec::new(),
    };
    cache.insert(type_name.clone(), exposed.clone());
    exposed
}

/// Returns whether `predicate` (declared, or about to be declared, on the
/// class for `type_name`) is already exposed by one of `type_name`'s direct
/// supertypes, and therefore must be marked as an `override` (for a concrete
/// predicate) or can be omitted entirely (for an `abstract` one, since it's
/// already inherited).
fn is_predicate_inherited(
    predicate: &ql::Predicate,
    type_name: &node_types::TypeName,
    direct_supertypes: &BTreeMap<node_types::TypeName, BTreeSet<&str>>,
    exposed_by_class_name: &BTreeMap<&str, Vec<ql::Predicate>>,
) -> bool {
    direct_supertypes.get(type_name).is_some_and(|supertypes| {
        supertypes.iter().any(|supertype| {
            exposed_by_class_name
                .get(supertype)
                .is_some_and(|predicates| {
                    predicates
                        .iter()
                        .any(|other| same_predicate_signature(predicate, other))
                })
        })
    })
}

/// Converts the given node types into CodeQL classes wrapping the dbscheme.
pub fn convert_nodes(nodes: &node_types::NodeTypeMap) -> Vec<ql::TopLevel<'_>> {
    let mut classes = Vec::new();
    let mut token_kinds = BTreeSet::new();
    let direct_supertypes = compute_direct_supertypes(nodes);
    for (type_name, node) in nodes {
        if let node_types::EntryKind::Token { .. } = &node.kind
            && type_name.named
        {
            token_kinds.insert(&type_name.kind);
        }
    }

    // First, compute the field-getter predicates (and the expressions used by
    // `getAFieldOrChild`) for every table node, without yet knowing whether
    // any of them will need to be marked `override`. These are needed both
    // to build the final classes below, and to figure out which fields are
    // shared identically by all the members of a supertype.
    let mut field_predicates: BTreeMap<&node_types::TypeName, Vec<ql::Predicate<'_>>> =
        BTreeMap::new();
    let mut get_child_exprs: BTreeMap<&node_types::TypeName, Vec<ql::Expression<'_>>> =
        BTreeMap::new();
    for (type_name, node) in nodes {
        if let node_types::EntryKind::Table {
            name: main_table_name,
            fields,
        } = &node.kind
        {
            if fields.is_empty() {
                panic!("Encountered node '{}' with no fields", type_name.kind);
            }

            // Count how many columns there will be in the main table. There
            // will be one for the id, plus one for each field that's stored
            // as a column.
            let main_table_arity = 1 + fields
                .iter()
                .filter(|&f| matches!(f.storage, node_types::Storage::Column { .. }))
                .count();

            let mut main_table_column_index: usize = 0;
            let mut predicates = Vec::new();
            let mut exprs = Vec::new();
            for field in fields {
                let (get_preds, get_child_expr) = create_field_getters(
                    main_table_name,
                    main_table_arity,
                    &mut main_table_column_index,
                    field,
                    nodes,
                );
                predicates.extend(get_preds);
                if let Some(get_child_expr) = get_child_expr {
                    exprs.push(get_child_expr)
                }
            }
            field_predicates.insert(type_name, predicates);
            get_child_exprs.insert(type_name, exprs);
        }
    }

    // Next, for every supertype (union) node, compute the predicates that are
    // guaranteed to be defined identically (in name, return type, and formal
    // parameters) by every one of its members. Such predicates can be hoisted
    // to an `abstract` predicate on the supertype's class, with the
    // corresponding predicates on its members becoming `override`s.
    let mut exposed_predicates_cache: BTreeMap<node_types::TypeName, Vec<ql::Predicate<'_>>> =
        BTreeMap::new();
    let mut exposed_by_class_name: BTreeMap<&str, Vec<ql::Predicate<'_>>> = BTreeMap::new();
    for (type_name, node) in nodes {
        if let node_types::EntryKind::Union { .. } = &node.kind {
            let exposed = compute_exposed_predicates(
                type_name,
                nodes,
                &field_predicates,
                &mut exposed_predicates_cache,
            );
            exposed_by_class_name.insert(node.ql_class_name.as_str(), exposed);
        }
    }

    for (type_name, node) in nodes {
        match &node.kind {
            node_types::EntryKind::Token { kind_id: _ } => {
                if type_name.named {
                    let get_a_primary_ql_class =
                        create_get_a_primary_ql_class(&node.ql_class_name, true);
                    let mut supertypes =
                        class_supertypes(type_name, &node.dbscheme_name, &direct_supertypes);
                    supertypes.insert(ql::Type::Facade("Token"));
                    classes.push(ql::TopLevel::Class(ql::Class {
                        qldoc: Some(format!("A class representing `{}` tokens.", type_name.kind)),
                        name: &node.ql_class_name,
                        is_abstract: false,
                        is_final: false,
                        is_private: false,
                        alias: None,
                        supertypes,
                        characteristic_predicate: None,
                        predicates: vec![get_a_primary_ql_class],
                    }));
                }
            }
            node_types::EntryKind::Union { members: _ } => {
                // It's a tree-sitter supertype node, so we're wrapping a dbscheme
                // union type. Any predicate that's identically defined by every
                // member becomes an `abstract` predicate here, unless it's
                // already inherited (and thus abstract) via one of this
                // supertype's own direct supertypes.
                let predicates = exposed_predicates_cache
                    .get(type_name)
                    .cloned()
                    .unwrap_or_default()
                    .into_iter()
                    .filter(|predicate| {
                        !is_predicate_inherited(
                            predicate,
                            type_name,
                            &direct_supertypes,
                            &exposed_by_class_name,
                        )
                    })
                    .map(|predicate| ql::Predicate {
                        overridden: false,
                        is_private: false,
                        is_final: false,
                        body: None,
                        ..predicate
                    })
                    .collect();
                classes.push(ql::TopLevel::Class(ql::Class {
                    qldoc: None,
                    name: &node.ql_class_name,
                    is_abstract: false,
                    is_final: false,
                    is_private: false,
                    alias: None,
                    supertypes: class_supertypes(
                        type_name,
                        &node.dbscheme_name,
                        &direct_supertypes,
                    ),
                    characteristic_predicate: None,
                    predicates,
                }));
            }
            node_types::EntryKind::Table { .. } => {
                let main_class_name = &node.ql_class_name;
                let mut main_class = ql::Class {
                    qldoc: Some(format!("A class representing `{}` nodes.", type_name.kind)),
                    name: main_class_name,
                    is_abstract: false,
                    is_final: false,
                    is_private: false,
                    alias: None,
                    supertypes: class_supertypes(
                        type_name,
                        &node.dbscheme_name,
                        &direct_supertypes,
                    ),
                    characteristic_predicate: None,
                    predicates: vec![create_get_a_primary_ql_class(main_class_name, true)],
                };

                // A field getter that's identically defined (in signature) by
                // every member of one of this node's direct supertypes is an
                // override of the corresponding `abstract` predicate declared
                // there.
                main_class.predicates.extend(
                    field_predicates
                        .get(type_name)
                        .cloned()
                        .unwrap_or_default()
                        .into_iter()
                        .map(|predicate| {
                            let overridden = predicate.overridden
                                || is_predicate_inherited(
                                    &predicate,
                                    type_name,
                                    &direct_supertypes,
                                    &exposed_by_class_name,
                                );
                            ql::Predicate {
                                overridden,
                                ..predicate
                            }
                        }),
                );

                main_class.predicates.push(ql::Predicate {
                    qldoc: Some(String::from("Gets a field or child node of this node.")),
                    name: "getAFieldOrChild",
                    overridden: true,
                    is_private: false,
                    is_final: true,
                    return_type: Some(ql::Type::Facade("AstNode")),
                    formal_parameters: vec![],
                    body: Some(ql::Expression::Or(
                        get_child_exprs.get(type_name).cloned().unwrap_or_default(),
                    )),
                    overlay: None,
                });

                classes.push(ql::TopLevel::Class(main_class));
            }
        }
    }

    classes
}

/// Creates a `PrintAst` module containing a `getChild` predicate that maps each
/// AST node to its children together with the name of the member predicate that
/// produced them (and, for indexed fields, the index). This mirrors the
/// information exposed by `getAFieldOrChild`, but keeps the member predicate
/// name and index so that an AST printer can render labelled edges.
pub fn create_print_ast_module(nodes: &node_types::NodeTypeMap) -> ql::TopLevel<'_> {
    let mut disjuncts: Vec<ql::Expression> = Vec::new();
    for node in nodes.values() {
        if let node_types::EntryKind::Table { name: _, fields } = &node.kind {
            for field in fields {
                // `ReservedWordInt` fields have string-valued getters, so they
                // are not children and are excluded (just as they are from
                // `getAFieldOrChild`).
                if matches!(
                    field.type_info,
                    node_types::FieldTypeInfo::ReservedWordInt(_)
                ) {
                    continue;
                }
                let has_index = matches!(
                    field.storage,
                    node_types::Storage::Table {
                        has_index: true,
                        ..
                    }
                );
                let getter_call = ql::Expression::Dot(
                    Box::new(ql::Expression::Cast(
                        Box::new(ql::Expression::Var("node")),
                        &node.ql_class_name,
                    )),
                    &field.getter_name,
                    if has_index {
                        vec![ql::Expression::Var("i")]
                    } else {
                        vec![]
                    },
                );
                let mut conjuncts = vec![ql::Expression::Equals(
                    Box::new(ql::Expression::Var("result")),
                    Box::new(getter_call),
                )];
                if !has_index {
                    conjuncts.push(ql::Expression::Equals(
                        Box::new(ql::Expression::Var("i")),
                        Box::new(ql::Expression::Integer(-1)),
                    ));
                }
                conjuncts.push(ql::Expression::Equals(
                    Box::new(ql::Expression::Var("name")),
                    Box::new(ql::Expression::String(&field.getter_name)),
                ));
                disjuncts.push(ql::Expression::And(conjuncts));
            }
        }
    }

    let get_child = ql::Predicate {
        qldoc: Some(String::from(
            "Gets a child of `node` returned by the member predicate with the given `name`. \
             If the predicate takes an index argument, `i` is bound to that index, otherwise \
             `i` is `-1` (which is never a valid index).",
        )),
        name: "getChild",
        overridden: false,
        is_private: false,
        is_final: false,
        return_type: Some(ql::Type::Facade("AstNode")),
        formal_parameters: vec![
            ql::FormalParameter {
                name: "node",
                param_type: ql::Type::Facade("AstNode"),
            },
            ql::FormalParameter {
                name: "name",
                param_type: ql::Type::String,
            },
            ql::FormalParameter {
                name: "i",
                param_type: ql::Type::Int,
            },
        ],
        body: Some(ql::Expression::Or(disjuncts)),
        overlay: None,
    };

    ql::TopLevel::Module(ql::Module {
        qldoc: Some(String::from(
            "Provides predicates for mapping AST nodes to their named children.",
        )),
        name: "PrintAst",
        body: vec![ql::TopLevel::Predicate(get_child)],
        overlay: None,
    })
}

#[cfg(test)]
mod tests {
    use super::*;

    /// Builds a small node-types fixture in which a supertype (`loop_stmt`)
    /// has three members that all share an identical `body?: block` field,
    /// as well as a `condition`/`iterable` field that differs in name across
    /// members (and so should *not* be hoisted).
    fn loop_stmt_fixture() -> node_types::NodeTypeMap {
        let json = r#"[
            {
                "type": "loop_stmt",
                "named": true,
                "subtypes": [
                    {"type": "for_each_stmt", "named": true},
                    {"type": "while_stmt", "named": true},
                    {"type": "do_while_stmt", "named": true}
                ]
            },
            {
                "type": "block",
                "named": true,
                "fields": {},
                "children": {"multiple": true, "required": false, "types": [{"type": "expr_placeholder", "named": true}]}
            },
            {
                "type": "expr_placeholder",
                "named": true,
                "fields": {},
                "children": null
            },
            {
                "type": "for_each_stmt",
                "named": true,
                "fields": {
                    "body": {"multiple": false, "required": false, "types": [{"type": "block", "named": true}]},
                    "iterable": {"multiple": false, "required": true, "types": [{"type": "expr_placeholder", "named": true}]}
                },
                "children": null
            },
            {
                "type": "while_stmt",
                "named": true,
                "fields": {
                    "body": {"multiple": false, "required": false, "types": [{"type": "block", "named": true}]},
                    "condition": {"multiple": false, "required": true, "types": [{"type": "expr_placeholder", "named": true}]}
                },
                "children": null
            },
            {
                "type": "do_while_stmt",
                "named": true,
                "fields": {
                    "body": {"multiple": false, "required": false, "types": [{"type": "block", "named": true}]},
                    "condition": {"multiple": false, "required": true, "types": [{"type": "expr_placeholder", "named": true}]}
                },
                "children": null
            }
        ]"#;
        node_types::read_node_types_str("test", json).unwrap()
    }

    #[test]
    fn hoists_field_shared_by_all_members_of_a_supertype() {
        let nodes = loop_stmt_fixture();
        let classes = convert_nodes(&nodes);

        fn find_class<'a, 'b>(classes: &'a [ql::TopLevel<'b>], name: &str) -> &'a ql::Class<'b> {
            classes
                .iter()
                .find_map(|c| match c {
                    ql::TopLevel::Class(class) if class.name == name => Some(class),
                    _ => None,
                })
                .unwrap_or_else(|| panic!("no class named {name}"))
        }
        fn find_predicate<'a, 'b>(class: &'a ql::Class<'b>, name: &str) -> &'a ql::Predicate<'b> {
            class
                .predicates
                .iter()
                .find(|p| p.name == name)
                .unwrap_or_else(|| panic!("class {} has no predicate {name}", class.name))
        }

        // `LoopStmt` should have gained an abstract `getBody` predicate,
        // since all of its members have an identically-shaped `body` field.
        let loop_stmt = find_class(&classes, "LoopStmt");
        let get_body = find_predicate(loop_stmt, "getBody");
        assert!(get_body.body.is_none(), "getBody should be abstract");
        assert!(!get_body.overridden);
        assert!(matches!(
            get_body.return_type,
            Some(ql::Type::Facade("Block"))
        ));
        assert!(get_body.formal_parameters.is_empty());

        // None of the members have an identically-shaped `condition` or
        // `iterable` field (the name differs between `for_each_stmt` and the
        // other two), so no such predicate should be hoisted.
        assert!(
            !loop_stmt
                .predicates
                .iter()
                .any(|p| p.name == "getCondition" || p.name == "getIterable")
        );

        // Each member should still define `getBody`, but now as an override
        // of the abstract predicate declared on `LoopStmt`.
        for member in ["ForEachStmt", "WhileStmt", "DoWhileStmt"] {
            let class = find_class(&classes, member);
            let get_body = find_predicate(class, "getBody");
            assert!(
                get_body.body.is_some(),
                "{member}'s getBody should have a body"
            );
            assert!(
                get_body.overridden,
                "{member}'s getBody should be an override"
            );
        }
    }
}

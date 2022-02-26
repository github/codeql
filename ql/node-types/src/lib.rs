use serde::Deserialize;
use std::collections::BTreeMap;
use std::path::Path;

use std::collections::BTreeSet as Set;
use std::fs;

/// A lookup table from TypeName to Entry.
pub type NodeTypeMap = BTreeMap<TypeName, Entry>;

#[derive(Debug)]
pub struct Entry {
    pub dbscheme_name: String,
    pub ql_class_name: String,
    pub kind: EntryKind,
}

#[derive(Debug)]
pub enum EntryKind {
    Union { members: Set<TypeName> },
    Table { name: String, fields: Vec<Field> },
    Token { kind_id: usize },
}

#[derive(Debug, Ord, PartialOrd, Eq, PartialEq)]
pub struct TypeName {
    pub kind: String,
    pub named: bool,
}

#[derive(Debug)]
pub enum FieldTypeInfo {
    /// The field has a single type.
    Single(TypeName),

    /// The field can take one of several types, so we also provide the name of
    /// the database union type that wraps them, and the corresponding QL class
    /// name.
    Multiple {
        types: Set<TypeName>,
        dbscheme_union: String,
        ql_class: String,
    },

    /// The field can be one of several tokens, so the db type will be an `int`
    /// with a `case @foo.kind` for each possiblity.
    ReservedWordInt(BTreeMap<String, (usize, String)>),
}

#[derive(Debug)]
pub struct Field {
    pub parent: TypeName,
    pub type_info: FieldTypeInfo,
    /// The name of the field or None for the anonymous 'children'
    /// entry from node_types.json
    pub name: Option<String>,
    /// The name of the predicate to get this field.
    pub getter_name: String,
    pub storage: Storage,
}

fn name_for_field_or_child(name: &Option<String>) -> String {
    match name {
        Some(name) => name.clone(),
        None => "child".to_owned(),
    }
}

#[derive(Debug)]
pub enum Storage {
    /// the field is stored as a column in the parent table
    Column { name: String },
    /// the field is stored in a link table
    Table {
        /// the name of the table
        name: String,
        /// the name of the column for the field in the dbscheme
        column_name: String,
        /// does it have an associated index column?
        has_index: bool,
    },
}

pub fn read_node_types(prefix: &str, node_types_path: &Path) -> std::io::Result<NodeTypeMap> {
    let file = fs::File::open(node_types_path)?;
    let node_types: Vec<NodeInfo> = serde_json::from_reader(file)?;
    Ok(convert_nodes(prefix, &node_types))
}

pub fn read_node_types_str(prefix: &str, node_types_json: &str) -> std::io::Result<NodeTypeMap> {
    let node_types: Vec<NodeInfo> = serde_json::from_str(node_types_json)?;
    Ok(convert_nodes(prefix, &node_types))
}

fn convert_type(node_type: &NodeType) -> TypeName {
    TypeName {
        kind: node_type.kind.to_string(),
        named: node_type.named,
    }
}

fn convert_types(node_types: &[NodeType]) -> Set<TypeName> {
    node_types.iter().map(convert_type).collect()
}

pub fn convert_nodes(prefix: &str, nodes: &[NodeInfo]) -> NodeTypeMap {
    let mut entries = NodeTypeMap::new();
    let mut token_kinds = Set::new();

    // First, find all the token kinds
    for node in nodes {
        if node.subtypes.is_none()
            && node.fields.as_ref().map_or(0, |x| x.len()) == 0
            && node.children.is_none()
        {
            let type_name = TypeName {
                kind: node.kind.clone(),
                named: node.named,
            };
            token_kinds.insert(type_name);
        }
    }

    for node in nodes {
        let flattened_name = &node_type_name(&node.kind, node.named);
        let dbscheme_name = escape_name(flattened_name);
        let ql_class_name = dbscheme_name_to_class_name(&dbscheme_name);
        let dbscheme_name = format!("{}_{}", prefix, &dbscheme_name);
        if let Some(subtypes) = &node.subtypes {
            // It's a tree-sitter supertype node, for which we create a union
            // type.
            entries.insert(
                TypeName {
                    kind: node.kind.clone(),
                    named: node.named,
                },
                Entry {
                    dbscheme_name,
                    ql_class_name,
                    kind: EntryKind::Union {
                        members: convert_types(subtypes),
                    },
                },
            );
        } else if node.fields.as_ref().map_or(0, |x| x.len()) == 0 && node.children.is_none() {
            // Token kind, handled above.
        } else {
            // It's a product type, defined by a table.
            let type_name = TypeName {
                kind: node.kind.clone(),
                named: node.named,
            };
            let table_name = escape_name(&(format!("{}_def", &flattened_name)));
            let table_name = format!("{}_{}", prefix, &table_name);

            let mut fields = Vec::new();

            // If the type also has fields or children, then we create either
            // auxiliary tables or columns in the defining table for them.
            if let Some(node_fields) = &node.fields {
                for (field_name, field_info) in node_fields {
                    add_field(
                        prefix,
                        &type_name,
                        Some(field_name.to_string()),
                        field_info,
                        &mut fields,
                        &token_kinds,
                    );
                }
            }
            if let Some(children) = &node.children {
                // Treat children as if they were a field called 'child'.
                add_field(
                    prefix,
                    &type_name,
                    None,
                    children,
                    &mut fields,
                    &token_kinds,
                );
            }
            entries.insert(
                type_name,
                Entry {
                    dbscheme_name,
                    ql_class_name,
                    kind: EntryKind::Table {
                        name: table_name,
                        fields,
                    },
                },
            );
        }
    }
    let mut counter = 0;
    for type_name in token_kinds {
        let entry = if type_name.named {
            counter += 1;
            let unprefixed_name = node_type_name(&type_name.kind, true);
            Entry {
                dbscheme_name: escape_name(&format!("{}_token_{}", &prefix, &unprefixed_name)),
                ql_class_name: dbscheme_name_to_class_name(&escape_name(&unprefixed_name)),
                kind: EntryKind::Token { kind_id: counter },
            }
        } else {
            Entry {
                dbscheme_name: format!("{}_reserved_word", &prefix),
                ql_class_name: "ReservedWord".to_owned(),
                kind: EntryKind::Token { kind_id: 0 },
            }
        };
        entries.insert(type_name, entry);
    }
    entries
}

fn add_field(
    prefix: &str,
    parent_type_name: &TypeName,
    field_name: Option<String>,
    field_info: &FieldInfo,
    fields: &mut Vec<Field>,
    token_kinds: &Set<TypeName>,
) {
    let parent_flattened_name = node_type_name(&parent_type_name.kind, parent_type_name.named);
    let column_name = escape_name(&name_for_field_or_child(&field_name));
    let storage = if !field_info.multiple && field_info.required {
        // This field must appear exactly once, so we add it as
        // a column to the main table for the node type.
        Storage::Column { name: column_name }
    } else {
        // Put the field in an auxiliary table.
        let has_index = field_info.multiple;
        let field_table_name = escape_name(&format!(
            "{}_{}_{}",
            &prefix,
            parent_flattened_name,
            &name_for_field_or_child(&field_name)
        ));
        Storage::Table {
            has_index,
            name: field_table_name,
            column_name,
        }
    };
    let converted_types = convert_types(&field_info.types);
    let type_info = if field_info
        .types
        .iter()
        .all(|t| !t.named && token_kinds.contains(&convert_type(t)))
    {
        // All possible types for this field are reserved words. The db
        // representation will be an `int` with a `case @foo.field = ...` to
        // enumerate the possible values.
        let mut field_token_ints: BTreeMap<String, (usize, String)> = BTreeMap::new();
        for (counter, t) in converted_types.into_iter().enumerate() {
            let dbscheme_variant_name =
                escape_name(&format!("{}_{}_{}", &prefix, parent_flattened_name, t.kind));
            field_token_ints.insert(t.kind.to_owned(), (counter, dbscheme_variant_name));
        }
        FieldTypeInfo::ReservedWordInt(field_token_ints)
    } else if field_info.types.len() == 1 {
        FieldTypeInfo::Single(converted_types.into_iter().next().unwrap())
    } else {
        // The dbscheme type for this field will be a union. In QL, it'll just be AstNode.
        FieldTypeInfo::Multiple {
            types: converted_types,
            dbscheme_union: format!(
                "{}_{}_{}_type",
                &prefix,
                &parent_flattened_name,
                &name_for_field_or_child(&field_name)
            ),
            ql_class: "AstNode".to_owned(),
        }
    };
    let getter_name = format!(
        "get{}",
        dbscheme_name_to_class_name(&escape_name(&name_for_field_or_child(&field_name)))
    );
    fields.push(Field {
        parent: TypeName {
            kind: parent_type_name.kind.to_string(),
            named: parent_type_name.named,
        },
        type_info,
        name: field_name,
        getter_name,
        storage,
    });
}
#[derive(Deserialize)]
pub struct NodeInfo {
    #[serde(rename = "type")]
    pub kind: String,
    pub named: bool,
    #[serde(skip_serializing_if = "Option::is_none")]
    pub fields: Option<BTreeMap<String, FieldInfo>>,
    #[serde(skip_serializing_if = "Option::is_none")]
    pub children: Option<FieldInfo>,
    #[serde(skip_serializing_if = "Option::is_none")]
    pub subtypes: Option<Vec<NodeType>>,
}

#[derive(Deserialize)]
pub struct NodeType {
    #[serde(rename = "type")]
    pub kind: String,
    pub named: bool,
}

#[derive(Deserialize)]
pub struct FieldInfo {
    pub multiple: bool,
    pub required: bool,
    pub types: Vec<NodeType>,
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

const RESERVED_KEYWORDS: [&str; 14] = [
    "boolean", "case", "date", "float", "int", "key", "of", "order", "ref", "string", "subtype",
    "type", "unique", "varchar",
];

/// Returns a string that's a copy of `name` but suitably escaped to be a valid
/// QL identifier.
fn escape_name(name: &str) -> String {
    let mut result = String::new();

    // If there's a leading underscore, replace it with 'underscore_'.
    if let Some(c) = name.chars().next() {
        if c == '_' {
            result.push_str("underscore");
        }
    }
    for c in name.chars() {
        match c {
            '{' => result.push_str("lbrace"),
            '}' => result.push_str("rbrace"),
            '<' => result.push_str("langle"),
            '>' => result.push_str("rangle"),
            '[' => result.push_str("lbracket"),
            ']' => result.push_str("rbracket"),
            '(' => result.push_str("lparen"),
            ')' => result.push_str("rparen"),
            '|' => result.push_str("pipe"),
            '=' => result.push_str("equal"),
            '~' => result.push_str("tilde"),
            '?' => result.push_str("question"),
            '`' => result.push_str("backtick"),
            '^' => result.push_str("caret"),
            '!' => result.push_str("bang"),
            '#' => result.push_str("hash"),
            '%' => result.push_str("percent"),
            '&' => result.push_str("ampersand"),
            '.' => result.push_str("dot"),
            ',' => result.push_str("comma"),
            '/' => result.push_str("slash"),
            ':' => result.push_str("colon"),
            ';' => result.push_str("semicolon"),
            '"' => result.push_str("dquote"),
            '*' => result.push_str("star"),
            '+' => result.push_str("plus"),
            '-' => result.push_str("minus"),
            '@' => result.push_str("at"),
            _ if c.is_uppercase() => {
                result.push('_');
                result.push_str(&c.to_lowercase().to_string())
            }
            _ => result.push(c),
        }
    }

    for &keyword in &RESERVED_KEYWORDS {
        if result == keyword {
            result.push_str("__");
            break;
        }
    }

    result
}

pub fn to_snake_case(word: &str) -> String {
    let mut prev_upper = true;
    let mut result = String::new();
    for c in word.chars() {
        if c.is_uppercase() {
            if !prev_upper {
                result.push('_')
            }
            prev_upper = true;
            result.push(c.to_ascii_lowercase());
        } else {
            prev_upper = false;
            result.push(c);
        }
    }
    result
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
        .map(to_title_case)
        .collect::<Vec<String>>()
        .join("")
}

#[test]
fn to_snake_case_test() {
    assert_eq!("python", to_snake_case("Python"));
    assert_eq!("yaml", to_snake_case("YAML"));
    assert_eq!("set_literal", to_snake_case("SetLiteral"));
}

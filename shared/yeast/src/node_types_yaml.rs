/// Converts a YAML node-types file to the tree-sitter `node-types.json` format.
///
/// # YAML format
///
/// ```yaml
/// supertypes:
///   _expression:
///     - assignment
///     - binary
///
/// named:
///   assignment:
///     left: _lhs
///     right: _expression
///   identifier:
///
/// unnamed:
///   - "+"
///   - "end"
/// ```
///
/// See the crate-level docs for the full format specification.
use std::collections::{BTreeMap, BTreeSet};
use std::fmt::Write;

use crate::CHILD_FIELD;
use serde::Deserialize;
use serde_json::json;

/// Top-level YAML structure.
#[derive(Deserialize, Default)]
struct YamlNodeTypes {
    #[serde(default)]
    supertypes: BTreeMap<String, Vec<TypeRef>>,
    #[serde(default)]
    named: BTreeMap<String, Option<BTreeMap<String, TypeRefOrList>>>,
    #[serde(default)]
    unnamed: Vec<String>,
}

/// A reference to a node type. Can be:
/// - a plain string (resolved by looking up named vs unnamed)
/// - a map `{unnamed: "name"}` to force unnamed interpretation
#[derive(Deserialize, Debug, Clone)]
#[serde(untagged)]
enum TypeRef {
    Name(String),
    Explicit { unnamed: String },
}

/// A field value: either a single type ref or a list of them.
#[derive(Deserialize, Debug, Clone)]
#[serde(untagged)]
enum TypeRefOrList {
    Single(TypeRef),
    List(Vec<TypeRef>),
}

impl TypeRefOrList {
    fn into_vec(self) -> Vec<TypeRef> {
        match self {
            TypeRefOrList::Single(t) => vec![t],
            TypeRefOrList::List(v) => v,
        }
    }
}

/// Parsed field name: base name + multiplicity markers.
struct FieldSpec {
    name: Option<String>, // None for $children
    multiple: bool,
    required: bool,
}

fn parse_field_name(raw: &str) -> FieldSpec {
    let is_children =
        raw == "$children" || raw == "$children?" || raw == "$children*" || raw == "$children+";

    let suffix = raw.chars().last().filter(|c| matches!(c, '?' | '*' | '+'));

    let (multiple, required) = match suffix {
        Some('?') => (false, false),
        Some('*') => (true, false),
        Some('+') => (true, true),
        _ => (false, true), // bare field name = required, single
    };

    let name = if is_children {
        None
    } else {
        let base = raw.trim_end_matches(['?', '*', '+']);
        Some(base.to_string())
    };

    FieldSpec {
        name,
        multiple,
        required,
    }
}

/// Resolve a TypeRef to a (type, named) pair, given the sets of known named
/// and unnamed types.
fn resolve_type_ref_pair(
    type_ref: &TypeRef,
    named_types: &BTreeSet<String>,
    unnamed_types: &BTreeSet<String>,
) -> (String, bool) {
    match type_ref {
        TypeRef::Explicit { unnamed } => (unnamed.clone(), false),
        TypeRef::Name(name) => {
            let is_named = named_types.contains(name);
            let is_unnamed = unnamed_types.contains(name);
            if is_named && is_unnamed {
                (name.clone(), true)
            } else if is_unnamed {
                (name.clone(), false)
            } else {
                (name.clone(), true)
            }
        }
    }
}

/// Resolve a TypeRef to a {type, named} JSON record, given the sets of known named
/// and unnamed types.
fn resolve_type_ref(
    type_ref: &TypeRef,
    named_types: &BTreeSet<String>,
    unnamed_types: &BTreeSet<String>,
) -> serde_json::Value {
    let (kind, named) = resolve_type_ref_pair(type_ref, named_types, unnamed_types);
    json!({"type": kind, "named": named})
}

/// Convert YAML string to node-types JSON string.
pub fn convert(yaml_input: &str) -> Result<String, String> {
    let yaml: YamlNodeTypes =
        serde_yaml::from_str(yaml_input).map_err(|e| format!("Failed to parse YAML: {e}"))?;

    // Build the sets of known named and unnamed types for resolution.
    let mut named_types = BTreeSet::new();
    for name in yaml.supertypes.keys() {
        named_types.insert(name.clone());
    }
    for name in yaml.named.keys() {
        named_types.insert(name.clone());
    }
    let unnamed_types: BTreeSet<String> = yaml.unnamed.iter().cloned().collect();

    let mut output = Vec::new();

    // 1. Supertypes
    for (name, members) in &yaml.supertypes {
        let subtypes: Vec<_> = members
            .iter()
            .map(|m| resolve_type_ref(m, &named_types, &unnamed_types))
            .collect();
        output.push(json!({
            "type": name,
            "named": true,
            "subtypes": subtypes,
        }));
    }

    // 2. Named nodes
    for (name, fields_opt) in &yaml.named {
        let fields_map = match fields_opt {
            None => {
                // Leaf token: no fields, no children, no subtypes
                output.push(json!({
                    "type": name,
                    "named": true,
                    "fields": {},
                }));
                continue;
            }
            Some(m) if m.is_empty() => {
                output.push(json!({
                    "type": name,
                    "named": true,
                    "fields": {},
                }));
                continue;
            }
            Some(m) => m,
        };

        let mut json_fields = serde_json::Map::new();
        let mut json_children: Option<serde_json::Value> = None;

        for (raw_field_name, type_refs) in fields_map {
            let spec = parse_field_name(raw_field_name);
            let types: Vec<_> = type_refs
                .clone()
                .into_vec()
                .iter()
                .map(|t| resolve_type_ref(t, &named_types, &unnamed_types))
                .collect();

            // Cloning to make the borrow checker happy
            let field_info = json!({
                "multiple": spec.multiple,
                "required": spec.required,
                "types": types,
            });

            if spec.name.is_none() {
                // $children
                json_children = Some(field_info);
            } else {
                json_fields.insert(spec.name.unwrap(), field_info);
            }
        }

        let mut entry = json!({
            "type": name,
            "named": true,
            "fields": json_fields,
        });

        if let Some(children) = json_children {
            entry
                .as_object_mut()
                .unwrap()
                .insert("children".to_string(), children);
        }

        output.push(entry);
    }

    // 3. Unnamed tokens
    for name in &yaml.unnamed {
        output.push(json!({
            "type": name,
            "named": false,
        }));
    }

    serde_json::to_string_pretty(&output).map_err(|e| format!("Failed to serialize JSON: {e}"))
}

/// Apply YAML node-type definitions to a mutable Schema.
/// Registers all types, fields, and allowed types from the YAML into the schema.
fn apply_yaml_to_schema(yaml: &YamlNodeTypes, schema: &mut crate::schema::Schema) {
    // Register all supertypes as node kinds
    for name in yaml.supertypes.keys() {
        schema.register_kind(name);
    }

    // Register named node kinds and their fields
    for (name, fields_opt) in &yaml.named {
        schema.register_kind(name);
        if let Some(fields) = fields_opt {
            for raw_field_name in fields.keys() {
                let spec = parse_field_name(raw_field_name);
                if let Some(field_name) = &spec.name {
                    schema.register_field(field_name);
                }
            }
        }
    }

    // Register unnamed tokens as node kinds
    for name in &yaml.unnamed {
        schema.register_unnamed_kind(name);
    }

    let mut named_types = BTreeSet::new();
    for name in yaml.supertypes.keys() {
        named_types.insert(name.clone());
    }
    for name in yaml.named.keys() {
        named_types.insert(name.clone());
    }
    let unnamed_types: BTreeSet<String> = yaml.unnamed.iter().cloned().collect();

    for (supertype, members) in &yaml.supertypes {
        let node_types = members
            .iter()
            .map(|m| {
                let (kind, named) = resolve_type_ref_pair(m, &named_types, &unnamed_types);
                crate::schema::NodeType { kind, named }
            })
            .collect();
        schema.set_supertype_members(supertype, node_types);
    }

    // Register allowed field child types for type checking.
    for (parent_kind, fields_opt) in &yaml.named {
        let Some(fields) = fields_opt else {
            continue;
        };

        for (raw_field_name, type_refs) in fields {
            let spec = parse_field_name(raw_field_name);
            let field_id = match &spec.name {
                Some(name) => schema.register_field(name),
                None => CHILD_FIELD,
            };

            let mut node_types = type_refs
                .clone()
                .into_vec()
                .into_iter()
                .map(|type_ref| {
                    let (kind, named) =
                        resolve_type_ref_pair(&type_ref, &named_types, &unnamed_types);
                    crate::schema::NodeType { kind, named }
                })
                .collect::<Vec<_>>();
            node_types.sort_by(|a, b| a.kind.cmp(&b.kind).then(a.named.cmp(&b.named)));
            node_types.dedup_by(|a, b| a.kind == b.kind && a.named == b.named);
            schema.set_field_types(parent_kind, field_id, node_types);
            schema.set_field_cardinality(
                parent_kind,
                field_id,
                crate::schema::FieldCardinality {
                    multiple: spec.multiple,
                    required: spec.required,
                },
            );
        }
    }
}

pub fn schema_from_yaml(yaml_input: &str) -> Result<crate::schema::Schema, String> {
    let yaml: YamlNodeTypes =
        serde_yaml::from_str(yaml_input).map_err(|e| format!("Failed to parse YAML: {e}"))?;

    let mut schema = crate::schema::Schema::new();
    apply_yaml_to_schema(&yaml, &mut schema);

    Ok(schema)
}

/// Build a Schema from a YAML string, extending a tree-sitter Language.
/// The Schema inherits all field/kind names from the Language, plus any
/// additional ones defined in the YAML.
pub fn schema_from_yaml_with_language(
    yaml_input: &str,
    language: &tree_sitter::Language,
) -> Result<crate::schema::Schema, String> {
    let yaml: YamlNodeTypes =
        serde_yaml::from_str(yaml_input).map_err(|e| format!("Failed to parse YAML: {e}"))?;

    let mut schema = crate::schema::Schema::from_language(language);
    apply_yaml_to_schema(&yaml, &mut schema);

    Ok(schema)
}

// ---------------------------------------------------------------------------
// JSON → YAML conversion
// ---------------------------------------------------------------------------

/// JSON node-types structures (mirrors tree-sitter's format).
#[derive(Deserialize)]
struct JsonNodeInfo {
    #[serde(rename = "type")]
    kind: String,
    named: bool,
    #[serde(default)]
    fields: BTreeMap<String, JsonFieldInfo>,
    children: Option<JsonFieldInfo>,
    #[serde(default)]
    subtypes: Vec<JsonNodeType>,
}

#[derive(Deserialize)]
struct JsonNodeType {
    #[serde(rename = "type")]
    kind: String,
    named: bool,
}

#[derive(Deserialize)]
struct JsonFieldInfo {
    multiple: bool,
    required: bool,
    types: Vec<JsonNodeType>,
}

/// Convert a tree-sitter node-types.json string to the YAML format.
pub fn convert_from_json(json_input: &str) -> Result<String, String> {
    let nodes: Vec<JsonNodeInfo> =
        serde_json::from_str(json_input).map_err(|e| format!("Failed to parse JSON: {e}"))?;

    // Collect all named and unnamed types for disambiguation decisions.
    let mut all_named: BTreeSet<String> = BTreeSet::new();
    let mut all_unnamed: BTreeSet<String> = BTreeSet::new();
    for node in &nodes {
        if node.named {
            all_named.insert(node.kind.clone());
        } else {
            all_unnamed.insert(node.kind.clone());
        }
    }

    let mut supertypes: BTreeMap<String, Vec<JsonNodeType>> = BTreeMap::new();
    let mut named: BTreeMap<String, Option<BTreeMap<String, JsonFieldInfo>>> = BTreeMap::new();
    let mut unnamed: Vec<String> = Vec::new();

    for node in nodes {
        if !node.named {
            unnamed.push(node.kind);
            continue;
        }

        if !node.subtypes.is_empty() {
            supertypes.insert(node.kind, node.subtypes);
            continue;
        }

        if node.fields.is_empty() && node.children.is_none() {
            // Leaf token
            named.insert(node.kind, None);
        } else {
            let mut fields = BTreeMap::new();
            for (name, info) in node.fields {
                fields.insert(name, info);
            }
            if let Some(children) = node.children {
                fields.insert("$children".to_string(), children);
            }
            named.insert(node.kind, Some(fields));
        }
    }

    // Now emit YAML
    let mut out = String::new();

    // Supertypes
    if !supertypes.is_empty() {
        writeln!(out, "supertypes:").unwrap();
        for (name, members) in &supertypes {
            writeln!(out, "  {name}:").unwrap();
            for member in members {
                let ref_str = format_type_ref(&member.kind, member.named, &all_named, &all_unnamed);
                writeln!(out, "    - {ref_str}").unwrap();
            }
        }
        writeln!(out).unwrap();
    }

    // Named
    if !named.is_empty() {
        writeln!(out, "named:").unwrap();
        for (name, fields_opt) in &named {
            match fields_opt {
                None => {
                    writeln!(out, "  {name}:").unwrap();
                }
                Some(fields) => {
                    writeln!(out, "  {name}:").unwrap();
                    for (field_name, info) in fields {
                        let suffix = field_suffix(info.multiple, info.required);
                        let yaml_name = if field_name == "$children" {
                            format!("$children{suffix}")
                        } else {
                            format!("{field_name}{suffix}")
                        };

                        let type_refs: Vec<String> = info
                            .types
                            .iter()
                            .map(|t| format_type_ref(&t.kind, t.named, &all_named, &all_unnamed))
                            .collect();

                        if type_refs.len() == 1 {
                            writeln!(out, "    {yaml_name}: {}", type_refs[0]).unwrap();
                        } else {
                            let list = type_refs
                                .iter()
                                .map(|s| s.as_str())
                                .collect::<Vec<_>>()
                                .join(", ");
                            writeln!(out, "    {yaml_name}: [{list}]").unwrap();
                        }
                    }
                }
            }
        }
        writeln!(out).unwrap();
    }

    // Unnamed
    if !unnamed.is_empty() {
        writeln!(out, "unnamed:").unwrap();
        for name in &unnamed {
            writeln!(out, "  - {}", force_quote(name)).unwrap();
        }
    }

    Ok(out)
}

fn field_suffix(multiple: bool, required: bool) -> &'static str {
    match (multiple, required) {
        (false, true) => "",
        (false, false) => "?",
        (true, true) => "+",
        (true, false) => "*",
    }
}

/// Format a type reference for YAML output. Uses the disambiguation rule:
/// plain string if unambiguous, `{unnamed: name}` if the name exists as both
/// named and unnamed and we need the unnamed interpretation.
fn format_type_ref(
    kind: &str,
    named: bool,
    all_named: &BTreeSet<String>,
    _all_unnamed: &BTreeSet<String>,
) -> String {
    if named {
        quote_yaml(kind)
    } else {
        let is_also_named = all_named.contains(kind);
        if is_also_named {
            format!("{{unnamed: {}}}", force_quote(kind))
        } else {
            force_quote(kind)
        }
    }
}

/// Always wrap in double quotes. Used for unnamed node references so they're
/// visually distinct from named ones — YAML treats both forms as equivalent strings.
fn force_quote(s: &str) -> String {
    format!("\"{}\"", s.replace('\\', "\\\\").replace('"', "\\\""))
}

/// Quote a YAML string value if it contains special characters or could be
/// misinterpreted.
fn quote_yaml(s: &str) -> String {
    let needs_quoting = s.is_empty()
        || s.contains(|c: char| {
            matches!(
                c,
                ':' | '{'
                    | '}'
                    | '['
                    | ']'
                    | ','
                    | '&'
                    | '*'
                    | '#'
                    | '?'
                    | '|'
                    | '-'
                    | '<'
                    | '>'
                    | '='
                    | '!'
                    | '%'
                    | '@'
                    | '`'
                    | '"'
                    | '\''
            )
        })
        || s.starts_with(' ')
        || s.ends_with(' ')
        || s == "true"
        || s == "false"
        || s == "null"
        || s == "yes"
        || s == "no"
        || s.parse::<f64>().is_ok();

    if needs_quoting {
        format!("\"{}\"", s.replace('\\', "\\\\").replace('"', "\\\""))
    } else {
        s.to_string()
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_basic_conversion() {
        let yaml = r#"
supertypes:
  _expression:
    - assignment
    - binary

named:
  assignment:
    left: _lhs
    right: _expression
  binary:
    left: [_expression, _simple_numeric]
    operator: ["!=", "+"]
    right: _expression
  argument_list:
    $children*: [_expression, block_argument]
  identifier:

unnamed:
  - "!="
  - "+"
  - "end"
"#;

        let json_str = convert(yaml).unwrap();
        let result: Vec<serde_json::Value> = serde_json::from_str(&json_str).unwrap();

        // Check supertype
        let expr = &result[0];
        assert_eq!(expr["type"], "_expression");
        assert_eq!(expr["named"], true);
        assert_eq!(expr["subtypes"].as_array().unwrap().len(), 2);

        // Check assignment
        let assign = result.iter().find(|n| n["type"] == "assignment").unwrap();
        assert_eq!(assign["fields"]["left"]["required"], true);
        assert_eq!(assign["fields"]["left"]["multiple"], false);
        assert_eq!(assign["fields"]["left"]["types"][0]["type"], "_lhs");
        assert_eq!(assign["fields"]["left"]["types"][0]["named"], true);

        // Check binary.operator — "!=" and "+" should resolve to unnamed
        let binary = result.iter().find(|n| n["type"] == "binary").unwrap();
        let op_types = binary["fields"]["operator"]["types"].as_array().unwrap();
        assert_eq!(op_types[0]["type"], "!=");
        assert_eq!(op_types[0]["named"], false);
        assert_eq!(op_types[1]["type"], "+");
        assert_eq!(op_types[1]["named"], false);

        // Check argument_list has children, not a field
        let arg_list = result
            .iter()
            .find(|n| n["type"] == "argument_list")
            .unwrap();
        assert!(arg_list.get("children").is_some());
        assert_eq!(arg_list["children"]["multiple"], true);
        assert_eq!(arg_list["children"]["required"], false);

        // Check identifier is a leaf
        let ident = result.iter().find(|n| n["type"] == "identifier").unwrap();
        assert_eq!(ident["fields"].as_object().unwrap().len(), 0);

        // Check unnamed tokens
        let end = result.iter().find(|n| n["type"] == "end").unwrap();
        assert_eq!(end["named"], false);
    }

    #[test]
    fn test_explicit_unnamed_disambiguation() {
        let yaml = r#"
named:
  foo:
    field: [{unnamed: bar}]

unnamed:
  - bar
"#;

        let json_str = convert(yaml).unwrap();
        let result: Vec<serde_json::Value> = serde_json::from_str(&json_str).unwrap();
        let foo = result.iter().find(|n| n["type"] == "foo").unwrap();
        assert_eq!(foo["fields"]["field"]["types"][0]["named"], false);
    }

    #[test]
    fn test_field_suffixes() {
        let yaml = r#"
named:
  test_node:
    required_single: foo
    optional_single?: foo
    required_multiple+: foo
    optional_multiple*: foo
"#;

        let json_str = convert(yaml).unwrap();
        let result: Vec<serde_json::Value> = serde_json::from_str(&json_str).unwrap();
        let node = result.iter().find(|n| n["type"] == "test_node").unwrap();
        let fields = node["fields"].as_object().unwrap();

        assert_eq!(fields["required_single"]["required"], true);
        assert_eq!(fields["required_single"]["multiple"], false);

        assert_eq!(fields["optional_single"]["required"], false);
        assert_eq!(fields["optional_single"]["multiple"], false);

        assert_eq!(fields["required_multiple"]["required"], true);
        assert_eq!(fields["required_multiple"]["multiple"], true);

        assert_eq!(fields["optional_multiple"]["required"], false);
        assert_eq!(fields["optional_multiple"]["multiple"], true);
    }

    #[test]
    fn test_json_to_yaml() {
        let json = r#"[
            {"type": "_expression", "named": true, "subtypes": [
                {"type": "assignment", "named": true},
                {"type": "identifier", "named": true}
            ]},
            {"type": "assignment", "named": true, "fields": {
                "left": {"multiple": false, "required": true, "types": [
                    {"type": "_expression", "named": true}
                ]},
                "right": {"multiple": false, "required": false, "types": [
                    {"type": "_expression", "named": true}
                ]}
            }, "children": {
                "multiple": true, "required": false, "types": [
                    {"type": "identifier", "named": true}
                ]
            }},
            {"type": "identifier", "named": true, "fields": {}},
            {"type": "=", "named": false},
            {"type": "end", "named": false}
        ]"#;

        let yaml = convert_from_json(json).unwrap();

        // Verify key structures are present
        assert!(yaml.contains("supertypes:"));
        assert!(yaml.contains("_expression:"));
        assert!(yaml.contains("named:"));
        assert!(yaml.contains("assignment:"));
        assert!(yaml.contains("left:"));
        assert!(yaml.contains("right?:"));
        assert!(yaml.contains("$children*:"));
        assert!(yaml.contains("identifier:"));
        assert!(yaml.contains("unnamed:"));
        assert!(yaml.contains("\"=\""));
        assert!(yaml.contains("end"));
    }

    #[test]
    fn test_round_trip() {
        let yaml_input = r#"
supertypes:
  _expression:
    - assignment
    - identifier

named:
  assignment:
    left: _expression
    right?: _expression
    $children*: identifier
  identifier:

unnamed:
  - "="
  - end
"#;

        // YAML → JSON → YAML
        let json = convert(yaml_input).unwrap();
        let yaml_output = convert_from_json(&json).unwrap();
        // YAML → JSON again (should be identical)
        let json2 = convert(&yaml_output).unwrap();

        let v1: serde_json::Value = serde_json::from_str(&json).unwrap();
        let v2: serde_json::Value = serde_json::from_str(&json2).unwrap();
        assert_eq!(v1, v2);
    }
}

//! YAML/JSON node-types loaders for YEAST.
//!
//! The pure YAML/JSON conversion routines live in [`yeast_schema::node_types_yaml`].
//! This module re-exports them and adds the tree-sitter-aware adapter
//! [`schema_from_yaml_with_language`].

pub use yeast_schema::node_types_yaml::{
    convert, convert_from_json, extend_schema_from_yaml, schema_from_yaml,
};

/// Build a Schema from a YAML string, layered on top of a tree-sitter
/// `Language`. The Schema inherits all field/kind names from the language
/// (preserving the language's IDs), plus any additional ones defined in
/// the YAML.
pub fn schema_from_yaml_with_language(
    yaml_input: &str,
    language: &tree_sitter::Language,
) -> Result<crate::schema::Schema, String> {
    let mut schema = crate::schema::from_language(language);
    extend_schema_from_yaml(&mut schema, yaml_input)?;
    Ok(schema)
}

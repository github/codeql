//! YEAST schema types.
//!
//! The schema struct itself lives in the [`yeast_schema`] crate (so it can
//! be shared with the `yeast-macros` proc-macro crate without dragging
//! tree-sitter into proc-macro compiles). This module re-exports its
//! public API and supplies the one tree-sitter-aware adapter the runtime
//! needs: [`from_language`].

pub use yeast_schema::schema::{FieldCardinality, NodeType, Schema};

/// Build a [`Schema`] from a tree-sitter language, importing all its
/// known field and kind names so the resulting schema's IDs line up with
/// the language's own IDs (i.e. `field_name_for_id` agrees).
pub fn from_language(language: &tree_sitter::Language) -> Schema {
    let mut schema = Schema::new();

    // Import all field names, preserving tree-sitter's IDs.
    for id in 1..=language.field_count() as u16 {
        if let Some(name) = language.field_name_for_id(id) {
            schema.register_field_with_id(name, id);
        }
    }

    // Import all node kind names, preserving tree-sitter's IDs.
    // Track named and unnamed variants separately. For both, prefer the
    // canonical ID returned by `id_for_node_kind`, since some languages
    // have multiple IDs for the same name (e.g. the reserved error token
    // at ID 0 may share a name with a real token).
    for id in 0..language.node_kind_count() as u16 {
        if let Some(name) = language.node_kind_for_id(id) {
            if name.is_empty() {
                continue;
            }
            let is_named = language.node_kind_is_named(id);
            if is_named {
                let canonical_id = language.id_for_node_kind(name, true);
                if canonical_id != 0 && schema.id_for_node_kind(name).is_none() {
                    schema.register_kind_with_id(name, canonical_id);
                }
            } else {
                let canonical_id = language.id_for_node_kind(name, false);
                if canonical_id != 0 && schema.id_for_unnamed_node_kind(name).is_none() {
                    schema.register_unnamed_kind_with_id(name, canonical_id);
                }
            }
            // Always track the name for any ID we encounter (so
            // `node_kind_for_id` works for the literal `id` we saw, even
            // when it isn't the canonical one).
            schema.record_kind_name(id, name);
        }
    }

    schema
}

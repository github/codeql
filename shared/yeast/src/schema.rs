use std::collections::BTreeMap;

use crate::{FieldId, KindId, CHILD_FIELD};

/// A schema defining node kinds and field names for the output AST.
/// Built from a node-types.yml file, independent of any tree-sitter grammar.
///
/// # Memory management
///
/// `register_field`/`register_kind`/`register_unnamed_kind` use `Box::leak`
/// to obtain `&'static str` names. This is intentional: the `&'static str`
/// names appear pervasively in `Node`, `AstCursor`, query patterns, and the
/// extractor's TRAP output, where adding a lifetime would propagate widely.
///
/// The leak is bounded by the number of distinct kind/field names registered.
/// Schemas are expected to be constructed once per process (e.g. at extractor
/// startup) and reused. Repeated construction in long-running processes will
/// leak memory unboundedly and should be avoided.
#[derive(Clone)]
pub struct Schema {
    field_ids: BTreeMap<String, FieldId>,
    field_names: BTreeMap<FieldId, &'static str>,
    next_field_id: FieldId,
    kind_ids: BTreeMap<String, KindId>,
    unnamed_kind_ids: BTreeMap<String, KindId>,
    kind_names: BTreeMap<KindId, &'static str>,
    next_kind_id: KindId,
}

impl Default for Schema {
    fn default() -> Self {
        Self::new()
    }
}

impl Schema {
    pub fn new() -> Self {
        Self {
            field_ids: BTreeMap::new(),
            field_names: BTreeMap::new(),
            next_field_id: 1, // 0 is reserved
            kind_ids: BTreeMap::new(),
            unnamed_kind_ids: BTreeMap::new(),
            kind_names: BTreeMap::new(),
            next_kind_id: 1, // 0 is reserved
        }
    }

    /// Create a schema from a tree-sitter language, importing all its
    /// known field and kind names.
    pub fn from_language(language: &tree_sitter::Language) -> Self {
        let mut schema = Self::new();
        // Import all field names, preserving tree-sitter's IDs
        for id in 1..=language.field_count() as u16 {
            if let Some(name) = language.field_name_for_id(id) {
                schema.field_ids.insert(name.to_string(), id);
                schema.field_names.insert(id, name);
                if id >= schema.next_field_id {
                    schema.next_field_id = id + 1;
                }
            }
        }
        // Import all node kind names, preserving tree-sitter's IDs.
        // Track named and unnamed variants separately.
        // For named kinds, use the canonical ID from id_for_node_kind(name, true)
        // since some languages have multiple IDs for the same named kind.
        for id in 0..language.node_kind_count() as u16 {
            if let Some(name) = language.node_kind_for_id(id) {
                if !name.is_empty() {
                    let is_named = language.node_kind_is_named(id);
                    if is_named {
                        let canonical_id = language.id_for_node_kind(name, true);
                        if canonical_id != 0 && !schema.kind_ids.contains_key(name) {
                            schema.kind_ids.insert(name.to_string(), canonical_id);
                            schema.kind_names.insert(canonical_id, name);
                        }
                    } else {
                        // For unnamed kinds, only insert if we don't already have one
                        // (some languages have multiple unnamed IDs for the same text)
                        schema
                            .unnamed_kind_ids
                            .entry(name.to_string())
                            .or_insert(id);
                    }
                    // Always track the name for any ID we encounter
                    schema.kind_names.entry(id).or_insert(name);
                    if id >= schema.next_kind_id {
                        schema.next_kind_id = id + 1;
                    }
                }
            }
        }
        schema
    }

    /// Register a field name, returning its ID.
    /// If already registered, returns the existing ID.
    pub fn register_field(&mut self, name: &str) -> FieldId {
        if name == "child" {
            return CHILD_FIELD;
        }
        if let Some(&id) = self.field_ids.get(name) {
            return id;
        }
        let id = self.next_field_id;
        assert!(id < CHILD_FIELD, "too many fields");
        self.next_field_id += 1;
        let leaked: &'static str = Box::leak(name.to_string().into_boxed_str());
        self.field_ids.insert(name.to_string(), id);
        self.field_names.insert(id, leaked);
        id
    }

    /// Register a named node kind name, returning its ID.
    /// If already registered, returns the existing ID.
    pub fn register_kind(&mut self, name: &str) -> KindId {
        if let Some(&id) = self.kind_ids.get(name) {
            return id;
        }
        let id = self.next_kind_id;
        self.next_kind_id += 1;
        let leaked: &'static str = Box::leak(name.to_string().into_boxed_str());
        self.kind_ids.insert(name.to_string(), id);
        self.kind_names.insert(id, leaked);
        id
    }

    /// Register an unnamed token kind (e.g. `"="`, `"end"`), returning its ID.
    /// If already registered, returns the existing ID.
    pub fn register_unnamed_kind(&mut self, name: &str) -> KindId {
        if let Some(&id) = self.unnamed_kind_ids.get(name) {
            return id;
        }
        let id = self.next_kind_id;
        self.next_kind_id += 1;
        let leaked: &'static str = Box::leak(name.to_string().into_boxed_str());
        self.unnamed_kind_ids.insert(name.to_string(), id);
        self.kind_names.insert(id, leaked);
        id
    }

    pub fn field_id_for_name(&self, name: &str) -> Option<FieldId> {
        if name == "child" {
            return Some(CHILD_FIELD);
        }
        self.field_ids.get(name).copied()
    }

    pub fn field_name_for_id(&self, id: FieldId) -> Option<&'static str> {
        if id == CHILD_FIELD {
            return Some("child");
        }
        self.field_names.get(&id).copied()
    }

    pub fn id_for_node_kind(&self, kind: &str) -> Option<KindId> {
        self.kind_ids.get(kind).copied()
    }

    pub fn id_for_unnamed_node_kind(&self, kind: &str) -> Option<KindId> {
        self.unnamed_kind_ids.get(kind).copied()
    }

    pub fn node_kind_for_id(&self, id: KindId) -> Option<&'static str> {
        self.kind_names.get(&id).copied()
    }
}

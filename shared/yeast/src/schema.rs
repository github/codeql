use std::collections::{BTreeMap, BTreeSet};

use crate::{FieldId, KindId, CHILD_FIELD};

#[derive(Clone, Debug)]
pub struct NodeType {
    pub kind: String,
    pub named: bool,
}

/// Multiplicity/optionality of a field declaration.
#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub struct FieldCardinality {
    /// Whether the field may hold more than one child.
    pub multiple: bool,
    /// Whether at least one child must be present.
    pub required: bool,
}

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
    field_types: BTreeMap<(String, FieldId), Vec<NodeType>>,
    field_cardinalities: BTreeMap<(String, FieldId), FieldCardinality>,
    supertypes: BTreeMap<String, Vec<NodeType>>,
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
            field_types: BTreeMap::new(),
            field_cardinalities: BTreeMap::new(),
            supertypes: BTreeMap::new(),
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
        // Track named and unnamed variants separately. For both named and
        // unnamed kinds, use the canonical ID from id_for_node_kind, since
        // some languages have multiple IDs for the same name (e.g., the
        // reserved error token at ID 0 may share a name with a real token).
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
                        let canonical_id = language.id_for_node_kind(name, false);
                        if canonical_id != 0 && !schema.unnamed_kind_ids.contains_key(name) {
                            schema
                                .unnamed_kind_ids
                                .insert(name.to_string(), canonical_id);
                            schema.kind_names.insert(canonical_id, name);
                        }
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

    pub fn set_field_types(
        &mut self,
        parent_kind: &str,
        field_id: FieldId,
        node_types: Vec<NodeType>,
    ) {
        self.field_types
            .insert((parent_kind.to_string(), field_id), node_types);
    }

    pub fn field_types(
        &self,
        parent_kind: &str,
        field_id: FieldId,
    ) -> Option<&Vec<NodeType>> {
        self.field_types
            .get(&(parent_kind.to_string(), field_id))
    }

    pub fn set_field_cardinality(
        &mut self,
        parent_kind: &str,
        field_id: FieldId,
        cardinality: FieldCardinality,
    ) {
        self.field_cardinalities
            .insert((parent_kind.to_string(), field_id), cardinality);
    }

    /// Returns the declared cardinality for a field, if known.
    pub fn field_cardinality(
        &self,
        parent_kind: &str,
        field_id: FieldId,
    ) -> Option<FieldCardinality> {
        self.field_cardinalities
            .get(&(parent_kind.to_string(), field_id))
            .copied()
    }

    /// Returns an iterator over all `(field_id, field_name)` pairs that are
    /// declared as required (`required: true`) for the given `parent_kind`.
    pub fn required_fields_for_kind<'a>(
        &'a self,
        parent_kind: &'a str,
    ) -> impl Iterator<Item = (FieldId, Option<&'static str>)> + 'a {
        self.field_cardinalities
            .iter()
            .filter(move |((kind, _), card)| kind == parent_kind && card.required)
            .map(move |((_, field_id), _)| {
                let name = self.field_name_for_id(*field_id);
                (*field_id, name)
            })
    }

    pub fn set_supertype_members(&mut self, supertype: &str, node_types: Vec<NodeType>) {
        self.supertypes.insert(supertype.to_string(), node_types);
    }

    fn allows_node(
        &self,
        node_type: &NodeType,
        node_kind: &str,
        node_named: bool,
        active: &mut BTreeSet<String>,
    ) -> bool {
        if node_type.kind == node_kind && node_type.named == node_named {
            return true;
        }

        if !node_type.named {
            return false;
        }

        let Some(members) = self.supertypes.get(&node_type.kind) else {
            return false;
        };

        if !active.insert(node_type.kind.clone()) {
            return false;
        }

        let matched = members
            .iter()
            .any(|member| self.allows_node(member, node_kind, node_named, active));
        active.remove(&node_type.kind);
        matched
    }

    pub fn node_matches_types(
        &self,
        node_kind: &str,
        node_named: bool,
        node_types: &[NodeType],
    ) -> bool {
        node_types.iter().any(|node_type| {
            self.allows_node(node_type, node_kind, node_named, &mut BTreeSet::new())
        })
    }
}

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
/// `register_field`/`register_kind`/`register_unnamed_kind` (and their
/// `_with_id` siblings) use `Box::leak` to obtain `&'static str` names. This
/// is intentional: the `&'static str` names appear pervasively in `Node`,
/// `AstCursor`, query patterns, and the extractor's TRAP output, where
/// adding a lifetime would propagate widely.
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

    /// Register a field name with a specific ID, e.g. when importing IDs
    /// from an external source like a tree-sitter language. If the name is
    /// already registered (with any ID), nothing is changed and the
    /// existing ID is returned.
    pub fn register_field_with_id(&mut self, name: &str, id: FieldId) -> FieldId {
        if name == "child" {
            return CHILD_FIELD;
        }
        if let Some(&existing) = self.field_ids.get(name) {
            return existing;
        }
        assert!(id < CHILD_FIELD, "too many fields");
        let leaked: &'static str = Box::leak(name.to_string().into_boxed_str());
        self.field_ids.insert(name.to_string(), id);
        self.field_names.insert(id, leaked);
        if id >= self.next_field_id {
            self.next_field_id = id + 1;
        }
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

    /// Register a named node kind with a specific ID, e.g. when importing
    /// IDs from a tree-sitter language. If the name is already registered,
    /// nothing is changed and the existing ID is returned.
    pub fn register_kind_with_id(&mut self, name: &str, id: KindId) -> KindId {
        if let Some(&existing) = self.kind_ids.get(name) {
            return existing;
        }
        let leaked: &'static str = Box::leak(name.to_string().into_boxed_str());
        self.kind_ids.insert(name.to_string(), id);
        self.kind_names.insert(id, leaked);
        if id >= self.next_kind_id {
            self.next_kind_id = id + 1;
        }
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

    /// Register an unnamed token kind with a specific ID. If the name is
    /// already registered as unnamed, nothing is changed and the existing
    /// ID is returned.
    pub fn register_unnamed_kind_with_id(&mut self, name: &str, id: KindId) -> KindId {
        if let Some(&existing) = self.unnamed_kind_ids.get(name) {
            return existing;
        }
        let leaked: &'static str = Box::leak(name.to_string().into_boxed_str());
        self.unnamed_kind_ids.insert(name.to_string(), id);
        self.kind_names.insert(id, leaked);
        if id >= self.next_kind_id {
            self.next_kind_id = id + 1;
        }
        id
    }

    /// Register every kind (named and unnamed) and field *name* from `other`
    /// into this schema (idempotent). Ids are assigned in this schema's own id
    /// space; existing ids are unchanged.
    ///
    /// This is used when running desugaring rules over an AST that was built
    /// against a different schema (e.g. from an external parser): the rules
    /// build output nodes whose kind/field names come from `other`, and those
    /// names must resolve in the AST's own schema. Only names are needed — the
    /// rule engine resolves kinds/fields by name and does not consult
    /// `other`'s field-type or supertype information.
    pub fn register_names_from(&mut self, other: &Schema) {
        for name in other.kind_ids.keys() {
            self.register_kind(name);
        }
        for name in other.unnamed_kind_ids.keys() {
            self.register_unnamed_kind(name);
        }
        for name in other.field_ids.keys() {
            self.register_field(name);
        }
    }

    /// Track a name for a kind ID without registering it as named or
    /// unnamed. Useful when importing tree-sitter ID tables that may
    /// contain duplicate IDs across the named/unnamed split.
    pub fn record_kind_name(&mut self, id: KindId, name: &'static str) {
        self.kind_names.entry(id).or_insert(name);
        if id >= self.next_kind_id {
            self.next_kind_id = id + 1;
        }
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

    /// Has `kind` been registered as a named kind (concrete node or
    /// supertype)?
    pub fn has_named_kind(&self, kind: &str) -> bool {
        self.id_for_node_kind(kind).is_some()
    }

    /// Has `kind` been registered as an unnamed token kind?
    pub fn has_unnamed_kind(&self, kind: &str) -> bool {
        self.id_for_unnamed_node_kind(kind).is_some()
    }

    /// Is `field_name` declared as a field on `parent_kind`?
    /// `field_name == None` checks for the implicit unfielded slot
    /// (`$children`/`CHILD_FIELD`).
    pub fn has_field(&self, parent_kind: &str, field_name: Option<&str>) -> bool {
        let field_id = match field_name {
            Some(name) => match self.field_id_for_name(name) {
                Some(id) => id,
                None => return false,
            },
            None => CHILD_FIELD,
        };
        self.field_types(parent_kind, field_id).is_some()
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

    /// Returns the declared members of a supertype, if known.
    pub fn supertype_members(&self, supertype: &str) -> Option<&Vec<NodeType>> {
        self.supertypes.get(supertype)
    }

    /// Is `kind` a known supertype (an abstract grouping)?
    pub fn is_supertype(&self, kind: &str) -> bool {
        self.supertypes.contains_key(kind)
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

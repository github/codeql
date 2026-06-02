use std::collections::BTreeMap;

use crate::captures::Captures;
use crate::tree_builder::FreshScope;
use crate::{Ast, FieldId, Id, NodeContent};

/// Context for building new AST nodes during a transformation.
///
/// Used by the `tree!` and `trees!` macros. Holds a mutable reference to the
/// AST, a reference to the captures from a query match, and a `FreshScope` for
/// generating unique identifiers.
pub struct BuildCtx<'a> {
    pub ast: &'a mut Ast,
    pub captures: &'a Captures,
    pub fresh: &'a FreshScope,
    /// Source range of the matched node, inherited by synthetic nodes.
    pub source_range: Option<tree_sitter::Range>,
}

impl<'a> BuildCtx<'a> {
    pub fn new(ast: &'a mut Ast, captures: &'a Captures, fresh: &'a FreshScope) -> Self {
        Self {
            ast,
            captures,
            fresh,
            source_range: None,
        }
    }

    pub fn with_source_range(
        ast: &'a mut Ast,
        captures: &'a Captures,
        fresh: &'a FreshScope,
        source_range: Option<tree_sitter::Range>,
    ) -> Self {
        Self {
            ast,
            captures,
            fresh,
            source_range,
        }
    }

    /// Look up a capture variable, returning its node Id.
    pub fn capture(&self, name: &str) -> Id {
        self.captures
            .get_var(name)
            .unwrap_or_else(|e| panic!("build: {e}"))
    }

    /// Get all values of a repeated capture variable.
    pub fn capture_all(&self, name: &str) -> Vec<Id> {
        self.captures.get_all(name)
    }

    /// Create a named AST node with the given kind and fields.
    pub fn node(&mut self, kind: &str, fields: Vec<(&str, Vec<Id>)>) -> Id {
        let kind_id = self
            .ast
            .id_for_node_kind(kind)
            .unwrap_or_else(|| panic!("build: node kind '{kind}' not found"));
        let mut field_map: BTreeMap<FieldId, Vec<Id>> = BTreeMap::new();
        for (name, ids) in fields {
            let field_id = self
                .ast
                .field_id_for_name(name)
                .unwrap_or_else(|| panic!("build: field '{name}' not found"));
            field_map.entry(field_id).or_default().extend(ids);
        }
        self.ast.create_node_with_range(
            kind_id,
            NodeContent::DynamicString(String::new()),
            field_map,
            true,
            self.source_range,
        )
    }

    /// Create a leaf node with a fixed string content.
    pub fn literal(&mut self, kind: &'static str, value: &str) -> Id {
        self.ast
            .create_named_token_with_range(kind, value.to_string(), self.source_range)
    }

    /// Create a leaf node with an auto-generated unique name.
    pub fn fresh(&mut self, kind: &'static str, name: &str) -> Id {
        let generated = self.fresh.resolve(name);
        self.ast
            .create_named_token_with_range(kind, generated, self.source_range)
    }

    /// Prepend a value to a field of an existing node.
    pub fn prepend_field(&mut self, node_id: Id, field_name: &str, value_id: Id) {
        let field_id = self
            .ast
            .field_id_for_name(field_name)
            .unwrap_or_else(|| panic!("build: field '{field_name}' not found"));
        self.ast.prepend_field_child(node_id, field_id, value_id);
    }
}

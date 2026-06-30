use std::collections::BTreeMap;

use crate::captures::Captures;
use crate::tree_builder::FreshScope;
use crate::{Ast, FieldId, Id, NodeContent, TranslatorHandle};

/// Context for building new AST nodes during a transformation.
///
/// Used by the `tree!` and `trees!` macros. Holds a mutable reference to the
/// AST, a reference to the captures from a query match, a `FreshScope` for
/// generating unique identifiers, and a mutable reference to a user-defined
/// context of type `C`.
///
/// The user context `C` is shared across rules via the framework's driver:
/// outer rules can write to it before recursive translation, and inner rules
/// can read (or further mutate) it during their transforms. The framework
/// snapshots and restores the user context around each rule application, so
/// mutations made by a rule are visible to its descendants (via recursive
/// translation) but not to its parent's siblings.
///
/// `BuildCtx` implements [`Deref`] and [`DerefMut`] targeting `C`, so user
/// context fields are accessible as `ctx.my_field` directly (provided they
/// don't collide with `BuildCtx`'s own fields like `ast`, `captures`, etc.).
///
/// The default `C = ()` means rules that don't need any user context don't
/// pay any cost.
///
/// When constructed by the framework (via the rule! macro), `BuildCtx` also
/// carries a [`TranslatorHandle`] that the [`translate`] method delegates
/// to. When constructed by hand (e.g. in tests), the translator is `None`
/// and [`translate`] returns an error.
pub struct BuildCtx<'a, C: 'a = ()> {
    pub ast: &'a mut Ast,
    pub captures: &'a Captures,
    pub fresh: &'a FreshScope,
    /// Source range of the matched node, inherited by synthetic nodes.
    pub source_range: Option<tree_sitter::Range>,
    /// User-supplied context, accessible directly via `ctx.field` (via Deref).
    pub user_ctx: &'a mut C,
    /// Optional translator handle, populated when the context is built by
    /// the framework's rule driver. None when the context is built by hand.
    pub(crate) translator: Option<TranslatorHandle<'a, C>>,
}

impl<'a, C> BuildCtx<'a, C> {
    pub fn new(
        ast: &'a mut Ast,
        captures: &'a Captures,
        fresh: &'a FreshScope,
        user_ctx: &'a mut C,
    ) -> Self {
        Self {
            ast,
            captures,
            fresh,
            source_range: None,
            user_ctx,
            translator: None,
        }
    }

    pub fn with_source_range(
        ast: &'a mut Ast,
        captures: &'a Captures,
        fresh: &'a FreshScope,
        source_range: Option<tree_sitter::Range>,
        user_ctx: &'a mut C,
    ) -> Self {
        Self {
            ast,
            captures,
            fresh,
            source_range,
            user_ctx,
            translator: None,
        }
    }

    /// Construct a `BuildCtx` carrying a translator handle. Used by the
    /// `rule!` macro to enable [`translate`] inside rule transforms.
    pub fn with_translator(
        ast: &'a mut Ast,
        captures: &'a Captures,
        fresh: &'a FreshScope,
        source_range: Option<tree_sitter::Range>,
        user_ctx: &'a mut C,
        translator: TranslatorHandle<'a, C>,
    ) -> Self {
        Self {
            ast,
            captures,
            fresh,
            source_range,
            user_ctx,
            translator: Some(translator),
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

    /// Create a leaf node with fixed content and an optional preferred source range.
    /// If `source_range` is `None`, falls back to this context's inherited range.
    pub fn literal_with_source_range(
        &mut self,
        kind: &'static str,
        value: &str,
        source_range: Option<tree_sitter::Range>,
    ) -> Id {
        self.ast.create_named_token_with_range(
            kind,
            value.to_string(),
            source_range.or(self.source_range),
        )
    }

    /// Create a leaf node with an auto-generated unique name.
    pub fn fresh(&mut self, kind: &'static str, name: &str) -> Id {
        let generated = self.fresh.resolve(name);
        self.ast
            .create_named_token_with_range(kind, generated, self.source_range)
    }
}

impl<C: Clone> BuildCtx<'_, C> {
    /// Recursively translate a node via the framework's rule machinery.
    /// In a OneShot phase, applies OneShot rules to the given node and
    /// returns the resulting node ids. In a Repeating phase, errors
    /// (translation is not meaningful when input and output share a
    /// schema).
    ///
    /// Errors if this `BuildCtx` was constructed by hand (without a
    /// translator handle) — for example, in unit tests that don't go
    /// through the rule driver.
    pub fn translate<I: Into<Id>>(&mut self, id: I) -> Result<Vec<Id>, String> {
        let id = id.into();
        match &self.translator {
            Some(t) => t.translate(self.ast, self.user_ctx, id),
            None => Err("translate() called on a BuildCtx without a translator handle".into()),
        }
    }
}

impl<C> std::ops::Deref for BuildCtx<'_, C> {
    type Target = C;
    fn deref(&self) -> &C {
        &*self.user_ctx
    }
}

impl<C> std::ops::DerefMut for BuildCtx<'_, C> {
    fn deref_mut(&mut self) -> &mut C {
        &mut *self.user_ctx
    }
}

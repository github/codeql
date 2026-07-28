use std::collections::BTreeMap;

use crate::captures::Captures;
use crate::tree_builder::FreshScope;
use crate::{Ast, FieldId, Id, NodeContent, Range, TranslatorHandle};

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
    pub source_range: Option<Range>,
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
        source_range: Option<Range>,
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
        source_range: Option<Range>,
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
        source_range: Option<Range>,
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
    /// Recursively translate every id in the given iterable via the
    /// framework's rule machinery. In a OneShot phase, applies OneShot
    /// rules to each id and returns the accumulated resulting node ids
    /// in order. In a Repeating phase, errors (translation is not
    /// meaningful when input and output share a schema).
    ///
    /// The single-`Id` case works too, because `Id: IntoIterator<Item
    /// = Id>` is a singleton iterator — so `ctx.translate(some_id)?`
    /// returns a `Vec<Id>` containing whatever `some_id` translated to.
    ///
    /// Errors if this `BuildCtx` was constructed by hand (without a
    /// translator handle) — for example, in unit tests that don't go
    /// through the rule driver.
    pub fn translate<I: Into<Id>>(
        &mut self,
        ids: impl IntoIterator<Item = I>,
    ) -> Result<Vec<Id>, String> {
        let translator = self
            .translator
            .as_ref()
            .ok_or("translate() called on a BuildCtx without a translator handle")?;
        let mut out = Vec::new();
        for id in ids {
            let translated = translator.translate(self.ast, self.user_ctx, id.into())?;
            out.extend(translated);
        }
        Ok(out)
    }

    /// Run `f` with a temporary child [`BuildCtx`] whose `user_ctx` is
    /// a fresh clone of the current one, sharing everything else
    /// (`ast`, `captures`, `fresh`, `source_range`, `translator`) by
    /// re-borrow. Any mutations `f` makes to the child's `user_ctx`
    /// are discarded when it returns — no restore needed, because the
    /// mutations only ever happened on a local clone.
    ///
    /// Use for the rare rule that needs to translate a subtree under a
    /// modified context *and then continue using its own (unmodified)
    /// context afterwards*. For rules where the modified translation
    /// is the last use of `ctx`, mutate `ctx` in place — the framework
    /// invokes each rule with a private clone of the user context, so
    /// mutations are discarded on rule exit anyway.
    ///
    /// Example: an outer rule that translates one child subtree with a
    /// reset context, then continues with the outer context intact:
    ///
    /// ```ignore
    /// let val = ctx.scoped(|ctx| {
    ///     ctx.reset();
    ///     ctx.translate(val)
    /// })?;
    /// // `ctx` here is untouched by the reset inside the closure.
    /// let other = ctx.translate(other_id)?;
    /// ```
    pub fn scoped<F, R>(&mut self, f: F) -> R
    where
        F: for<'b> FnOnce(&mut BuildCtx<'b, C>) -> R,
    {
        let mut child_user_ctx = self.user_ctx.clone();
        let mut child = BuildCtx {
            ast: &mut *self.ast,
            captures: self.captures,
            fresh: self.fresh,
            source_range: self.source_range,
            user_ctx: &mut child_user_ctx,
            translator: self.translator,
        };
        f(&mut child)
        // child_user_ctx dropped; the outer `self` is unaffected.
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

use std::collections::{BTreeMap, BTreeSet};

use crate::{
    Ast, ContextNodeId, FieldId, Id, IntoFieldIds, IntoLocationRanges, KindId, NodeContent,
    OutputAst, OutputId, Range, TranslatorHandle,
};

/// Context for building new AST nodes during a transformation.
///
/// Used by the `tree!` and `trees!` macros. Holds a mutable reference to the
/// output AST, translated captures, and a mutable user-defined context. Rule
/// transforms additionally carry a shared immutable input AST.
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
/// don't collide with `BuildCtx`'s own fields like `output`, `captures`, etc.).
///
/// The default `C = ()` means rules that don't need any user context don't
/// pay any cost.
///
/// When constructed by the framework (via the rule! macro), `BuildCtx` also
/// carries a [`TranslatorHandle`] that the [`translate`] method delegates
/// to. When constructed by hand (e.g. in tests), the translator is `None`
/// and [`translate`] returns an error.
pub struct BuildCtx<'a, C: 'a = ()> {
    ast: &'a Ast,
    pub output: &'a mut OutputAst,
    /// Source range of the node matched by the current rule.
    ///
    /// The `rule!` macro applies this range to locally-created result roots
    /// after the transform completes. Nested synthetic nodes derive their
    /// ranges from their children, falling back to an empty range at this
    /// range's start.
    pub source_range: Option<Range>,
    /// User-supplied context, accessible directly via `ctx.field` (via Deref).
    pub user_ctx: &'a mut C,
    /// Optional translator handle, populated when the context is built by
    /// the framework's rule driver. None when the context is built by hand.
    pub(crate) translator: Option<TranslatorHandle<'a, C>>,
    /// First failure encountered while auto-translating an input `Id` during
    /// template construction. Templates remain infallible expressions, so
    /// [`finish_rule`](Self::finish_rule) returns this error at the rule boundary.
    deferred_translation_error: Option<String>,
    /// Nodes built directly through this context without an explicit source
    /// range in either their content or constructor argument. Recursive
    /// translations use their own context and therefore do not contribute to
    /// this set. Membership checks identify result roots to widen, while
    /// removals exclude nodes that are later assigned an explicit range.
    created_nodes_without_source_range: BTreeSet<OutputId>,
}

#[doc(hidden)]
/// RAII guard that gives an output-template interpolation its own user context
/// while preserving the surrounding lexical scope for control flow.
///
/// It temporarily swaps a clone into the existing [`BuildCtx`] and restores
/// the original context on drop.
pub struct ClonedUserCtx<'ctx, 'a, C: 'a> {
    ctx: &'ctx mut BuildCtx<'a, C>,
    original_user_ctx: Option<C>,
}

impl<'a, C> std::ops::Deref for ClonedUserCtx<'_, 'a, C> {
    type Target = BuildCtx<'a, C>;

    fn deref(&self) -> &Self::Target {
        self.ctx
    }
}

impl<C> std::ops::DerefMut for ClonedUserCtx<'_, '_, C> {
    fn deref_mut(&mut self) -> &mut Self::Target {
        self.ctx
    }
}

impl<C> Drop for ClonedUserCtx<'_, '_, C> {
    fn drop(&mut self) {
        if let Some(original_user_ctx) = self.original_user_ctx.take() {
            *self.ctx.user_ctx = original_user_ctx;
        }
    }
}

impl<'a, C> BuildCtx<'a, C> {
    pub fn new(ast: &'a Ast, output: &'a mut OutputAst, user_ctx: &'a mut C) -> Self {
        Self {
            ast,
            output,
            source_range: None,
            user_ctx,
            translator: None,
            deferred_translation_error: None,
            created_nodes_without_source_range: BTreeSet::new(),
        }
    }

    /// Construct a context carrying a matched input source range.
    pub fn with_source_range(
        ast: &'a Ast,
        output: &'a mut OutputAst,
        source_range: Option<Range>,
        user_ctx: &'a mut C,
    ) -> Self {
        Self {
            ast,
            output,
            source_range,
            user_ctx,
            translator: None,
            deferred_translation_error: None,
            created_nodes_without_source_range: BTreeSet::new(),
        }
    }

    /// Construct a `BuildCtx` carrying a translator handle. Used by the
    /// `rule!` macro to enable [`translate`] inside rule transforms.
    pub fn with_translator(
        ast: &'a Ast,
        output: &'a mut OutputAst,
        source_range: Option<Range>,
        user_ctx: &'a mut C,
        translator: TranslatorHandle<'a, C>,
    ) -> Self {
        Self {
            ast,
            output,
            source_range,
            user_ctx,
            translator: Some(translator),
            deferred_translation_error: None,
            created_nodes_without_source_range: BTreeSet::new(),
        }
    }

    /// Create a node and record it as constructed by this rule invocation.
    pub fn create_node_with_range(
        &mut self,
        kind: KindId,
        content: NodeContent,
        fields: BTreeMap<FieldId, Vec<OutputId>>,
        is_named: bool,
        source_range: Option<Range>,
    ) -> OutputId {
        let has_explicit_source_range =
            source_range.is_some() || matches!(&content, NodeContent::Range(_));
        let id = self
            .output
            .create_node_with_range(kind, content, fields, is_named, source_range);
        if self
            .output
            .get_node(id)
            .is_some_and(|node| node.source_range().is_none())
        {
            if let Some(source_range) = self.source_range {
                self.output
                    .extend_source_range(id, source_range.empty_at_start());
            }
        }
        if !has_explicit_source_range {
            self.created_nodes_without_source_range.insert(id);
        }
        id
    }

    /// Create a named token and record it as constructed by this rule invocation.
    pub fn create_named_token_with_range(
        &mut self,
        kind: &'static str,
        content: String,
        source_range: Option<Range>,
    ) -> OutputId {
        let has_explicit_source_range = source_range.is_some();
        let source_range =
            source_range.or_else(|| self.source_range.map(|range| range.empty_at_start()));
        let id = self
            .output
            .create_named_token_with_range(kind, content, source_range);
        if !has_explicit_source_range {
            self.created_nodes_without_source_range.insert(id);
        }
        id
    }

    /// Finish the current rule invocation by applying the matched source range
    /// to locally-created result roots.
    #[doc(hidden)]
    pub fn finish_rule(self, results: Vec<OutputId>) -> Result<Vec<OutputId>, String> {
        if let Some(error) = self.deferred_translation_error {
            return Err(error);
        }
        if let Some(source_range) = self.source_range {
            for &id in &results {
                if self.created_nodes_without_source_range.contains(&id) {
                    self.output.extend_source_range(id, source_range);
                }
            }
        }
        Ok(results)
    }

    /// Assign an explicit source range to a newly-built result root.
    #[doc(hidden)]
    pub fn set_node_source_range(
        &mut self,
        node: OutputId,
        source_range: Option<Range>,
    ) -> OutputId {
        if let Some(source_range) = source_range {
            self.output.set_source_range(node, source_range);
            self.created_nodes_without_source_range.remove(&node);
        }
        node
    }

    /// Return the immutable input AST. Available inside rule transforms.
    pub fn ast(&self) -> &Ast {
        self.ast
    }

    pub fn source_text<I: ContextNodeId>(&self, id: I) -> String {
        id.source_text(self)
    }

    /// Return the source range of a parsed or synthetic node.
    pub fn source_range<I: ContextNodeId>(&self, id: I) -> Option<Range> {
        id.source_range(self)
    }

    #[doc(hidden)]
    pub fn extend_location_ranges<V: IntoLocationRanges<C>>(&self, value: V, out: &mut Vec<Range>) {
        value.extend_ranges(self, out);
    }

    /// Return an empty range between two non-overlapping nodes.
    pub fn empty_source_range_between(&self, left: OutputId, right: OutputId) -> Option<Range> {
        let left = self.source_range(left)?;
        let right = self.source_range(right)?;
        (left.end_byte <= right.start_byte).then(|| left.empty_at_end())
    }

    /// Create a named AST node with the given kind and fields.
    pub fn node(&mut self, kind: &str, fields: Vec<(&str, Vec<OutputId>)>) -> OutputId {
        let kind_id = self
            .output
            .id_for_node_kind(kind)
            .unwrap_or_else(|| panic!("build: node kind '{kind}' not found"));
        let mut field_map: BTreeMap<FieldId, Vec<OutputId>> = BTreeMap::new();
        for (name, ids) in fields {
            let field_id = self
                .output
                .field_id_for_name(name)
                .unwrap_or_else(|| panic!("build: field '{name}' not found"));
            field_map.entry(field_id).or_default().extend(ids);
        }
        self.create_node_with_range(
            kind_id,
            NodeContent::DynamicString(String::new()),
            field_map,
            true,
            None,
        )
    }

    /// Create a leaf node with a fixed string content.
    pub fn literal(&mut self, kind: &'static str, value: &str) -> OutputId {
        self.create_named_token_with_range(kind, value.to_string(), None)
    }

    /// Create a leaf node with fixed content and an optional source range.
    pub fn literal_with_source_range(
        &mut self,
        kind: &'static str,
        value: &str,
        source_range: Option<Range>,
    ) -> OutputId {
        self.create_named_token_with_range(kind, value.to_string(), source_range)
    }

    /// Create a literal with an empty range at another node's start.
    pub fn literal_at_start_of<I: ContextNodeId>(
        &mut self,
        kind: &'static str,
        value: &str,
        source: I,
    ) -> OutputId {
        let source_range = self.source_range(source).map(Range::empty_at_start);
        self.literal_with_source_range(kind, value, source_range)
    }
}

impl<'a, C: Clone> BuildCtx<'a, C> {
    #[doc(hidden)]
    pub fn cloned_user_ctx(&mut self) -> ClonedUserCtx<'_, 'a, C> {
        let cloned_user_ctx = (*self.user_ctx).clone();
        let original_user_ctx = std::mem::replace(self.user_ctx, cloned_user_ctx);
        ClonedUserCtx {
            ctx: self,
            original_user_ctx: Some(original_user_ctx),
        }
    }

    #[doc(hidden)]
    pub fn extend_field_ids<V: IntoFieldIds<C>>(&mut self, value: V, out: &mut Vec<OutputId>) {
        value.extend_into(self, out);
    }

    #[doc(hidden)]
    pub fn translate_into(&mut self, id: Id, out: &mut Vec<OutputId>) {
        if self.deferred_translation_error.is_some() {
            return;
        }
        match self.translate(id) {
            Ok(ids) => out.extend(ids),
            Err(error) => self.deferred_translation_error = Some(error),
        }
    }

    /// Recursively translate every id in the given iterable via the
    /// framework's rule machinery and return the accumulated resulting node
    /// ids in order.
    ///
    /// The single-`Id` case works too, because `Id: IntoIterator<Item
    /// = Id>` is a singleton iterator — so `ctx.translate(some_id)?`
    /// returns a `Vec<OutputId>` containing whatever `some_id` translated to.
    ///
    /// Errors if this `BuildCtx` was constructed by hand (without a
    /// translator handle) — for example, in unit tests that don't go
    /// through the rule driver.
    pub fn translate(
        &mut self,
        ids: impl IntoIterator<Item = Id>,
    ) -> Result<Vec<OutputId>, String> {
        let translator = self
            .translator
            .as_ref()
            .ok_or("translate() called on a BuildCtx without a translator handle")?;
        let mut out = Vec::new();
        for id in ids {
            let translated = translator.translate(self.ast, self.output, self.user_ctx, id)?;
            out.extend(translated);
        }
        Ok(out)
    }

    /// Run `f` with a temporary child [`BuildCtx`] whose `user_ctx` is
    /// a fresh clone of the current one, sharing everything else
    /// (`ast`, `captures`, source ranges, `translator`) by re-borrow.
    /// Nodes constructed through the child remain part of the current rule
    /// invocation. Any mutations `f` makes to the child's `user_ctx`
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
            ast: self.ast,
            output: &mut *self.output,
            source_range: self.source_range,
            user_ctx: &mut child_user_ctx,
            translator: self.translator,
            deferred_translation_error: None,
            created_nodes_without_source_range: BTreeSet::new(),
        };
        let result = f(&mut child);
        let created_nodes_without_source_range =
            std::mem::take(&mut child.created_nodes_without_source_range);
        if self.deferred_translation_error.is_none() {
            self.deferred_translation_error = child.deferred_translation_error.take();
        }
        drop(child);
        self.created_nodes_without_source_range
            .extend(created_nodes_without_source_range);
        result
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

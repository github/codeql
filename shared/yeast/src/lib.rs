use std::collections::BTreeMap;

extern crate self as yeast;

use serde::Serialize;
use serde_json::{json, Value};

pub mod build;
pub mod captures;
pub mod cursor;
pub mod dump;
pub mod node_types_yaml;
pub mod query;
mod range;
pub mod schema;
pub mod tree_builder;
mod visitor;

pub use yeast_macros::{query, rule, tree, trees};

use captures::Captures;
pub use cursor::Cursor;
use query::QueryNode;

/// Node ids are indexes into the arena
pub type Id = usize;

/// Field and Kind ids are provided by tree-sitter
type FieldId = u16;
type KindId = u16;

/// A typed reference to a node in an [`Ast`] arena. Wraps an [`Id`] but
/// deliberately does not implement [`std::fmt::Display`]: rendering a node
/// requires the [`Ast`] it lives in (to resolve [`NodeContent::Range`] back
/// to source text). Use [`YeastDisplay::yeast_to_string`] to format it.
#[derive(Copy, Clone, Eq, PartialEq, Debug, Hash)]
pub struct NodeRef(pub Id);

impl NodeRef {
    pub fn id(self) -> Id {
        self.0
    }
}

impl From<NodeRef> for Id {
    fn from(value: NodeRef) -> Self {
        value.0
    }
}

/// Like [`std::fmt::Display`], but the formatting routine is given access to
/// the [`Ast`] so that node references can resolve to their source text.
///
/// All standard primitive and string types implement [`YeastDisplay`] via
/// the [`impl_yeast_display_via_display`] macro below. Coherence prevents a
/// blanket `impl<T: Display>`, so additional types must be added explicitly.
pub trait YeastDisplay {
    fn yeast_to_string(&self, ast: &Ast) -> String;
}

/// Optional source range for values used in `#{expr}` interpolations.
///
/// By default this returns `None`, so synthesized leaves inherit the matched
/// rule's source range. `NodeRef` returns the referenced node's range, letting
/// `(kind #{capture})` carry the captured node's location.
pub trait YeastSourceRange {
    fn yeast_source_range(&self, ast: &Ast) -> Option<tree_sitter::Range>;
}

impl YeastDisplay for NodeRef {
    fn yeast_to_string(&self, ast: &Ast) -> String {
        ast.source_text(self.0)
    }
}

impl YeastSourceRange for NodeRef {
    fn yeast_source_range(&self, ast: &Ast) -> Option<tree_sitter::Range> {
        ast.get_node(self.0).and_then(|n| match &n.content {
            NodeContent::Range(r) => Some(r.clone()),
            _ => n.source_range,
        })
    }
}

macro_rules! impl_yeast_display_via_display {
    ($($t:ty),* $(,)?) => {
        $(
            impl YeastDisplay for $t {
                fn yeast_to_string(&self, _ast: &Ast) -> String {
                    ::std::string::ToString::to_string(self)
                }
            }

            impl YeastSourceRange for $t {
                fn yeast_source_range(&self, _ast: &Ast) -> Option<tree_sitter::Range> {
                    None
                }
            }
        )*
    };
}

impl_yeast_display_via_display! {
    i8, i16, i32, i64, i128, isize,
    u8, u16, u32, u64, u128, usize,
    f32, f64,
    bool, char,
    str, String,
}

impl<T: YeastDisplay + ?Sized> YeastDisplay for &T {
    fn yeast_to_string(&self, ast: &Ast) -> String {
        (**self).yeast_to_string(ast)
    }
}

impl<T: YeastSourceRange + ?Sized> YeastSourceRange for &T {
    fn yeast_source_range(&self, ast: &Ast) -> Option<tree_sitter::Range> {
        (**self).yeast_source_range(ast)
    }
}

pub const CHILD_FIELD: u16 = u16::MAX;

#[derive(Debug)]
pub struct AstCursor<'a> {
    ast: &'a Ast,
    /// A stack of parents, along with iterators for their children.
    parents: Vec<(Id, ChildrenIter<'a>)>,
    node_id: Id,
}

impl<'a> AstCursor<'a> {
    pub fn new(ast: &'a Ast) -> Self {
        Self {
            ast,
            parents: vec![],
            node_id: ast.root,
        }
    }

    /// The Id of the node currently under the cursor.
    pub fn node_id(&self) -> Id {
        self.node_id
    }

    fn goto_next_sibling_opt(&mut self) -> Option<()> {
        self.node_id = self.parents.last_mut()?.1.next()?;
        Some(())
    }

    fn goto_first_child_opt(&mut self) -> Option<()> {
        let parent_id = self.node_id;
        let parent = self.ast.get_node(parent_id)?;
        let mut children = ChildrenIter::new(parent);
        let first_child = children.next()?;
        self.node_id = first_child;
        self.parents.push((parent_id, children));
        Some(())
    }

    fn goto_parent_opt(&mut self) -> Option<()> {
        self.node_id = self.parents.pop()?.0;
        Some(())
    }
}
impl<'a> Cursor<'a, Ast, Node, FieldId> for AstCursor<'a> {
    fn node(&self) -> &'a Node {
        &self.ast.nodes[self.node_id]
    }

    fn field_id(&self) -> Option<FieldId> {
        let (_, children) = self.parents.last()?;
        children.current_field()
    }

    fn field_name(&self) -> Option<&'static str> {
        if self.field_id() == Some(CHILD_FIELD) {
            None
        } else {
            self.field_id()
                .and_then(|id| self.ast.field_name_for_id(id))
        }
    }

    fn goto_first_child(&mut self) -> bool {
        self.goto_first_child_opt().is_some()
    }

    fn goto_next_sibling(&mut self) -> bool {
        self.goto_next_sibling_opt().is_some()
    }

    fn goto_parent(&mut self) -> bool {
        self.goto_parent_opt().is_some()
    }
}

/// An iterator over the child Ids of a node.
#[derive(Debug)]
struct ChildrenIter<'a> {
    current_field: Option<FieldId>,
    fields: std::collections::btree_map::Iter<'a, FieldId, Vec<Id>>,
    field_children: Option<std::slice::Iter<'a, Id>>,
}

impl<'a> ChildrenIter<'a> {
    fn new(node: &'a Node) -> Self {
        Self {
            current_field: None,
            fields: node.fields.iter(),
            field_children: None,
        }
    }

    fn current_field(&self) -> Option<FieldId> {
        self.current_field
    }
}

impl Iterator for ChildrenIter<'_> {
    type Item = Id;

    fn next(&mut self) -> Option<Self::Item> {
        match self.field_children.as_mut() {
            None => match self.fields.next() {
                Some((field, children)) => {
                    self.current_field = Some(*field);
                    self.field_children = Some(children.iter());
                    self.next()
                }
                None => None,
            },
            Some(children) => match children.next() {
                None => match self.fields.next() {
                    None => None,
                    Some((field, children)) => {
                        self.current_field = Some(*field);
                        self.field_children = Some(children.iter());
                        self.next()
                    }
                },
                Some(child_id) => Some(*child_id),
            },
        }
    }
}

/// Our AST
pub struct Ast {
    root: Id,
    nodes: Vec<Node>,
    schema: schema::Schema,
    /// Original source bytes the tree was parsed from. Used to resolve
    /// `NodeContent::Range` to text for synthesized literal nodes.
    source: Vec<u8>,
}

impl std::fmt::Debug for Ast {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        f.debug_struct("Ast")
            .field("root", &self.root)
            .field("nodes", &self.nodes.len())
            .finish()
    }
}

impl Ast {
    /// Construct an AST from a TS tree
    pub fn from_tree(language: tree_sitter::Language, tree: &tree_sitter::Tree) -> Self {
        let schema = schema::Schema::from_language(&language);
        Self::from_tree_with_schema(schema, tree, &language)
    }

    pub fn from_tree_with_schema(
        schema: schema::Schema,
        tree: &tree_sitter::Tree,
        language: &tree_sitter::Language,
    ) -> Self {
        Self::from_tree_with_schema_and_source(schema, tree, language, Vec::new())
    }

    pub fn from_tree_with_schema_and_source(
        schema: schema::Schema,
        tree: &tree_sitter::Tree,
        language: &tree_sitter::Language,
        source: Vec<u8>,
    ) -> Self {
        let mut visitor = visitor::Visitor::new(language.clone());
        visitor.visit(tree);

        let mut ast = visitor.build_with_schema(schema);
        ast.source = source;
        ast
    }

    /// Returns the source text for `id`, resolving `NodeContent::Range`
    /// against the stored source bytes when available.
    pub fn source_text(&self, id: Id) -> String {
        let Some(node) = self.get_node(id) else { return String::new(); };
        let read_range = |range: &tree_sitter::Range| {
            let start = range.start_byte;
            let end = range.end_byte;
            if end <= self.source.len() && start <= end {
                String::from_utf8_lossy(&self.source[start..end]).into_owned()
            } else {
                String::new()
            }
        };
        match &node.content {
            NodeContent::Range(range) => read_range(range),
            NodeContent::String(s) => s.to_string(),
            NodeContent::DynamicString(s) if !s.is_empty() => s.clone(),
            // Synthesized nodes (from rule transforms) carry an empty
            // `DynamicString`; resolve them against the inherited source
            // range so `#{capture}` after a translation still yields the
            // original source text.
            NodeContent::DynamicString(_) => match node.source_range {
                Some(range) => read_range(&range),
                None => String::new(),
            },
        }
    }

    pub fn walk(&self) -> AstCursor {
        AstCursor::new(self)
    }

    /// Return all nodes currently allocated in the AST arena.
    ///
    /// This includes nodes that are no longer reachable from `get_root()`
    /// after desugaring rewrites. Use `reachable_node_ids()` for output-level
    /// validation/traversal semantics.
    pub fn nodes(&self) -> &[Node] {
        &self.nodes
    }

    /// Return node ids reachable from `get_root()` by following child edges.
    ///
    /// This reflects the effective AST after desugaring and excludes orphaned
    /// arena nodes left behind by rewrite operations.
    pub fn reachable_node_ids(&self) -> Vec<usize> {
        let mut reachable = Vec::new();
        let mut stack = vec![self.root];
        let mut seen = vec![false; self.nodes.len()];

        while let Some(id) = stack.pop() {
            if id >= self.nodes.len() || seen[id] {
                continue;
            }
            seen[id] = true;
            reachable.push(id);

            if let Some(node) = self.get_node(id) {
                for children in node.fields.values() {
                    for &child in children {
                        stack.push(child);
                    }
                }
            }
        }

        reachable
    }

    pub fn get_root(&self) -> Id {
        self.root
    }

    pub fn set_root(&mut self, root: Id) {
        self.root = root;
    }

    pub fn get_node(&self, id: Id) -> Option<&Node> {
        self.nodes.get(id)
    }

    pub fn print(&self, source: &str, root_id: Id) -> Value {
        let root = &self.nodes()[root_id];
        self.print_node(root, source)
    }

    pub fn create_node(
        &mut self,
        kind: KindId,
        content: NodeContent,
        fields: BTreeMap<FieldId, Vec<Id>>,
        is_named: bool,
    ) -> Id {
        self.create_node_with_range(kind, content, fields, is_named, None)
    }

    pub fn create_node_with_range(
        &mut self,
        kind: KindId,
        content: NodeContent,
        fields: BTreeMap<FieldId, Vec<Id>>,
        is_named: bool,
        source_range: Option<tree_sitter::Range>,
    ) -> Id {
        let source_range = match &content {
            // Parsed nodes already carry an exact source range in their content.
            NodeContent::Range(_) => source_range,
            // Synthesized nodes derive location from children when possible,
            // and fall back to the inherited rule-match range otherwise.
            _ => self
                .union_source_range_of_children(&fields)
                .or(source_range),
        };
        let id = self.nodes.len();
        self.nodes.push(Node {
            kind,
            kind_name: self.schema.node_kind_for_id(kind).unwrap(),
            fields,
            content,
            is_missing: false,
            is_error: false,
            is_extra: false,
            is_named,
            source_range,
        });
        id
    }

    fn union_source_range_of_children(
        &self,
        fields: &BTreeMap<FieldId, Vec<Id>>,
    ) -> Option<tree_sitter::Range> {
        let mut start_byte: Option<usize> = None;
        let mut end_byte: Option<usize> = None;
        let mut start_point = tree_sitter::Point { row: 0, column: 0 };
        let mut end_point = tree_sitter::Point { row: 0, column: 0 };

        for child_ids in fields.values() {
            for &child_id in child_ids {
                let Some(child) = self.get_node(child_id) else {
                    continue;
                };

                let child_start_byte = child.start_byte();
                let child_end_byte = child.end_byte();

                // Skip children that carry no usable location.
                if child_start_byte == 0 && child_end_byte == 0 {
                    continue;
                }

                match start_byte {
                    None => {
                        start_byte = Some(child_start_byte);
                        start_point = child.start_position();
                    }
                    Some(current_start) if child_start_byte < current_start => {
                        start_byte = Some(child_start_byte);
                        start_point = child.start_position();
                    }
                    _ => {}
                }

                match end_byte {
                    None => {
                        end_byte = Some(child_end_byte);
                        end_point = child.end_position();
                    }
                    Some(current_end) if child_end_byte > current_end => {
                        end_byte = Some(child_end_byte);
                        end_point = child.end_position();
                    }
                    _ => {}
                }
            }
        }

        match (start_byte, end_byte) {
            (Some(start_byte), Some(end_byte)) => Some(tree_sitter::Range {
                start_byte,
                end_byte,
                start_point,
                end_point,
            }),
            _ => None,
        }
    }

    pub fn create_named_token(&mut self, kind: &'static str, content: String) -> Id {
        self.create_named_token_with_range(kind, content, None)
    }

    /// Prepend a child id to the given field of the given node.
    pub fn prepend_field_child(&mut self, node_id: Id, field_id: FieldId, value_id: Id) {
        let node = self.nodes.get_mut(node_id).expect("prepend_field_child: invalid node id");
        node.fields.entry(field_id).or_default().insert(0, value_id);
    }

    pub fn create_named_token_with_range(
        &mut self,
        kind: &'static str,
        content: String,
        source_range: Option<tree_sitter::Range>,
    ) -> Id {
        let kind_id = self.schema.id_for_node_kind(kind).unwrap_or_else(|| {
            panic!("create_named_token: node kind '{kind}' not found in schema")
        });
        let id = self.nodes.len();
        self.nodes.push(Node {
            kind: kind_id,
            kind_name: kind,
            is_named: true,
            is_missing: false,
            is_error: false,
            source_range,
            is_extra: false,
            fields: BTreeMap::new(),
            content: NodeContent::DynamicString(content),
        });
        id
    }

    pub fn field_name_for_id(&self, id: FieldId) -> Option<&'static str> {
        self.schema.field_name_for_id(id)
    }

    pub fn field_id_for_name(&self, name: &str) -> Option<FieldId> {
        self.schema.field_id_for_name(name)
    }

    /// Print a node for debugging
    fn print_node(&self, node: &Node, source: &str) -> Value {
        let fields: BTreeMap<&'static str, Vec<Value>> = node
            .fields
            .iter()
            .map(|(field_id, nodes)| {
                let field_name = if field_id == &CHILD_FIELD {
                    "rest"
                } else {
                    self.field_name_for_id(*field_id).unwrap()
                };
                let nodes: Vec<Value> = nodes
                    .iter()
                    .map(|id| self.print_node(self.get_node(*id).unwrap(), source))
                    .collect();
                (field_name, nodes)
            })
            .collect();
        let mut value = BTreeMap::new();
        let kind = self.schema.node_kind_for_id(node.kind).unwrap();
        let content = match &node.content {
            NodeContent::Range(range) => source[range.start_byte..range.end_byte].to_string(),
            NodeContent::String(s) => s.to_string(),
            NodeContent::DynamicString(s) => s.clone(),
        };
        if fields.is_empty() {
            value.insert(kind, json!(content));
        } else {
            let mut fields: BTreeMap<_, _> =
                fields.into_iter().map(|(k, v)| (k, json!(v))).collect();
            fields.insert("content", json!(content));
            value.insert(kind, json!(fields));
        }
        json!(value)
    }

    pub fn id_for_node_kind(&self, kind: &str) -> Option<KindId> {
        let id = self.schema.id_for_node_kind(kind).unwrap_or(0);
        if id == 0 {
            None
        } else {
            Some(id)
        }
    }

    fn id_for_unnamed_node_kind(&self, kind: &str) -> Option<KindId> {
        let id = self.schema.id_for_unnamed_node_kind(kind).unwrap_or(0);
        if id == 0 {
            None
        } else {
            Some(id)
        }
    }
}

/// A node in our AST
#[derive(PartialEq, Eq, Debug, Clone, Serialize)]
pub struct Node {
    kind: KindId,
    kind_name: &'static str,
    pub(crate) fields: BTreeMap<FieldId, Vec<Id>>,
    pub(crate) content: NodeContent,
    /// For synthetic nodes, the source range of the original node they
    /// were desugared from. Used for location information in TRAP output.
    #[serde(skip)]
    source_range: Option<tree_sitter::Range>,
    is_named: bool,
    is_missing: bool,
    is_extra: bool,
    is_error: bool,
}

impl Node {
    pub fn kind(&self) -> &'static str {
        self.kind_name
    }

    pub fn kind_name(&self) -> &'static str {
        self.kind_name
    }

    pub fn is_named(&self) -> bool {
        self.is_named
    }

    pub fn is_missing(&self) -> bool {
        self.is_missing
    }

    pub fn is_extra(&self) -> bool {
        self.is_extra
    }

    pub fn is_error(&self) -> bool {
        self.is_error
    }

    fn fake_point(&self) -> tree_sitter::Point {
        tree_sitter::Point { row: 0, column: 0 }
    }

    pub fn start_position(&self) -> tree_sitter::Point {
        match self.content {
            NodeContent::Range(range) => range.start_point,
            _ => self
                .source_range
                .map_or_else(|| self.fake_point(), |r| r.start_point),
        }
    }

    pub fn end_position(&self) -> tree_sitter::Point {
        match self.content {
            NodeContent::Range(range) => range.end_point,
            _ => self
                .source_range
                .map_or_else(|| self.fake_point(), |r| r.end_point),
        }
    }

    pub fn start_byte(&self) -> usize {
        match self.content {
            NodeContent::Range(range) => range.start_byte,
            _ => self.source_range.map_or(0, |r| r.start_byte),
        }
    }

    pub fn end_byte(&self) -> usize {
        match self.content {
            NodeContent::Range(range) => range.end_byte,
            _ => self.source_range.map_or(0, |r| r.end_byte),
        }
    }

    pub fn byte_range(&self) -> std::ops::Range<usize> {
        self.start_byte()..self.end_byte()
    }

    pub fn opt_string_content(&self) -> Option<String> {
        match &self.content {
            NodeContent::Range(_range) => None,
            NodeContent::String(s) => Some(s.to_string()),
            NodeContent::DynamicString(s) => Some(s.to_string()),
        }
    }

    /// Read the child ids stored under a given field, or an empty slice if
    /// no such field is present on this node.
    pub fn field_children(&self, field_id: FieldId) -> &[Id] {
        self.fields
            .get(&field_id)
            .map(|v| v.as_slice())
            .unwrap_or(&[])
    }
}

/// The contents of a node is either a range in the original source file,
/// or a new string if the node is synthesized.
#[derive(PartialEq, Eq, Debug, Clone, Serialize)]
pub enum NodeContent {
    Range(#[serde(with = "range::Range")] tree_sitter::Range),
    String(&'static str),
    DynamicString(String),
}

impl From<&'static str> for NodeContent {
    fn from(value: &'static str) -> Self {
        NodeContent::String(value)
    }
}

impl From<tree_sitter::Range> for NodeContent {
    fn from(value: tree_sitter::Range) -> Self {
        NodeContent::Range(value)
    }
}

/// A handle that lets a rule transform recursively translate AST nodes via
/// the framework's rule machinery. Constructed by the driver and passed as
/// the last argument of every [`Transform`] invocation.
///
/// The `rule!` macro uses [`TranslatorHandle::auto_translate_captures`] in
/// its generated prefix to translate captures before running the user's
/// transform body. Manually-written transforms (using [`Rule::new`]
/// directly) can call [`TranslatorHandle::translate`] selectively on
/// specific node ids to control when translation happens.
pub struct TranslatorHandle<'a, C> {
    inner: TranslatorImpl<'a, C>,
}

/// Internal phase-specific translation state. Kept private — callers
/// interact with [`TranslatorHandle`] only.
enum TranslatorImpl<'a, C> {
    /// OneShot phase translator: recursively applies OneShot rules.
    OneShot {
        index: &'a RuleIndex<'a, C>,
        fresh: &'a tree_builder::FreshScope,
        rewrite_depth: usize,
        /// The id of the node the current rule is matching. Used by
        /// [`auto_translate_captures`] to avoid infinite recursion when a
        /// rule captures its own match root (e.g. via `(_) @_`).
        matched_root: Id,
    },
    /// Repeating phase translator: translation is not meaningful here
    /// (input and output schemas are the same). [`translate`] errors;
    /// [`auto_translate_captures`] is a no-op so the macro's auto-prefix
    /// works unchanged for Repeating rules.
    Repeating,
}

impl<'a, C: Clone> TranslatorHandle<'a, C> {
    /// Recursively apply OneShot rules to `id` and return the resulting
    /// node ids. Errors in a Repeating phase (where translation is not
    /// meaningful).
    pub fn translate(
        &self,
        ast: &mut Ast,
        user_ctx: &mut C,
        id: Id,
    ) -> Result<Vec<Id>, String> {
        match &self.inner {
            TranslatorImpl::OneShot {
                index,
                fresh,
                rewrite_depth,
                ..
            } => apply_one_shot_rules_inner(index, ast, user_ctx, id, fresh, rewrite_depth + 1),
            TranslatorImpl::Repeating => {
                Err("translate() is not available in a Repeating phase".into())
            }
        }
    }

    /// Translate every captured node in `captures` in place (OneShot phase
    /// only). In a Repeating phase this is a no-op — Repeating rules
    /// receive raw captures.
    ///
    /// Used by the `rule!` macro's generated prefix to preserve the
    /// pre-existing "auto-translate captures before running the transform
    /// body" behavior. Manually-written transforms typically translate
    /// captures selectively via [`translate`] instead.
    ///
    /// To avoid infinite recursion, a capture whose id matches the rule's
    /// matched root (e.g. from a `(_) @_` pattern) is left unchanged.
    pub fn auto_translate_captures(
        &self,
        captures: &mut Captures,
        ast: &mut Ast,
        user_ctx: &mut C,
    ) -> Result<(), String> {
        match &self.inner {
            TranslatorImpl::OneShot { matched_root, .. } => {
                let root = *matched_root;
                captures.try_map_all_captures(|cid| {
                    if cid == root {
                        Ok(vec![cid])
                    } else {
                        self.translate(ast, user_ctx, cid)
                    }
                })
            }
            TranslatorImpl::Repeating => Ok(()),
        }
    }
}

/// The transform function for a rule.
///
/// Takes the AST, the (raw, untranslated) captured variables, a fresh-name
/// scope, the source range of the matched node, a mutable reference to the
/// user context of type `C`, and a [`TranslatorHandle`] for recursively
/// translating nodes. Returns the IDs of the replacement nodes, or an
/// error message if the transform could not be completed.
///
/// Transforms produced by [`Rule::new`] receive **raw** captures and must
/// translate them themselves (via the handle). Transforms produced by the
/// `rule!` macro have an auto-translation prefix injected for backward
/// compatibility.
pub type Transform<C = ()> = Box<
    dyn Fn(
            &mut Ast,
            Captures,
            &tree_builder::FreshScope,
            Option<tree_sitter::Range>,
            &mut C,
            TranslatorHandle<'_, C>,
        ) -> Result<Vec<Id>, String>
        + Send
        + Sync,
>;

pub struct Rule<C = ()> {
    query: QueryNode,
    transform: Transform<C>,
    /// If true, after this rule fires on a node the engine will try to
    /// re-apply this same rule on the result root. Defaults to false:
    /// each rule fires at most once on a given node, which prevents
    /// accidental loops where a rule's output matches its own query.
    repeated: bool,
}

impl<C> Rule<C> {
    pub fn new(query: QueryNode, transform: Transform<C>) -> Self {
        Self {
            query,
            transform,
            repeated: false,
        }
    }

    /// Mark this rule as allowed to fire multiple times on the same node.
    /// Use when the rule is intentionally iterative (its output may match
    /// its own query). Without this, a rule fires at most once per node;
    /// other rules can still fire on the result.
    pub fn repeated(mut self) -> Self {
        self.repeated = true;
        self
    }

    fn try_rule(
        &self,
        ast: &mut Ast,
        node: Id,
        fresh: &tree_builder::FreshScope,
        user_ctx: &mut C,
        translator: TranslatorHandle<'_, C>,
    ) -> Result<Option<Vec<Id>>, String> {
        match self.try_match(ast, node)? {
            Some(captures) => Ok(Some(self.run_transform(
                ast, captures, node, fresh, user_ctx, translator,
            )?)),
            None => Ok(None),
        }
    }

    /// Attempt to match this rule's query against `node`, returning the
    /// resulting captures on success. Does not invoke the transform.
    fn try_match(&self, ast: &Ast, node: Id) -> Result<Option<Captures>, String> {
        let mut captures = Captures::new();
        if self.query.do_match(ast, node, &mut captures)? {
            Ok(Some(captures))
        } else {
            Ok(None)
        }
    }

    /// Run this rule's transform with the given captures, using `node`'s
    /// source range as the source range of the produced nodes.
    fn run_transform(
        &self,
        ast: &mut Ast,
        captures: Captures,
        node: Id,
        fresh: &tree_builder::FreshScope,
        user_ctx: &mut C,
        translator: TranslatorHandle<'_, C>,
    ) -> Result<Vec<Id>, String> {
        fresh.next_scope();
        let source_range = ast.get_node(node).and_then(|n| match n.content {
            NodeContent::Range(r) => Some(r),
            _ => n.source_range,
        });
        (self.transform)(ast, captures, fresh, source_range, user_ctx, translator)
    }
}

const MAX_REWRITE_DEPTH: usize = 100;

/// Index of rules by their root query kind for fast lookup.
struct RuleIndex<'a, C> {
    /// Rules indexed by root node kind name.
    by_kind: BTreeMap<&'static str, Vec<&'a Rule<C>>>,
    /// Rules with wildcard queries (Any) that apply to all nodes.
    wildcard: Vec<&'a Rule<C>>,
}

impl<'a, C> RuleIndex<'a, C> {
    fn new(rules: &'a [Rule<C>]) -> Self {
        let mut by_kind: BTreeMap<&'static str, Vec<&'a Rule<C>>> = BTreeMap::new();
        let mut wildcard = Vec::new();
        for rule in rules {
            match rule.query.root_kind() {
                Some(kind) => by_kind.entry(kind).or_default().push(rule),
                None => wildcard.push(rule),
            }
        }
        Self { by_kind, wildcard }
    }

    fn rules_for_kind(&self, kind: &str) -> impl Iterator<Item = &&'a Rule<C>> {
        self.by_kind
            .get(kind)
            .into_iter()
            .flat_map(|v| v.iter())
            .chain(self.wildcard.iter())
    }
}

fn apply_repeating_rules<C: Clone>(
    rules: &[Rule<C>],
    ast: &mut Ast,
    user_ctx: &mut C,
    id: Id,
    fresh: &tree_builder::FreshScope,
) -> Result<Vec<Id>, String> {
    let index = RuleIndex::new(rules);
    apply_repeating_rules_inner(&index, ast, user_ctx, id, fresh, 0, None)
}

fn apply_repeating_rules_inner<C: Clone>(
    index: &RuleIndex<C>,
    ast: &mut Ast,
    user_ctx: &mut C,
    id: Id,
    fresh: &tree_builder::FreshScope,
    rewrite_depth: usize,
    skip_rule: Option<*const Rule<C>>,
) -> Result<Vec<Id>, String> {
    if rewrite_depth > MAX_REWRITE_DEPTH {
        return Err(format!(
            "Desugaring exceeded maximum rewrite depth ({MAX_REWRITE_DEPTH}). \
             This likely indicates a non-terminating rule cycle."
        ));
    }

    let node_kind = ast.get_node(id).map(|n| n.kind()).unwrap_or("");
    for rule in index.rules_for_kind(node_kind) {
        let rule_ptr = *rule as *const Rule<C>;
        if Some(rule_ptr) == skip_rule {
            continue;
        }
        // Snapshot the user context before invoking the rule so that any
        // mutations the rule makes are visible during recursive translation
        // of its result, but not leaked to the parent's siblings.
        let snapshot = user_ctx.clone();
        // Repeating rules don't need a real translator: their captures
        // aren't auto-translated (Repeating preserves the input schema),
        // and `ctx.translate(id)` errors if invoked from a Repeating
        // transform.
        let translator = TranslatorHandle {
            inner: TranslatorImpl::Repeating,
        };
        let try_result = rule.try_rule(ast, id, fresh, user_ctx, translator)?;
        if let Some(result_node) = try_result {
            // For non-repeated rules, suppress further application of *this*
            // rule on the result root, so a rule whose output matches its own
            // query doesn't loop. Other rules and child traversal are
            // unaffected.
            let next_skip = if rule.repeated { None } else { Some(rule_ptr) };
            let mut results = Vec::new();
            for node in result_node {
                results.extend(apply_repeating_rules_inner(
                    index,
                    ast,
                    user_ctx,
                    node,
                    fresh,
                    rewrite_depth + 1,
                    next_skip,
                )?);
            }
            *user_ctx = snapshot;
            return Ok(results);
        }
        // Rule didn't match; restore any speculative changes (none expected
        // since try_rule only mutates on match, but be defensive).
        *user_ctx = snapshot;
    }

    // Take the parent's fields by ownership: the recursion will rewrite
    // each child Id, and we'll write the (possibly mutated) field map back
    // when we're done. Avoids cloning the whole BTreeMap and its child
    // Vecs on entry. Each child Vec is only re-allocated if a rewrite
    // actually changes its contents.
    //
    // Child traversal does not increment rewrite depth and starts fresh
    // (no rule is skipped on child subtrees).
    let mut fields = std::mem::take(&mut ast.nodes[id].fields);
    for children in fields.values_mut() {
        let mut new_children: Option<Vec<Id>> = None;
        for (i, &child_id) in children.iter().enumerate() {
            let result = apply_repeating_rules_inner(index, ast, user_ctx, child_id, fresh, rewrite_depth, None)?;
            let unchanged = result.len() == 1 && result[0] == child_id;
            match (&mut new_children, unchanged) {
                (None, true) => {} // unchanged so far, no allocation needed
                (None, false) => {
                    // First divergence — copy already-processed Ids and
                    // start collecting the rewritten sequence.
                    let mut new = Vec::with_capacity(children.len());
                    new.extend_from_slice(&children[..i]);
                    new.extend(result);
                    new_children = Some(new);
                }
                (Some(new), _) => {
                    new.extend(result);
                }
            }
        }
        if let Some(new) = new_children {
            *children = new;
        }
    }
    ast.nodes[id].fields = fields;
    Ok(vec![id])
}

/// Apply rules using `OneShot` semantics: the first matching rule fires on
/// each visited node, recursion proceeds only through captured nodes (not
/// through the input node's children directly), and an error is returned if
/// no rule matches a visited node.
fn apply_one_shot_rules<C: Clone>(
    rules: &[Rule<C>],
    ast: &mut Ast,
    user_ctx: &mut C,
    id: Id,
    fresh: &tree_builder::FreshScope,
) -> Result<Vec<Id>, String> {
    let index = RuleIndex::new(rules);
    apply_one_shot_rules_inner(&index, ast, user_ctx, id, fresh, 0)
}

fn apply_one_shot_rules_inner<C: Clone>(
    index: &RuleIndex<C>,
    ast: &mut Ast,
    user_ctx: &mut C,
    id: Id,
    fresh: &tree_builder::FreshScope,
    rewrite_depth: usize,
) -> Result<Vec<Id>, String> {

    if rewrite_depth > MAX_REWRITE_DEPTH {
        return Err(format!(
            "Desugaring exceeded maximum rewrite depth ({MAX_REWRITE_DEPTH}). \
             This likely indicates a non-terminating rule cycle."
        ));
    }

    let node_kind = ast.get_node(id).map(|n| n.kind()).unwrap_or("");

    for rule in index.rules_for_kind(node_kind) {
        if let Some(captures) = rule.try_match(ast, id)? {
            // Snapshot the user context before invoking the rule so that any
            // mutations the rule (or its transitively-translated captures)
            // make are visible during this rule's transform, but not leaked
            // to the parent's siblings.
            let snapshot = user_ctx.clone();
            // Build the translator handle the transform will use to
            // recursively translate captures (or, for macro-generated
            // rules, the auto-translate prefix uses it to translate every
            // capture up front, preserving the legacy behavior).
            let translator = TranslatorHandle {
                inner: TranslatorImpl::OneShot {
                    index,
                    fresh,
                    rewrite_depth,
                    matched_root: id,
                },
            };
            let result = rule.run_transform(ast, captures, id, fresh, user_ctx, translator)?;
            *user_ctx = snapshot;
            return Ok(result);
        }
    }

    Err(format!(
        "OneShot: no rule matched node of kind '{node_kind}'"
    ))
}

#[derive(Clone, Copy, Debug, PartialEq, Eq)]
pub enum PhaseKind {
    /// A node is re-processed until none of the rules in the phase matches,
    /// albeit a single rule cannot be applied twice in a row unless that rule is also marked as repeating.
    /// When a node no longer matches any rules, its children are recursively processed (top down).
    Repeating,

    /// A node is processed by the first matching rule, and the engine panics if no rule matches.
    /// Rules are then recursively applied to every captured node.
    /// In practice this is used when translating from one AST schema to another, where every node must be rewritten,
    /// and it would be a type error to match the rule patterns (based on the input schema) against the output nodes (which conform to the output schema).
    OneShot,
}

/// One phase of a desugaring pass: a named bundle of rules that runs to
/// completion (a full traversal applying its rules) before the next phase
/// starts. Rules within a phase compete for matches as usual; rules in
/// different phases never compete because each traversal only considers the
/// current phase's rules.
pub struct Phase<C = ()> {
    /// Name used in error messages.
    pub name: String,
    pub rules: Vec<Rule<C>>,
    pub kind: PhaseKind,
}

impl<C> Phase<C> {
    pub fn new(name: impl Into<String>, kind: PhaseKind, rules: Vec<Rule<C>>) -> Self {
        Self {
            name: name.into(),
            rules,
            kind,
        }
    }
}

/// Configuration for a desugaring pass: an ordered list of [`Phase`]s and
/// an optional output node-types schema (in YAML format).
///
/// When attached to a `LanguageSpec` (in the shared tree-sitter extractor),
/// enables yeast-based AST rewriting before TRAP extraction. The same YAML
/// is used both to validate TRAP output (via JSON conversion) and to
/// resolve output-only node kinds and fields at runtime.
///
/// Construct with `DesugaringConfig::new()` and add phases via
/// `add_phase`:
///
/// ```ignore
/// let config = yeast::DesugaringConfig::new()
///     .add_phase("cleanup", PhaseKind::Repeating, cleanup_rules)
///     .add_phase("desugar", PhaseKind::Repeating, desugar_rules)
///     .with_output_node_types_yaml(yaml);
/// ```
///
/// The optional type parameter `C` is the user context type threaded through
/// rule transforms. Defaults to `()` (no user context).
pub struct DesugaringConfig<C = ()> {
    /// Phases of rule application, applied in order.
    pub phases: Vec<Phase<C>>,
    /// Output node-types in YAML format. If `None`, the input grammar's
    /// node types are used (i.e. the desugared AST has the same node types
    /// as the tree-sitter grammar).
    pub output_node_types_yaml: Option<&'static str>,
}

// Manual `Default` impl so users with a custom `C` that doesn't implement
// `Default` can still construct an empty config.
impl<C> Default for DesugaringConfig<C> {
    fn default() -> Self {
        Self {
            phases: Vec::new(),
            output_node_types_yaml: None,
        }
    }
}

impl<C> DesugaringConfig<C> {
    /// Create an empty configuration. Add phases via [`add_phase`] and an
    /// optional output schema via [`with_output_node_types_yaml`].
    pub fn new() -> Self {
        Self::default()
    }

    /// Append a new phase with the given name, kind, and rules.
    pub fn add_phase(
        mut self,
        name: impl Into<String>,
        kind: PhaseKind,
        rules: Vec<Rule<C>>,
    ) -> Self {
        self.phases.push(Phase::new(name, kind, rules));
        self
    }

    pub fn with_output_node_types_yaml(mut self, yaml: &'static str) -> Self {
        self.output_node_types_yaml = Some(yaml);
        self
    }

    /// Build the yeast `Schema` for this config, given the input language.
    /// If `output_node_types_yaml` is `None`, returns the schema derived from
    /// the input grammar.
    pub fn build_schema(&self, language: &tree_sitter::Language) -> Result<schema::Schema, String> {
        match self.output_node_types_yaml {
            Some(yaml) => node_types_yaml::schema_from_yaml_with_language(yaml, language),
            None => Ok(schema::Schema::from_language(language)),
        }
    }
}

pub struct Runner<'a, C = ()> {
    language: tree_sitter::Language,
    schema: schema::Schema,
    phases: &'a [Phase<C>],
}

impl<'a, C> Runner<'a, C> {
    /// Create a runner using the input grammar's schema for output.
    pub fn new(language: tree_sitter::Language, phases: &'a [Phase<C>]) -> Self {
        let schema = schema::Schema::from_language(&language);
        Self {
            language,
            schema,
            phases,
        }
    }

    /// Create a runner with separate input language and output schema.
    pub fn with_schema(
        language: tree_sitter::Language,
        schema: &schema::Schema,
        phases: &'a [Phase<C>],
    ) -> Self {
        Self {
            language,
            schema: schema.clone(),
            phases,
        }
    }

    /// Create a runner from a [`DesugaringConfig`].
    pub fn from_config(
        language: tree_sitter::Language,
        config: &'a DesugaringConfig<C>,
    ) -> Result<Self, String> {
        let schema = config.build_schema(&language)?;
        Ok(Self {
            language,
            schema,
            phases: &config.phases,
        })
    }
}

impl<'a, C: Clone> Runner<'a, C> {
    /// Parse `tree` against `source` and run all phases, threading
    /// `user_ctx` through every rule transform. The caller owns the
    /// initial context state.
    pub fn run_from_tree_with_ctx(
        &self,
        tree: &tree_sitter::Tree,
        source: &[u8],
        user_ctx: &mut C,
    ) -> Result<Ast, String> {
        let mut ast = Ast::from_tree_with_schema_and_source(
            self.schema.clone(),
            tree,
            &self.language,
            source.to_vec(),
        );
        self.run_phases(&mut ast, user_ctx)?;
        Ok(ast)
    }

    /// Parse `input` and run all phases, threading `user_ctx` through
    /// every rule transform. The caller owns the initial context state.
    pub fn run_with_ctx(&self, input: &str, user_ctx: &mut C) -> Result<Ast, String> {
        let mut parser = tree_sitter::Parser::new();
        parser
            .set_language(&self.language)
            .map_err(|e| format!("Failed to set language: {e}"))?;
        let tree = parser
            .parse(input, None)
            .ok_or_else(|| "Failed to parse input".to_string())?;
        let mut ast = Ast::from_tree_with_schema_and_source(
            self.schema.clone(),
            &tree,
            &self.language,
            input.as_bytes().to_vec(),
        );
        self.run_phases(&mut ast, user_ctx)?;
        Ok(ast)
    }

    /// Apply each phase in turn to the AST, threading the root through.
    /// A single `FreshScope` is shared across phases so that fresh
    /// identifiers generated in different phases don't collide.
    fn run_phases(&self, ast: &mut Ast, user_ctx: &mut C) -> Result<(), String> {
        let fresh = tree_builder::FreshScope::new();
        let mut root = ast.get_root();
        for phase in self.phases {
            let res = match phase.kind {
                PhaseKind::Repeating => apply_repeating_rules(&phase.rules, ast, user_ctx, root, &fresh),
                PhaseKind::OneShot => apply_one_shot_rules(&phase.rules, ast, user_ctx, root, &fresh),
            }
            .map_err(|e| format!("Phase `{}`: {e}", phase.name))?;
            if res.len() != 1 {
                return Err(format!(
                    "Phase `{}`: expected exactly one result node, got {}",
                    phase.name,
                    res.len()
                ));
            }
            root = res[0];
        }
        ast.set_root(root);
        Ok(())
    }
}

impl<'a, C: Clone + Default> Runner<'a, C> {
    /// Parse `tree` against `source` and run all phases, using the
    /// default context (`C::default()`) as the initial context state.
    pub fn run_from_tree(
        &self,
        tree: &tree_sitter::Tree,
        source: &[u8],
    ) -> Result<Ast, String> {
        let mut user_ctx = C::default();
        self.run_from_tree_with_ctx(tree, source, &mut user_ctx)
    }

    /// Parse `input` and run all phases, using the default context
    /// (`C::default()`) as the initial context state.
    pub fn run(&self, input: &str) -> Result<Ast, String> {
        let mut user_ctx = C::default();
        self.run_with_ctx(input, &mut user_ctx)
    }
}

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
type Id = usize;

/// Field and Kind ids are provided by tree-sitter
type FieldId = u16;
type KindId = u16;

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
        let mut visitor = visitor::Visitor::new(language.clone());
        visitor.visit(tree);

        visitor.build_with_schema(schema)
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

    pub fn create_named_token(&mut self, kind: &'static str, content: String) -> Id {
        self.create_named_token_with_range(kind, content, None)
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

/// The transform function for a rule: takes the AST, captured variables, a
/// fresh-name scope, and the source range of the matched node, and returns
/// the IDs of the replacement nodes.
pub type Transform = Box<
    dyn Fn(&mut Ast, Captures, &tree_builder::FreshScope, Option<tree_sitter::Range>) -> Vec<Id>
        + Send
        + Sync,
>;

pub struct Rule {
    query: QueryNode,
    transform: Transform,
    /// If true, after this rule fires on a node the engine will try to
    /// re-apply this same rule on the result root. Defaults to false:
    /// each rule fires at most once on a given node, which prevents
    /// accidental loops where a rule's output matches its own query.
    repeated: bool,
}

impl Rule {
    pub fn new(query: QueryNode, transform: Transform) -> Self {
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
    ) -> Result<Option<Vec<Id>>, String> {
        match self.try_match(ast, node)? {
            Some(captures) => Ok(Some(self.run_transform(ast, captures, node, fresh))),
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
    ) -> Vec<Id> {
        fresh.next_scope();
        let source_range = ast.get_node(node).and_then(|n| match n.content {
            NodeContent::Range(r) => Some(r),
            _ => n.source_range,
        });
        (self.transform)(ast, captures, fresh, source_range)
    }
}

const MAX_REWRITE_DEPTH: usize = 100;

/// Index of rules by their root query kind for fast lookup.
struct RuleIndex<'a> {
    /// Rules indexed by root node kind name.
    by_kind: BTreeMap<&'static str, Vec<&'a Rule>>,
    /// Rules with wildcard queries (Any) that apply to all nodes.
    wildcard: Vec<&'a Rule>,
}

impl<'a> RuleIndex<'a> {
    fn new(rules: &'a [Rule]) -> Self {
        let mut by_kind: BTreeMap<&'static str, Vec<&'a Rule>> = BTreeMap::new();
        let mut wildcard = Vec::new();
        for rule in rules {
            match rule.query.root_kind() {
                Some(kind) => by_kind.entry(kind).or_default().push(rule),
                None => wildcard.push(rule),
            }
        }
        Self { by_kind, wildcard }
    }

    fn rules_for_kind(&self, kind: &str) -> impl Iterator<Item = &&'a Rule> {
        self.by_kind
            .get(kind)
            .into_iter()
            .flat_map(|v| v.iter())
            .chain(self.wildcard.iter())
    }
}

fn apply_repeating_rules(
    rules: &[Rule],
    ast: &mut Ast,
    id: Id,
    fresh: &tree_builder::FreshScope,
) -> Result<Vec<Id>, String> {
    let index = RuleIndex::new(rules);
    apply_repeating_rules_inner(&index, ast, id, fresh, 0, None)
}

fn apply_repeating_rules_inner(
    index: &RuleIndex,
    ast: &mut Ast,
    id: Id,
    fresh: &tree_builder::FreshScope,
    rewrite_depth: usize,
    skip_rule: Option<*const Rule>,
) -> Result<Vec<Id>, String> {
    if rewrite_depth > MAX_REWRITE_DEPTH {
        return Err(format!(
            "Desugaring exceeded maximum rewrite depth ({MAX_REWRITE_DEPTH}). \
             This likely indicates a non-terminating rule cycle."
        ));
    }

    let node_kind = ast.get_node(id).map(|n| n.kind()).unwrap_or("");
    for rule in index.rules_for_kind(node_kind) {
        let rule_ptr = *rule as *const Rule;
        if Some(rule_ptr) == skip_rule {
            continue;
        }
        if let Some(result_node) = rule.try_rule(ast, id, fresh)? {
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
                    node,
                    fresh,
                    rewrite_depth + 1,
                    next_skip,
                )?);
            }
            return Ok(results);
        }
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
            let result = apply_repeating_rules_inner(index, ast, child_id, fresh, rewrite_depth, None)?;
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
fn apply_one_shot_rules(
    rules: &[Rule],
    ast: &mut Ast,
    id: Id,
    fresh: &tree_builder::FreshScope,
) -> Result<Vec<Id>, String> {
    let index = RuleIndex::new(rules);
    apply_one_shot_rules_inner(&index, ast, id, fresh, 0)
}

fn apply_one_shot_rules_inner(
    index: &RuleIndex,
    ast: &mut Ast,
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
        if let Some(mut captures) = rule.try_match(ast, id)? {
            // Recursively translate every captured node before invoking the
            // transform. The transform's output uses output-schema kinds, so
            // we must translate captured input-schema nodes to their
            // output-schema equivalents first.
            captures.try_map_all_captures(|captured_id| {
                let result =
                    apply_one_shot_rules_inner(index, ast, captured_id, fresh, rewrite_depth + 1)?;
                if result.len() != 1 {
                    return Err(format!(
                        "OneShot: recursion on captured node produced {} results, expected exactly 1",
                        result.len()
                    ));
                }
                Ok(result[0])
            })?;
            return Ok(rule.run_transform(ast, captures, id, fresh));
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
pub struct Phase {
    /// Name used in error messages.
    pub name: String,
    pub rules: Vec<Rule>,
    pub kind: PhaseKind,
}

impl Phase {
    pub fn new(name: impl Into<String>, kind: PhaseKind, rules: Vec<Rule>) -> Self {
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
#[derive(Default)]
pub struct DesugaringConfig {
    /// Phases of rule application, applied in order.
    pub phases: Vec<Phase>,
    /// Output node-types in YAML format. If `None`, the input grammar's
    /// node types are used (i.e. the desugared AST has the same node types
    /// as the tree-sitter grammar).
    pub output_node_types_yaml: Option<&'static str>,
}

impl DesugaringConfig {
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
        rules: Vec<Rule>,
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

pub struct Runner<'a> {
    language: tree_sitter::Language,
    schema: schema::Schema,
    phases: &'a [Phase],
}

impl<'a> Runner<'a> {
    /// Create a runner using the input grammar's schema for output.
    pub fn new(language: tree_sitter::Language, phases: &'a [Phase]) -> Self {
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
        phases: &'a [Phase],
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
        config: &'a DesugaringConfig,
    ) -> Result<Self, String> {
        let schema = config.build_schema(&language)?;
        Ok(Self {
            language,
            schema,
            phases: &config.phases,
        })
    }

    pub fn run_from_tree(&self, tree: &tree_sitter::Tree) -> Result<Ast, String> {
        let mut ast = Ast::from_tree_with_schema(self.schema.clone(), tree, &self.language);
        self.run_phases(&mut ast)?;
        Ok(ast)
    }

    pub fn run(&self, input: &str) -> Result<Ast, String> {
        let mut parser = tree_sitter::Parser::new();
        parser
            .set_language(&self.language)
            .map_err(|e| format!("Failed to set language: {e}"))?;
        let tree = parser
            .parse(input, None)
            .ok_or_else(|| "Failed to parse input".to_string())?;
        let mut ast = Ast::from_tree_with_schema(self.schema.clone(), &tree, &self.language);
        self.run_phases(&mut ast)?;
        Ok(ast)
    }

    /// Apply each phase in turn to the AST, threading the root through.
    /// A single `FreshScope` is shared across phases so that fresh
    /// identifiers generated in different phases don't collide.
    fn run_phases(&self, ast: &mut Ast) -> Result<(), String> {
        let fresh = tree_builder::FreshScope::new();
        let mut root = ast.get_root();
        for phase in self.phases {
            let res = match phase.kind {
                PhaseKind::Repeating => apply_repeating_rules(&phase.rules, ast, root, &fresh),
                PhaseKind::OneShot => apply_one_shot_rules(&phase.rules, ast, root, &fresh),
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

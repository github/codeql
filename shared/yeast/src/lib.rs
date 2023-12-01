// Uncomment to debug macros
//#![feature(trace_macros)]

use std::collections::BTreeMap;

use serde::Serialize;
use serde_json::{json, Value};

pub mod captures;
pub mod cursor;
pub mod print;
pub mod query;
mod range;
pub mod tree_builder;
mod visitor;

use captures::Captures;
pub use cursor::Cursor;
use query::QueryNode;

/// Node ids are indexes into the arena
type Id = usize;

/// Field and Kind ids are provided by tree-sitter
type FieldId = u16;
type KindId = u16;

pub const CHILD_FIELD: u16 = u16::MAX;
const CHILD_FIELD_NAME: &str = "child";

#[derive(Debug)]
pub struct AstCursor<'a> {
    ast: &'a Ast,
    /// A stack of parents, along with iterators for their children
    parents: Vec<(&'a Node, ChildrenIter<'a>)>,
    node: &'a Node,
}

impl<'a> AstCursor<'a> {
    pub fn new(ast: &'a Ast) -> Self {
        // TODO: handle non-zero root
        let node = ast.get_node(ast.root).unwrap();
        Self {
            ast,
            parents: vec![],
            node,
        }
    }

    fn goto_next_sibling_opt(&mut self) -> Option<()> {
        self.node = self.parents.last_mut()?.1.next()?;
        Some(())
    }

    fn goto_first_child_opt(&mut self) -> Option<()> {
        let parent = self.node;
        let mut children = ChildrenIter::new(self.ast, parent);
        let first_child = children.next()?;
        self.node = first_child;
        self.parents.push((parent, children));
        Some(())
    }

    fn goto_parent_opt(&mut self) -> Option<()> {
        self.node = self.parents.pop()?.0;
        Some(())
    }

    pub fn field_name(&self) -> Option<&'static str> {
        if self.field_id() == Some(CHILD_FIELD) {
            return None;
        }
        self.field_id()
            .and_then(|id| self.ast.field_name_for_id(id))
    }
}
impl<'a> Cursor<'a, Ast, Node, FieldId> for AstCursor<'a> {
    fn node(&self) -> &'a Node {
        self.node
    }

    fn field_id(&self) -> Option<FieldId> {
        let (_, children) = self.parents.last()?;
        children.current_field()
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

/// An iterator over all the child nodes of a node.
#[derive(Debug)]
struct ChildrenIter<'a> {
    ast: &'a Ast,
    current_field: Option<FieldId>,
    fields: std::collections::btree_map::Iter<'a, FieldId, Vec<Id>>,
    field_children: Option<std::slice::Iter<'a, Id>>,
}

impl<'a> ChildrenIter<'a> {
    fn new(ast: &'a Ast, node: &'a Node) -> Self {
        Self {
            ast,
            current_field: None,
            fields: node.fields.iter(),
            field_children: None,
        }
    }

    fn get_node(&self, id: Id) -> &'a Node {
        self.ast.get_node(id).unwrap()
    }

    fn current_field(&self) -> Option<FieldId> {
        self.current_field
    }
}

impl<'a> Iterator for ChildrenIter<'a> {
    type Item = &'a Node;

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
                Some(child_id) => Some(self.get_node(*child_id)),
            },
        }
    }
}

/// Our AST
#[derive(PartialEq, Eq, Debug)]
pub struct Ast {
    root: Id,
    nodes: Vec<Node>,
    language: tree_sitter::Language,
}

impl Ast {
    /// Construct an AST from a TS tree
    pub fn from_tree(language: tree_sitter::Language, tree: &tree_sitter::Tree) -> Self {
        let mut visitor = visitor::Visitor::new(language);
        visitor.visit(tree);
        visitor.build()
    }

    pub fn walk(&self) -> AstCursor {
        AstCursor::new(self)
    }

    pub fn nodes(&self) -> &[Node] {
        &self.nodes
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

    fn create_node(
        &mut self,
        kind: KindId,
        content: NodeContent,
        mut fields: BTreeMap<FieldId, Vec<Id>>,
        children: Vec<Id>,
        is_named: bool,
    ) -> Id {
        let id = self.nodes.len();
        fields.insert(CHILD_FIELD, children);
        self.nodes.push(Node {
            id,
            kind,
            kind_name: self.language.node_kind_for_id(kind).unwrap(),
            fields,
            content,
            is_missing: false,
            is_error: false,
            is_extra: false,
            is_named,
        });
        id
    }

    fn field_name_for_id(&self, id: FieldId) -> Option<&'static str> {
        if id == CHILD_FIELD {
            Some(CHILD_FIELD_NAME)
        } else {
            self.language.field_name_for_id(id)
        }
    }

    fn kind_name_for_id(&self, id: KindId) -> Option<&'static str> {
        self.language.node_kind_for_id(id)
    }

    /// Print a node for debugging
    fn print_node(&self, node: &Node, source: &str) -> Value {
        let fields: BTreeMap<_, _> = node
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
        let kind = self.language.node_kind_for_id(node.kind).unwrap();
        let content = match node.content {
            NodeContent::Range(range) => {
                let len = range.end_byte - range.start_byte;
                let end = range.start_byte + len;
                source.as_bytes()[range.start_byte..end]
                    .iter()
                    .map(|b| *b as char)
                    .collect()
            }
            NodeContent::String(s) => s.to_string(),
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

    /// Return an example AST, for testing and to fill implementation gaps
    pub fn example(language: tree_sitter::Language) -> Self {
        // x = 1
        Self {
            root: 0,
            language,
            nodes: vec![
                // assignment
                Node {
                    id: 0,
                    kind: 276,
                    kind_name: "assignment",
                    fields: {
                        let mut map = BTreeMap::new();
                        map.insert(18, vec![1]);
                        map.insert(28, vec![3]);
                        map
                    },
                    content: NodeContent::String("x = 1"),
                    is_missing: false,
                    is_error: false,
                    is_extra: false,
                    is_named: true,
                },
                // identifier
                Node {
                    id: 1,
                    kind: 1,
                    kind_name: "identifier",
                    fields: BTreeMap::new(),
                    content: NodeContent::String("x"),
                    is_missing: false,
                    is_error: false,
                    is_extra: false,
                    is_named: true,
                },
                // "="
                Node {
                    id: 2,
                    kind: 17,
                    kind_name: "=",
                    fields: BTreeMap::new(),
                    content: NodeContent::String("="),
                    is_missing: false,
                    is_error: false,
                    is_extra: false,
                    is_named: false,
                },
                // integer
                Node {
                    id: 3,
                    kind: 110,
                    kind_name: "integer",
                    fields: BTreeMap::new(),
                    content: NodeContent::String("1"),
                    is_missing: false,
                    is_error: false,
                    is_extra: false,
                    is_named: true,
                },
            ],
        }
    }
}

/// A node in our AST
#[derive(PartialEq, Eq, Debug, Clone, Serialize)]
pub struct Node {
    id: Id,
    kind: KindId,
    kind_name: &'static str,
    fields: BTreeMap<FieldId, Vec<Id>>,
    content: NodeContent,
    is_named: bool,
    is_missing: bool,
    is_extra: bool,
    is_error: bool,
}

impl Node {
    pub fn id(&self) -> Id {
        self.id
    }

    pub fn kind(&self) -> &'static str {
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

    pub fn start_position(&self) -> tree_sitter::Point {
        match self.content {
            NodeContent::Range(range) => range.start_point,
            _ => todo!(),
        }
    }

    pub fn end_position(&self) -> tree_sitter::Point {
        match self.content {
            NodeContent::Range(range) => range.end_point,
            _ => todo!(),
        }
    }

    pub fn start_byte(&self) -> usize {
        match self.content {
            NodeContent::Range(range) => range.start_byte,
            _ => todo!(),
        }
    }

    pub fn end_byte(&self) -> usize {
        match self.content {
            NodeContent::Range(range) => range.end_byte,
            _ => todo!(),
        }
    }

    pub fn byte_range(&self) -> std::ops::Range<usize> {
        self.start_byte()..self.end_byte()
    }
}

/// The contents of a node is either a range in the original source file,
/// or a new string if the node is synthesized.
#[derive(PartialEq, Eq, Debug, Clone, Serialize)]
enum NodeContent {
    Range(#[serde(with = "range::Range")] tree_sitter::Range),
    String(&'static str),
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

pub struct Rule {
    query: QueryNode,
    transform: Box<dyn Fn(&mut Ast, Captures) -> Id>,
}

impl Rule {
    pub fn new(query: QueryNode, transform: Box<dyn Fn(&mut Ast, Captures) -> Id>) -> Self {
        Self {
            query: query,
            transform: transform,
        }
    }

    fn tryRule(&self, ast: &mut Ast, node: Id) -> Option<Id> {
        let mut captures = Captures::new();
        if self.query.do_match(ast, node, &mut captures).unwrap() {
            Some((self.transform)(ast, captures))
        } else {
            None
        }
    }
}

fn applyRules(rules: &Vec<Rule>, ast: &mut Ast, id: Id) -> Id {
    let mut transformedId = id;
    // apply the transformation rules on this node until fixpoint
    loop {
        let mut newTransformedId = transformedId;
        for rule in rules {
            newTransformedId = match rule.tryRule(ast, newTransformedId) {
                Some(resultNode) => resultNode,
                None => newTransformedId,
            }
        }

        if newTransformedId == transformedId {
            break;
        } else {
            transformedId = newTransformedId
        }
    }

    // copy the current node
    let mut node = ast.nodes[transformedId].clone();

    // recursively descend into all the fields
    for (_, vec) in &mut node.fields {
        for v in vec {
            *v = applyRules(rules, ast, *v)
        }
    }

    node.id = ast.nodes.len();
    ast.nodes.push(node);
    return ast.nodes.len() - 1;
}

pub struct Runner {
    language: tree_sitter::Language,
    rules: Vec<Rule>,
}

impl Runner {
    pub fn new(language: tree_sitter::Language, rules: Vec<Rule>) -> Self {
        Self { language, rules }
    }

    pub fn run(&self, input: &str) -> Ast {
        // Parse the input into an AST

        let mut parser = tree_sitter::Parser::new();
        parser.set_language(self.language).unwrap();
        let tree = parser.parse(input, None).unwrap();
        let mut ast = Ast::from_tree(self.language, &tree);
        let res = applyRules(&self.rules, &mut ast, 0);
        ast.set_root(res);
        ast
    }
}

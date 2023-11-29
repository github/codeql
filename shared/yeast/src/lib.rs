// Uncomment to debug macros
//#![feature(trace_macros)]

use std::collections::BTreeMap;

pub mod captures;
pub mod query;
pub mod tree_builder;

use captures::Captures;
use query::QueryNode;
use serde::Serialize;
use serde_json::{json, Value};

pub mod print;
mod range;
mod visitor;

/// Node ids are indexes into the arena
type Id = usize;

/// Field and Kind ids are provided by tree-sitter
type FieldId = u16;
type KindId = u16;

pub const CHILD_FIELD: u16 = u16::MAX;
const CHILD_FIELD_NAME: &str = "child";

#[derive(Debug)]
pub struct Cursor<'a> {
    ast: &'a Ast,
    parents: Vec<Id>,
    node: &'a Node,
    locations: Vec<(usize, usize)>,
}

impl<'a> Cursor<'a> {
    pub fn new(ast: &'a Ast) -> Self {
        let node = ast.get_node(0).unwrap();
        Self {
            ast,
            parents: vec![],
            node,
            locations: vec![],
        }
    }

    pub fn node(&mut self) -> &'a Node {
        self.node
    }
    pub fn field_id(&self) -> Option<FieldId> {
        let parent_id = self.parents.last()?;
        let (field_index, _) = self.locations.last().unwrap();
        let (field_id, _) = self
            .ast
            .get_node(*parent_id)
            .unwrap()
            .fields
            .iter()
            .nth(*field_index)?;
        Some(*field_id)
    }
    pub fn goto_first_child(&mut self) -> bool {
        let location = (0, 0);
        let parent = self.node.id;
        self.node = match self.node.fields.iter().next() {
            Some((_field_id, child_ids)) if !child_ids.is_empty() => {
                self.ast.get_node(child_ids[0]).unwrap()
            }
            _ => return false,
        };
        self.locations.push(location);
        self.parents.push(parent);
        true
    }
    pub fn goto_next_sibling(&mut self) -> bool {
        let (node_id, location) = match self.parents.last() {
            None => {
                return false;
            }
            Some(parent) => {
                let parent = self.ast.get_node(*parent).unwrap();
                let (field_index, child_index) = self.locations.pop().unwrap();
                if field_index == parent.fields.len() {
                    return false;
                } else {
                    let (_field_id, children) = parent.fields.iter().nth(field_index).unwrap();
                    if child_index == children.len() - 1 {
                        // end of field
                        let location = (field_index + 1, 0);
                        let node_id = match parent.fields.iter().nth(field_index + 1) {
                            Some((_field_id, children)) => children[0],
                            None => return false,
                        };
                        (node_id, location)
                    } else {
                        let loc = (field_index, child_index + 1);
                        let (_, children) = parent.fields.iter().nth(field_index).unwrap();
                        let node_id = children[child_index + 1];
                        (node_id, loc)
                    }
                }
            }
        };
        self.locations.push(location);
        self.node = self.ast.get_node(node_id).unwrap();
        true
    }
    pub fn goto_parent(&mut self) -> bool {
        match self.parents.pop() {
            None => false,
            Some(parent) => {
                self.node = self.ast.get_node(parent).unwrap();
                true
            }
        }
    }
}

/// Our AST
#[derive(PartialEq, Eq, Debug)]
pub struct Ast {
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

    pub fn nodes(&self) -> &[Node] {
        &self.nodes
    }

    pub fn get_node(&self, id: Id) -> Option<&Node> {
        self.nodes.get(id)
    }

    pub fn print(&self, source: &str, rootId: Id) -> Value {
        let root = &self.nodes()[rootId];
        serde_json::to_value(self.print_node(root, source)).unwrap()
    }

    fn create_node(
        &mut self,
        kind: KindId,
        content: NodeContent,
        mut fields: BTreeMap<FieldId, Vec<Id>>,
        children: Vec<Id>,
    ) -> Id {
        let id = self.nodes.len();
        fields.insert(CHILD_FIELD, children);
        self.nodes.push(Node {
            id,
            kind,
            fields,
            content,
        });
        id
    }

    fn field_name_for_id(&self, id: FieldId) -> Option<&str> {
        if id == CHILD_FIELD {
            Some(CHILD_FIELD_NAME)
        } else {
            self.language.field_name_for_id(id)
        }
    }

    /// Print a node for debugging
    fn print_node(&self, node: &Node, source: &str) -> Value {
        let children: Vec<Value> = node
            .fields
            .get(&CHILD_FIELD)
            .unwrap_or(&vec![])
            .iter()
            .map(|id| self.print_node(self.get_node(*id).unwrap(), source))
            .collect();
        let mut fields = BTreeMap::new();
        if !children.is_empty() {
            fields.insert("rest", children);
        }
        for (field_id, nodes) in &node.fields {
            if field_id == &CHILD_FIELD {
                continue;
            }
            let field_name = self.field_name_for_id(*field_id).unwrap();
            let nodes: Vec<Value> = nodes
                .iter()
                .map(|id| self.print_node(self.get_node(*id).unwrap(), source))
                .collect();
            fields.insert(field_name, nodes);
        }
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
            language,
            nodes: vec![
                // assignment
                Node {
                    id: 0,
                    kind: 276,
                    fields: {
                        let mut map = BTreeMap::new();
                        map.insert(18, vec![1]);
                        map.insert(28, vec![3]);
                        map
                    },
                    content: NodeContent::String("x = 1"),
                },
                // identifier
                Node {
                    id: 1,
                    kind: 1,
                    fields: BTreeMap::new(),
                    content: NodeContent::String("x"),
                },
                // "="
                Node {
                    id: 2,
                    kind: 17,
                    fields: BTreeMap::new(),
                    content: NodeContent::String("="),
                },
                // integer
                Node {
                    id: 3,
                    kind: 110,
                    fields: BTreeMap::new(),
                    content: NodeContent::String("1"),
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
    fields: BTreeMap<FieldId, Vec<Id>>,
    content: NodeContent,
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

    // recursively descend into all the non-field children
    for child in &mut node.children {
        *child = applyRules(rules, ast, *child)
    }

    node.id = ast.nodes.len() - 1;
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

    pub fn run(&self, input: &str) -> (Ast, Id) {
        // Parse the input into an AST

        let mut parser = tree_sitter::Parser::new();
        parser.set_language(self.language).unwrap();
        let tree = parser.parse(input, None).unwrap();
        let mut ast = Ast::from_tree(self.language, &tree);
        let res = applyRules(&self.rules, &mut ast, 0);
        (ast, res)
    }
}

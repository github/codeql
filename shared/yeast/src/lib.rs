use std::collections::BTreeMap;

use serde::Serialize;

mod visitor;

/// Node ids are indexes into the arena
type Id = usize;

/// Field and Kind ids are provided by tree-sitter
type FieldId = u16;
type KindId = u16;

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

    /// Return an example AST, for testing and to fill implementation gaps
    pub fn example(language: tree_sitter::Language) -> Self {
        // x = 1
        Self {
            language: language,
            nodes: vec![
                // assignment
                Node {
                    id: 0,
                    kind: 276,
                    children: vec![2],
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
                    children: vec![],
                    fields: BTreeMap::new(),
                    content: NodeContent::String("x"),
                },
                // "="
                Node {
                    id: 2,
                    kind: 17,
                    children: vec![],
                    fields: BTreeMap::new(),
                    content: NodeContent::String("="),
                },
                // integer
                Node {
                    id: 3,
                    kind: 110,
                    children: vec![],
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
    children: Vec<Id>,
    fields: BTreeMap<FieldId, Vec<Id>>,
    #[serde(skip_serializing)]
    content: NodeContent,
}

/// The contents of a node is either a range in the original source file,
/// or a new string if the node is synthesized.
#[derive(PartialEq, Eq, Debug, Clone)]
enum NodeContent {
    Range(tree_sitter::Range),
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

pub struct Query {}
impl Query {
    pub fn new() -> Self {
        Self {}
    }
}

pub struct Rule {}
impl Rule {
    pub fn new(query: Query, transform: impl Fn(Match) -> Ast) -> Self {
        Self {}
    }
}

pub struct Match {}

pub struct Runner {
    language: tree_sitter::Language,
}

impl Runner {
    pub fn new(language: tree_sitter::Language, rules: Vec<Rule>) -> Self {
        Self { language }
    }

    pub fn run(&self, input: &str) -> Ast {
        // Parse the input into an AST

        let mut parser = tree_sitter::Parser::new();
        parser.set_language(self.language).unwrap();
        let tree = parser.parse(input, None).unwrap();
        let ast = Ast::from_tree(self.language, &tree);
        ast
    }
}

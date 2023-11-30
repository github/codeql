use std::collections::BTreeMap;
use tree_sitter::{Language, Tree};

use crate::{Ast, Id, Node, NodeContent, CHILD_FIELD};

#[derive(Debug)]
struct VisitorNode {
    inner: Node,
    parent: Option<Id>,
}

/// A type that can walk a TS tree and produce an `Ast`.
#[derive(Debug)]
pub(crate) struct Visitor {
    nodes: Vec<VisitorNode>,
    current: Option<Id>,
    language: Language,
}

impl Visitor {
    pub fn new(language: Language) -> Self {
        Self {
            nodes: Vec::new(),
            current: None,
            language,
        }
    }

    pub fn visit(&mut self, tree: &Tree) {
        let cursor = &mut tree.walk();
        self.enter_node(cursor.node());
        let mut recurse = true;
        loop {
            if recurse && cursor.goto_first_child() {
                recurse = self.enter_node(cursor.node());
            } else {
                self.leave_node(cursor.field_name(), cursor.node());

                if cursor.goto_next_sibling() {
                    recurse = self.enter_node(cursor.node());
                } else if cursor.goto_parent() {
                    recurse = false;
                } else {
                    break;
                }
            }
        }
    }

    pub fn build(self) -> Ast {
        Ast {
            language: self.language,
            nodes: self.nodes.into_iter().map(|n| n.inner).collect(),
        }
    }

    fn add_node(&mut self, n: tree_sitter::Node<'_>, content: NodeContent, is_named: bool) -> Id {
        let id = self.nodes.len();
        self.nodes.push(VisitorNode {
            inner: Node {
                id,
                kind: self.language.id_for_node_kind(n.kind(), is_named),
                kind_name: n.kind(),
                content,
                fields: BTreeMap::new(),
                is_missing: n.is_missing(),
                is_named: n.is_named(),
                is_extra: n.is_extra(),
                is_error: n.is_error(),
            },
            parent: self.current,
        });
        id
    }

    fn enter_node(&mut self, node: tree_sitter::Node<'_>) -> bool {
        let id = self.add_node(node, node.range().into(), node.is_named());
        self.current = Some(id);
        true
    }

    fn leave_node(&mut self, field_name: Option<&'static str>, _node: tree_sitter::Node<'_>) {
        let node = self.current.map(|i| &self.nodes[i]).unwrap();
        let node_id = node.inner.id;
        let node_parent = node.parent;

        if let Some(parent_id) = node.parent {
            let parent = self.nodes.get_mut(parent_id).unwrap();
            if let Some(field) = field_name {
                let field_id = self.language.field_id_for_name(field).unwrap();
                parent
                    .inner
                    .fields
                    .entry(field_id)
                    .or_default()
                    .push(node_id);
            } else {
                parent
                    .inner
                    .fields
                    .entry(CHILD_FIELD)
                    .or_default()
                    .push(node_id);
            }
        }

        self.current = node_parent;
    }
}

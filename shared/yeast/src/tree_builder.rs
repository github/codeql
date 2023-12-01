use crate::{captures::Captures, Ast, Id};
use std::collections::BTreeSet;

#[derive(Debug, Clone)]
pub enum TreeBuilder {
    Node {
        kind: &'static str,
        children: Vec<(&'static str, Vec<TreeChildBuilder>)>,
    },
    Capture {
        capture: &'static str,
    },
}

#[derive(Debug, Clone)]
pub enum TreeChildBuilder {
    Repeated {
        child: TreeBuilder,
    },
    SingleNode(TreeBuilder),
}

impl TreeChildBuilder {
    fn get_opt_contained(&self) -> BTreeSet<&'static str> {
        match self {
            TreeChildBuilder::Repeated { child } => child.get_opt_contained(),
            TreeChildBuilder::SingleNode(node) => node.get_opt_contained(),
        }
    }

    fn build_tree(
        &self,
        target: &mut Ast,
        vars: &Captures,
        child_ids: &mut Vec<Id>,
    ) -> Result<(), String> {
        match self {
            TreeChildBuilder::Repeated { child } => {
                let repeated_ids = self.get_opt_contained();

                for sub_captures in vars.un_star(&repeated_ids)? {
                    child_ids.push(child.build_tree(target, &sub_captures)?)
                }
                Ok(())
            }
            TreeChildBuilder::SingleNode(node) => {
                child_ids.push(node.build_tree(target, vars)?);
                Ok(())
            }
        }
    }
}

impl TreeBuilder {
    fn get_opt_contained(&self) -> BTreeSet<&'static str> {
        match self {
            TreeBuilder::Node { kind: _, children } => {
                let mut contained = BTreeSet::new();
                for (_, children) in children {
                    for child in children {
                        contained.extend(child.get_opt_contained());
                    }
                }
                contained
            }
            TreeBuilder::Capture { capture } => {
                let mut contained = BTreeSet::new();
                contained.insert(*capture);
                contained
            }
        }
    }

    pub fn build_tree(&self, target: &mut Ast, vars: &Captures) -> Result<Id, String> {
        match self {
            TreeBuilder::Capture { capture } => vars.get_var(capture),
            TreeBuilder::Node { kind, children } => {
                let ast_kind = target.id_for_node_kind(kind).ok_or_else(||
                    format!("Node kind {} does not exist in language", kind)
                )?;

                let child_vars = children.iter().map(|(field, children)| {
                    let mut child_ids = Vec::new();
                    for child in children {
                        child.build_tree(target, vars, &mut child_ids)?;
                    }
                    let field_id = target
                        .field_id_for_name(field)
                        .ok_or(format!("Field {} does not exist in language", field))?;
                    Ok((field_id, child_ids))
                }).collect::<Result<_,String>>()?;
                Ok(target.create_node(ast_kind, "".into(), child_vars, true))
            }
        }
    }
}

#[macro_export]
macro_rules! tree_builder {
    (($($child:tt)*)) => { tree_builder!($($child)*)};
    // Match a node of a given kind
    ($node_id:ident $($rest:tt)*) => { $crate::tree_builder::TreeBuilder::Node{ kind: stringify!($node_id), children: tree_builder_fields!($($rest)*)}};
    // Capture only (implicit _)
    (@ $capture_id:ident) => { $crate::tree_builder::TreeBuilder::Capture{ capture: stringify!($capture_id)}};
}

// We use an accumulator to build up the list of children incrementally so this starts the tail recursion
#[macro_export]
macro_rules! tree_builder_child {
    () => { Vec::new()};
    ($($rest:tt)*) => { _tree_builder_child!( @ACC [] $($rest)* )};
}

#[macro_export]
macro_rules! _tree_builder_child {
    // vec! allows a trailing comma so we assume that either the accumulator is empty or`ends in a comma

    // Base case: no more tokens, so return the accumulator
    (@ACC [$($acc:tt)*]) => { vec![$($acc)*]};
    // Parse field* : node
    (@ACC [$($acc:tt)*] $field_name:ident * : ($($sub_node:tt)*) $($rest:tt)*) => {  _tree_builder_child!( @ACC [ $($acc)* $crate::tree_builder::TreeChildBuilder::Field{field_name: stringify!($field_name), node: tree_builder_child!($($sub_node)*)},] $($rest)*)};
    // Parse field : node
    (@ACC [$($acc:tt)*] $field_name:ident : $sub_node:tt $($rest:tt)*) => {  _tree_builder_child!( @ACC [ $($acc)* $crate::tree_builder::TreeChildBuilder::Field{field_name: stringify!($field_name), node: vec![$crate::tree_builder::TreeChildBuilder::SingleNode(tree_builder!($sub_node))]},] $($rest)*)};

    // Parse (node)*
    (@ACC [$($acc:tt)*] $sub_node:tt * $($rest:tt)*) => {  _tree_builder_child!( @ACC [ $($acc)* $crate::tree_builder::TreeChildBuilder::Repeated{child: tree_builder!($sub_node)},] $($rest)*)};
    // Parse node (this must be last as it only applies if the earlier cases don't match)
    (@ACC [$($acc:tt)*] $sub_node:tt $($rest:tt)*) => { _tree_builder_child!( @ACC [ $($acc)* $crate::tree_builder::TreeChildBuilder::SingleNode(tree_builder!($sub_node)),] $($rest)*)};
}


#[macro_export]
macro_rules! _tree_builder_fields {
    // vec! allows a trailing comma so we assume that either the accumulator is empty or`ends in a comma

    // Base case: no more tokens, so return the accumulator
    (@ACC [$($acc:tt)*]) => { vec![$($acc)*]};
    // Parse field* : node
    (@ACC [$($acc:tt)*] $field_name:ident * : ($($sub_node:tt)*) $($rest:tt)*) => {  _tree_builder_fields!( @ACC [ $($acc)* (stringify!($field_name), tree_builder_child!($($sub_node)*)),] $($rest)*)};
    // Parse field : node
    (@ACC [$($acc:tt)*] $field_name:ident : $sub_node:tt $($rest:tt)*) => {  _tree_builder_fields!( @ACC [ $($acc)* (stringify!($field_name), vec![$crate::tree_builder::TreeChildBuilder::SingleNode(tree_builder!($sub_node))]),] $($rest)*)};
}
#[macro_export]
macro_rules! tree_builder_fields {
    ($($all:tt)*) => { _tree_builder_fields!( @ACC [] $($all)*)};
}

pub struct TreesBuilder {
    pub children: Vec<TreeChildBuilder>,
}

impl TreesBuilder {
    pub fn build_trees(&self, target: &mut Ast, vars: &Captures) -> Result<Vec<Id>, String> {
        let mut child_ids = Vec::new();
        for child in &self.children {
            child.build_tree(target, vars, &mut child_ids)?;
        }
        Ok(child_ids)
    }
}

#[macro_export]
macro_rules! trees_builder {
    () => { $crate::tree_builder::TreesBuilder { children: Vec::new()}};
    ($($rest:tt)*) => {$crate::tree_builder::TreesBuilder { children: _tree_builder_child!( @ACC [] $($rest)* )}};
}

pub use tree_builder;
pub use tree_builder_child;
pub use trees_builder;

use crate::{captures::Captures, Ast, FieldId, Id, NodeContent};
use std::collections::{BTreeMap, BTreeSet};

#[derive(Debug, Clone)]
pub enum TreeBuilder {
    Node {
        kind: &'static str,
        children: Vec<TreeChildBuilder>,
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
    Field {
        field_name: &'static str,
        node: Vec<TreeChildBuilder>,
    },
    SingleNode(TreeBuilder),
}

impl TreeChildBuilder {
    fn get_opt_contained(&self) -> BTreeSet<&'static str> {
        match self {
            TreeChildBuilder::Repeated { child } => child.get_opt_contained(),
            TreeChildBuilder::Field {
                field_name: _,
                node,
            } => {
                let mut contained = BTreeSet::new();
                for child in node {
                    contained.extend(child.get_opt_contained());
                }
                contained
            }
            TreeChildBuilder::SingleNode(node) => node.get_opt_contained(),
        }
    }

    fn build_tree(
        &self,
        target: &mut Ast,
        vars: &Captures,
        child_ids: &mut Vec<Id>,
        child_fields: &mut BTreeMap<FieldId, Vec<Id>>,
    ) -> Result<(), String> {
        match self {
            TreeChildBuilder::Repeated { child } => {
                let repeated_ids = self.get_opt_contained();

                for sub_captures in vars.un_star(&repeated_ids)? {
                    child_ids.push(child.build_tree(target, &sub_captures)?)
                }
                Ok(())
            }
            TreeChildBuilder::Field { field_name, node } => {
                let field_id = target
                    .language
                    .field_id_for_name(field_name)
                    .ok_or(format!("Field {} does not exist in language", field_name))?;
                if child_fields.contains_key(&field_id) {
                    return Err(format!("Field {} already exists", field_id));
                }
                let mut field_ids = Vec::new();
                // Reserve space for the field so conflicts are reported
                for child in node {
                    let mut sub_map: BTreeMap<_, _> = BTreeMap::new();
                    child.build_tree(target, vars, &mut field_ids, &mut sub_map)?;
                    if !sub_map.is_empty() {
                        return Err(format!("Fields cannot contain fields"));
                    }
                }
                child_fields.insert(field_id, field_ids);
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
                for child in children {
                    contained.extend(child.get_opt_contained());
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
                let mut child_ids = Vec::new();
                let mut child_vars = BTreeMap::new();
                let ast_kind = target.language.id_for_node_kind(kind, true);
                if ast_kind == 0 {
                    return Err(format!("Node kind {} does not exist in language", kind));
                }
                for child in children {
                    child.build_tree(target, vars, &mut child_ids, &mut child_vars)?;
                }
                Ok(target.create_node(
                    ast_kind,
                    NodeContent::String(""),
                    child_vars,
                    child_ids,
                    true,
                ))
            }
        }
    }
}

#[macro_export]
macro_rules! tree_builder {
    (($($child:tt)*)) => { tree_builder!($($child)*)};
    // Match a node of a given kind
    ($node_id:ident $($rest:tt)*) => { $crate::tree_builder::TreeBuilder::Node{ kind: stringify!($node_id), children: tree_builder_child!($($rest)*)}};
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

pub use tree_builder;
pub use tree_builder_child;

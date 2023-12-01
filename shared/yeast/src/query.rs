
use crate::{captures::Captures, Ast, Id};

#[derive(Debug, Clone)]
pub enum QueryNode {
    Any(),
    Node {
        kind: &'static str,
        children: Vec<(&'static str, Vec<QueryListElem>)>,
    },
    UnnamedNode {
        kind: &'static str,
    },
    Capture {
        capture: &'static str,
        node: Box<QueryNode>,
    },
}

#[derive(Debug, Clone)]
pub enum QueryListElem {
    Repeated { children: Vec<QueryListElem>, rep: Rep },
    SingleNode(QueryNode),
}

#[derive(Debug, PartialEq, Eq, Copy, Clone)]
pub enum Rep {
    ZeroOrMore,
    OneOrMore,
    ZeroOrOne,
}

impl QueryNode {
    pub fn do_match(&self, ast: &Ast, node: Id, matches: &mut Captures) -> Result<bool, String> {
        match self {
            QueryNode::Any() => Ok(true),
            QueryNode::Node { kind, children } => {
                let node = ast.get_node(node).unwrap();
                let target_kind = ast.id_for_node_kind(kind).ok_or_else(|| {
                    format!("Node kind {} not found in language", kind)
                })?;
                if node.kind != target_kind {
                    return Ok(false);
                }
                for (field, field_children) in children {
                    let field_id = ast
                        .field_id_for_name(field)
                        .ok_or_else(|| format!("Field {} not found in language", field))?;
                    let empty = Vec::new();
                    let mut child_iter = node
                        .fields
                        .get(&field_id)
                        .unwrap_or(&empty)
                        .iter()
                        .cloned();
                    if !match_children(field_children.iter(), ast, &mut child_iter, matches)? {
                        return Ok(false);
                    }
                }
                Ok(true)
            }
            QueryNode::UnnamedNode { kind } => {
                let node = ast.get_node(node).unwrap();
                let target_kind = ast.id_for_unnamed_node_kind(kind).ok_or_else(|| {
                    format!("unnamed Node kind {} not found in language", kind)
                })?;
                Ok(node.kind == target_kind)
            }
            QueryNode::Capture {
                capture,
                node: sub_query,
            } => {
                matches.insert(capture, node);
                sub_query.do_match(ast, node, matches)
            }
        }
    }
}

fn match_children<'a>(
    child_matchers: impl Iterator<Item = &'a QueryListElem>,
    ast: &Ast,
    remaining_children: &mut (impl Iterator<Item = Id> + Clone),
    matches: &mut Captures,
) -> Result<bool, String> {
    for child in child_matchers {
        if !child.do_match(ast, remaining_children, matches)? {
            return Ok(false);
        }
    }
    Ok(true)
}

impl QueryListElem {
    fn do_match(
        &self,
        ast: &Ast,
        remaining_children: &mut (impl Iterator<Item = Id> + Clone),
        matches: &mut Captures,
    ) -> Result<bool, String> {
        match self {
            QueryListElem::Repeated { children, rep } => {
                let mut iters = 0;

                loop {
                    let matches_initial = matches.clone();
                    let start = remaining_children.clone();
                    if !match_children(children.iter(), ast, remaining_children, matches)? {
                        // Reset the state
                        *remaining_children = start;
                        *matches = matches_initial;
                        break;
                    }
                    iters += 1;
                    if *rep == Rep::ZeroOrOne {
                        break;
                    }
                }
                if *rep == Rep::OneOrMore && iters == 0 {
                    // We didn't match any children but we were supposed to
                    Ok(false)
                } else {
                    Ok(true)
                }
            }
            QueryListElem::SingleNode(sub_query) => {
                if let Some(child) = remaining_children.next() {
                    sub_query.do_match(ast, child, matches)
                } else {
                    Ok(false)
                }
            }
        }
    }
}

#[macro_export]
macro_rules! query {
    // _
    (_) => { $crate::query::QueryNode::Any()};
    // Parens
    (($($child:tt)*)) => { query!($($child)*)};
    // Match a node of a given kind
    ($node_id:ident $($rest:tt)*) => { $crate::query::QueryNode::Node{ kind: stringify!($node_id), children: query_fields!($($rest)*)}};
    // Match an unamed node of a given kind (using a string literal)
    ($node_id:literal) => { $crate::query::QueryNode::UnnamedNode{ kind: $node_id}};
    // Capture
    ($child:tt @ $capture_id:ident) => { $crate::query::QueryNode::Capture{ capture: stringify!($capture_id), node: Box::new(query!($child))}};
    // Capture only (implicit _)
    (@ $capture_id:ident) => { $crate::query::QueryNode::Capture{ capture: stringify!($capture_id), node: Box::new($crate::query::QueryNode::Any())}};
}

// We use an accumulator to build up the list of children incrementally so this starts the tail recursion
#[macro_export]
macro_rules! query_list {
    ($($rest:tt)*) => { _query_list!( @ACC [] $($rest)* )};
}

#[macro_export]
macro_rules! query_fields {
    ($($rest:tt)*) => { _query_fields!( @ACC [] $($rest)* )};
}

#[macro_export]
macro_rules! _query_fields {
    // vec! allows a trailing comma so we assume that either the accumulator is empty or`ends in a comma

    // Base case: no more tokens, so return the accumulator
    (@ACC [$($acc:tt)*]) => { vec![$($acc)*]};
    // Parse field * : (nodeList)
    (@ACC [$($acc:tt)*] $field_name:ident * : ($($sub_node:tt)*) $($rest:tt)*) => {  _query_fields!( @ACC [ $($acc)* (stringify!($field_name), query_list!($($sub_node)*)),] $($rest)*)};
    // Parse field : node
    (@ACC [$($acc:tt)*] $field_name:ident : $sub_node:tt $($rest:tt)*) => {  _query_fields!( @ACC [ $($acc)* (stringify!($field_name), vec![$crate::query::QueryListElem::SingleNode(query!($sub_node))]),]  $($rest)* )};
}

#[macro_export]
macro_rules! _query_list {
    // vec! allows a trailing comma so we assume that either the accumulator is empty or`ends in a comma

    // Base case: no more tokens, so return the accumulator
    (@ACC [$($acc:tt)*]) => { vec![$($acc)*]};
    // Parse (nodeList)*
    (@ACC [$($acc:tt)*] ($($sub_node:tt)*) * $($rest:tt)*) => {  _query_list!( @ACC [ $($acc)* $crate::query::QueryListElem::Repeated{children: query_list!($($sub_node)*), rep: $crate::query::Rep::ZeroOrMore},] $($rest)*)};
    // Parse (nodeList)+
    (@ACC [$($acc:tt)*] ($($sub_node:tt)*) + $($rest:tt)*) => {  _query_list!( @ACC [ $($acc)* $crate::query::QueryListElem::Repeated{children: query_list!($($sub_node)*), rep: $crate::query::Rep::OneOrMore},] $($rest)*)};
    // Parse (nodeList)?
    (@ACC [$($acc:tt)*] ($($sub_node:tt)*) ? $($rest:tt)*) => {  _query_list!( @ACC [ $($acc)* $crate::query::QueryListElem::Repeated{children: query_list!($($sub_node)*), rep: $crate::query::Rep::ZeroOrOne},] $($rest)*)};
    // Parse node (treating @cap as a single node) 
    (@ACC [$($acc:tt)*] @ $sub_node:tt $($rest:tt)*) => { _query_list!( @ACC [ $($acc)* $crate::query::QueryListElem::SingleNode(query!(@$sub_node)),] $($rest)*)};
    // Parse node (this must be last as it only applies if the earlier cases don't match)
    (@ACC [$($acc:tt)*] $sub_node:tt $($rest:tt)*) => { _query_list!( @ACC [ $($acc)* $crate::query::QueryListElem::SingleNode(query!($sub_node)),] $($rest)*)};
}

pub use query;
pub use query_list;

#[cfg(test)]
mod tests {
    use crate::query::*;
    #[test]
    fn it_works() {
        let query1: QueryNode = query!(_);
        println!("{:?}", query1);
        let query2 = query!(foo);
        println!("{:?}", query2);
        let query3 = query!(foo child: (_));
        println!("{:?}", query3);
        let query4 = query!(foo child*:((_)*));
        println!("{:?}", query4);
        let query5: QueryNode = query!(foo child*:((_)*));
        println!("{:?}", query5);
        let query6: QueryNode = query!(_ @ bar);
        println!("{:?}", query6);
        let query7: QueryNode = query!(foo child:(_ @ bar));
        println!("{:?}", query7);
        let query7: QueryNode = query!(foo child:(@ bar));
        println!("{:?}", query7);
        let query8: QueryNode = query!((assignment
          left: (element_reference
            object: (@ obj)
            child: (_ @ index)
          )
          right: (_ @ rhs)
        ));
        println!("{:?}", query8);
        let query9: QueryNode = query!((assignment
          left: (element_reference
            object * : ((@ obj)*)
            child: (_ @ index)
          )
          right: (_ @ rhs)
        ));
        println!("{:?}", query9);
        let query10 = query!(
            program 
                child: (assignment
                    left: (@left)
                    right: (@right))
                
            );
        println!("{:?}", query10);
    }
}

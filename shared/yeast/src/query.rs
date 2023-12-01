use std::{collections::BTreeMap, iter::Peekable};

use crate::{captures::Captures, Ast, FieldId, Id, CHILD_FIELD};

#[derive(Debug, Clone)]
pub enum QueryNode {
    Any(),
    Node {
        kind: &'static str,
        children: Vec<QueryChildElem>,
    },
    Capture {
        capture: &'static str,
        node: Box<QueryNode>,
    },
}

#[derive(Debug, Clone)]
pub enum QueryChildElem {
    Repeated {
        child: QueryNode,
        rep: Rep,
    },
    Field {
        fieldName: &'static str,
        node: Vec<QueryChildElem>,
    },
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
                let target_kind = ast.language.id_for_node_kind(kind, true);
                if node.kind != target_kind {
                    return Ok(false);
                }
                let mut child_iter = node
                    .fields
                    .get(&CHILD_FIELD)
                    .unwrap() // assume CHILD_FIELD is always set
                    .iter()
                    .cloned()
                    .peekable();

                for child in children {
                    if !child.do_match(ast, &mut child_iter, &node.fields, matches)? {
                        return Ok(false);
                    }
                }
                Ok(true)
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

impl QueryChildElem {
    fn do_match(
        &self,
        ast: &Ast,
        remaining_children: &mut Peekable<impl Iterator<Item = Id>>,
        fields: &BTreeMap<FieldId, Vec<Id>>,
        matches: &mut Captures,
    ) -> Result<bool, String> {
        match self {
            QueryChildElem::Repeated { child, rep } => {
                let mut iters = 0;
                while let Some(child_node) = remaining_children.peek() {
                    let mut matches_temp = Captures::new();
                    if !child.do_match(ast, *child_node, &mut matches_temp)? {
                        break;
                    }
                    remaining_children.next();
                    iters += 1;
                    matches.merge(&matches_temp);
                    if *rep == Rep::ZeroOrOne {
                        break;
                    }
                }
                if *rep == Rep::OneOrMore && iters == 0 {
                    Ok(false)
                } else {
                    Ok(true)
                }
            }
            QueryChildElem::Field {
                fieldName,
                node: sub_queries,
            } => {
                let field = ast
                    .language
                    .field_id_for_name(fieldName)
                    .ok_or_else(|| format!("Field {} is not in the language", fieldName))?;
                if let Some(field_children) = fields.get(&field) {
                    let mut remaining_children = field_children.iter().copied().peekable();
                    for child in sub_queries {
                        if !child.do_match(
                            ast,
                            &mut remaining_children,
                            &BTreeMap::new(),
                            matches,
                        )? {
                            return Ok(false);
                        }
                    }
                    Ok(true)
                } else {
                    Ok(false)
                }
            }
            QueryChildElem::SingleNode(sub_query) => {
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
    ($node_id:ident $($rest:tt)*) => { $crate::query::QueryNode::Node{ kind: stringify!($node_id), children: query_list!($($rest)*)}};
    // Capture
    ($child:tt @ $capture_id:ident) => { $crate::query::QueryNode::Capture{ capture: stringify!($capture_id), node: Box::new(query!($child))}};
    // Capture only (implicit _)
    (@ $capture_id:ident) => { $crate::query::QueryNode::Capture{ capture: stringify!($capture_id), node: Box::new($crate::query::QueryNode::Any())}};
}

// We use an accumulator to build up the list of children incrementally so this starts the tail recursion
#[macro_export]
macro_rules! query_list {
    () => { Vec::new()};
    ($($rest:tt)*) => { _query_list!( @ACC [] $($rest)* )};
}

#[macro_export]
macro_rules! _query_list {
    // vec! allows a trailing comma so we assume that either the accumulator is empty or`ends in a comma

    // Base case: no more tokens, so return the accumulator
    (@ACC [$($acc:tt)*]) => { vec![$($acc)*]};
    // Parse field : (nodeList)
    (@ACC [$($acc:tt)*] $field_name:ident * : ($($sub_node:tt)*) $($rest:tt)*) => {  _query_list!( @ACC [ $($acc)* QueryChildElem::Field{fieldName: stringify!($field_name), node: query_list!($($sub_node)*)},] $($rest)*)};
    // Parse field : node
    (@ACC [$($acc:tt)*] $field_name:ident : $sub_node:tt $($rest:tt)*) => {  _query_list!( @ACC [ $($acc)* $crate::query::QueryChildElem::Field{fieldName: stringify!($field_name), node: vec![$crate::query::QueryChildElem::SingleNode(query!($sub_node))]},] $($rest)*)};
    // Parse (node)*
    (@ACC [$($acc:tt)*] $sub_node:tt * $($rest:tt)*) => {  _query_list!( @ACC [ $($acc)* $crate::query::QueryChildElem::Repeated{child: query!($sub_node), rep: $crate::query::Rep::ZeroOrMore},] $($rest)*)};
    // Parse (node)+
    (@ACC [$($acc:tt)*] $sub_node:tt + $($rest:tt)*) => {  _query_list!( @ACC [ $($acc)* $crate::query::QueryChildElem::Repeated{child: query!($sub_node), rep: $crate::query::Rep::OneOrMore},] $($rest)*)};
    // Parse (node)?
    (@ACC [$($acc:tt)*] $sub_node:tt ? $($rest:tt)*) => {  _query_list!( @ACC [ $($acc)* $crate::query::QueryChildElem::Repeated{child: query!($sub_node), rep: $crate::query::Rep::ZeroOrOne},] $($rest)*)};
    // Parse node (this must be last as it only applies if the earlier cases don't match)
    (@ACC [$($acc:tt)*] $sub_node:tt $($rest:tt)*) => { _query_list!( @ACC [ $($acc)* $crate::query::QueryChildElem::SingleNode(query!($sub_node)),] $($rest)*)};
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
        let query3 = query!(foo(_));
        println!("{:?}", query3);
        let query4 = query!(foo (_)*);
        println!("{:?}", query4);
        let query5: QueryNode = query!(foo (_)*);
        println!("{:?}", query5);
        let query6: QueryNode = query!(_ @ bar);
        println!("{:?}", query6);
        let query7: QueryNode = query!(foo (_ @ bar));
        println!("{:?}", query7);
        let query7: QueryNode = query!(foo (@ bar));
        println!("{:?}", query7);
        let query8: QueryNode = query!((assignment
          left: (element_reference
            object: (@ obj)
            (_ @ index)
          )
          right: (_ @ rhs)
        ));
        println!("{:?}", query8);
        let query9: QueryNode = query!((assignment
          left: (element_reference
            object * : ((@ obj)*)
            (_ @ index)
          )
          right: (_ @ rhs)
        ));
        println!("{:?}", query9);
        let query10 = query!(
            program (
                (assignment
                    left: (@left)
                    right: (@right)
                )
            )
        );
        println!("{:?}", query10);
    }
}

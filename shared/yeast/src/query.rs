// Uncomment to debug macros
/// trace_macros!(true);
use std::{collections::HashMap, iter::Peekable};

#[derive(Debug, Clone)]
pub enum QueryNode {
    Any(),
    Node {
        kind: &'static str,
        children: Vec<QueryList>,
    },
    Capture {
        capture: &'static str,
        node: Box<QueryNode>,
    },
}

#[derive(Debug, Clone)]
pub enum QueryList {
    Repeated { child: QueryNode, rep: Rep },
    Field { fieldName: String, node: QueryNode },
    SingleNode(QueryNode),
}

#[derive(Debug, Clone)]
pub enum Rep {
    ZeroOrMore,
    OneOrMore,
    ZeroOrOne,
}

macro_rules! query {
    // _
    (_) => { QueryNode::Any()};
    // Parens
    (($($child:tt)*)) => { query!($($child)*)};
    // Match a node of a given kind
    ($node_id:ident $($rest:tt)*) => { QueryNode::Node{ kind: stringify!($node_id), children: query_list!($($rest)*)}};
    // Capture
    ($child:tt @ $capture_id:ident) => { QueryNode::Capture{ capture: stringify!($capture_id), node: Box::new(query!($child))}};
    // Capture only (implicit _)
    (@ $capture_id:ident) => { QueryNode::Capture{ capture: stringify!($capture_id), node: Box::new(QueryNode::Any())}};
}

// We use an accumulator to build up the list of children incrementally so this starts the tail recursion
macro_rules! query_list {
    () => { Vec::new()};
    ($($rest:tt)*) => { _query_list!( @ACC [] $($rest)* )};
}

macro_rules! _query_list {
    // vec! allows a trailing comma so we assume that either the accumulator is empty or`ends in a comma

    // Base case: no more tokens, so return the accumulator
    (@ACC [$($acc:tt)*]) => { vec![$($acc)*]};
    // Parse (node)*
    (@ACC [$($acc:tt)*] $sub_node:tt * $($rest:tt)*) => {  _query_list!( @ACC [ $($acc)* QueryList::Repeated{child: query!($sub_node), rep: Rep::ZeroOrMore},] $($rest)*)};
    // Parse (node)+
    (@ACC [$($acc:tt)*] $sub_node:tt + $($rest:tt)*) => {  _query_list!( @ACC [ $($acc)* QueryList::Repeated{child: query!($sub_node), rep: Rep::OneOrMore},] $($rest)*)};
    // Parse (node)?
    (@ACC [$($acc:tt)*] $sub_node:tt ? $($rest:tt)*) => {  _query_list!( @ACC [ $($acc)* QueryList::Repeated{child: query!($sub_node), rep: Rep::ZeroOrOne},] $($rest)*)};
    // Parse field : node
    (@ACC [$($acc:tt)*] $field_name:ident : $sub_node:tt $($rest:tt)*) => {  _query_list!( @ACC [ $($acc)* QueryList::Field{fieldName: stringify!($field_name).to_string(), node: query!($sub_node)},] $($rest)*)};
    // Parse node (this must be last as it only applies if the earlier cases don't match)
    (@ACC [$($acc:tt)*] $sub_node:tt $($rest:tt)*) => { _query_list!( @ACC [ $($acc)* QueryList::SingleNode(query!($sub_node)),] $($rest)*)};
}

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
        let query7: QueryNode = query!((assignment
          left: (element_reference
            object: (@ obj)
            (_ @ index)
          )
          right: (_ @ rhs)
        ));
        println!("{:?}", query7);
    }
}

use crate::{captures::Captures, Ast, Id};

#[derive(Debug, Clone)]
pub enum QueryNode {
    /// A wildcard. With `match_unnamed = false` (the default for `(_)`),
    /// only matches named nodes when used positionally — unnamed children
    /// are skipped over. With `match_unnamed = true` (for bare `_`), the
    /// wildcard consumes whatever the next child is, named or unnamed.
    Any {
        match_unnamed: bool,
    },
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

impl QueryNode {
    /// Returns the root node kind this query matches, if it's specific.
    /// Returns None for wildcards (Any) and captures wrapping wildcards.
    pub fn root_kind(&self) -> Option<&'static str> {
        match self {
            QueryNode::Node { kind, .. } => Some(kind),
            QueryNode::UnnamedNode { kind } => Some(kind),
            QueryNode::Capture { node, .. } => node.root_kind(),
            QueryNode::Any { .. } => None,
        }
    }
}

#[derive(Debug, Clone)]
pub enum QueryListElem {
    Repeated {
        children: Vec<QueryListElem>,
        rep: Rep,
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
    /// Returns true if this query only matches named nodes (not unnamed tokens).
    /// Used to skip unnamed children in positional matching, matching tree-sitter
    /// semantics where `(_)` only matches named nodes.
    fn matches_named_only(&self) -> bool {
        match self {
            QueryNode::Any { match_unnamed } => !match_unnamed,
            QueryNode::Node { .. } => true,
            QueryNode::UnnamedNode { .. } => false,
            QueryNode::Capture { node, .. } => node.matches_named_only(),
        }
    }

    pub fn do_match(&self, ast: &Ast, node: Id, matches: &mut Captures) -> Result<bool, String> {
        match self {
            QueryNode::Any { .. } => Ok(true),
            QueryNode::Node { kind, children } => {
                let node = ast.get_node(node).unwrap();
                let target_kind = ast
                    .id_for_node_kind(kind)
                    .ok_or_else(|| format!("Node kind {kind} not found in language"))?;
                if node.kind != target_kind {
                    return Ok(false);
                }
                for (field, field_children) in children {
                    let field_id = ast
                        .field_id_for_name(field)
                        .ok_or_else(|| format!("Field {field} not found in language"))?;
                    let empty = Vec::new();
                    let mut child_iter =
                        node.fields.get(&field_id).unwrap_or(&empty).iter().cloned();
                    if !match_children(field_children.iter(), ast, &mut child_iter, matches)? {
                        return Ok(false);
                    }
                }
                Ok(true)
            }
            QueryNode::UnnamedNode { kind } => {
                let node = ast.get_node(node).unwrap();
                let target_kind = ast
                    .id_for_unnamed_node_kind(kind)
                    .ok_or_else(|| format!("unnamed Node kind {kind} not found in language"))?;
                Ok(node.kind == target_kind)
            }
            QueryNode::Capture {
                capture,
                node: sub_query,
            } => {
                let matched = sub_query.do_match(ast, node, matches)?;
                if matched {
                    matches.insert(capture, node);
                }
                Ok(matched)
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
                if children.is_empty() {
                    // Empty repetition always succeeds without consuming
                    return Ok(*rep != Rep::OneOrMore);
                }

                let mut iters = 0;

                loop {
                    let matches_initial = matches.clone();
                    let start = remaining_children.clone();
                    let start_next = start.clone().next();
                    if !match_children(children.iter(), ast, remaining_children, matches)? {
                        *remaining_children = start;
                        *matches = matches_initial;
                        break;
                    }
                    // Guard against zero-width matches: if the iterator
                    // didn't advance, break to avoid infinite looping.
                    let current_next = remaining_children.clone().next();
                    if start_next == current_next {
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
                // Forward-scan semantics: advance through the iterator until
                // we find a child that matches `sub_query`. Skip ahead past
                // unnamed children when the sub-query is named-only (so they
                // can never match anyway). On a match attempt that fails,
                // restore the captures so partial captures from a complex
                // sub-query don't leak.
                let skip_unnamed = sub_query.matches_named_only();
                loop {
                    let Some(child) = remaining_children.next() else {
                        return Ok(false);
                    };
                    let node = ast.get_node(child).unwrap();
                    // Skip tree-sitter `extras` (e.g. comments) during
                    // positional matching: they are conceptually invisible
                    // between siblings, mirroring tree-sitter query semantics.
                    if node.is_extra() {
                        continue;
                    }
                    if skip_unnamed && !node.is_named() {
                        continue;
                    }
                    let snapshot = matches.clone();
                    if sub_query.do_match(ast, child, matches)? {
                        return Ok(true);
                    }
                    *matches = snapshot;
                }
            }
        }
    }
}

#[cfg(test)]
mod tests {
    use crate::query::*;
    #[test]
    fn it_works() {
        let query1: QueryNode = yeast::query!((_));
        println!("{query1:?}");
        let query2 = yeast::query!((foo));
        println!("{query2:?}");
        let query3 = yeast::query!((foo child: (_)));
        println!("{query3:?}");
        let query4 = yeast::query!((foo (_)*));
        println!("{query4:?}");
        let query5: QueryNode = yeast::query!((foo (_)*));
        println!("{query5:?}");
        let query6: QueryNode = yeast::query!((_) @bar);
        println!("{query6:?}");
        let query7: QueryNode = yeast::query!((foo child: (_) @bar));
        println!("{query7:?}");
        let query8: QueryNode = yeast::query!(
            (assignment
                left: (element_reference
                    object: (_) @obj
                    (_) @index
                )
                right: (_) @rhs
            )
        );
        println!("{query8:?}");
        let query9 = yeast::query!(
            (program
                child: (assignment
                    left: (_) @left
                    right: (_) @right
                )
            )
        );
        println!("{query9:?}");
    }
}

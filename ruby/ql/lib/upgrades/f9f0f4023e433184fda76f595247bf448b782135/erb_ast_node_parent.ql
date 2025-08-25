class AstNode extends @erb_ast_node {
  string toString() { none() }
}

from AstNode n, int i, AstNode parent
where erb_ast_node_info(n, parent, i, _)
select n, parent, i

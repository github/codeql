class AstNode extends @ruby_ast_node {
  string toString() { none() }
}

from AstNode node, AstNode body
where
  ruby_method_def(node, _) and
  (
    ruby_ast_node_info(body, node, _, _) and
    ruby_tokeninfo(body, _, "end") and
    ruby_method_child(node, _, _)
    or
    ruby_method_child(node, 0, body) and
    not exists(AstNode n |
      ruby_ast_node_info(n, node, _, _) and
      ruby_tokeninfo(n, _, "end")
    )
  )
// TODO : handle end-less methods
select node, body

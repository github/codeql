class AstNode extends @ruby_ast_node {
  string toString() { none() }
}

from AstNode node, AstNode body
where
  ruby_singleton_method_def(node, _, _) and
  ruby_ast_node_info(body, node, _, _) and
  ruby_tokeninfo(body, _, "end") and
  ruby_singleton_method_child(node, _, _)
  or
  ruby_singleton_method_child(node, 0, body) and
  not exists(AstNode n |
    ruby_ast_node_info(n, node, _, _) and
    ruby_tokeninfo(n, _, "end")
  )
select node, body

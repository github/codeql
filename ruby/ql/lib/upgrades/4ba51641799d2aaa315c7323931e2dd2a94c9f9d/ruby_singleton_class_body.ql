class AstNode extends @ruby_ast_node {
  string toString() { none() }
}

from AstNode node, AstNode body
where
  ruby_singleton_class_def(node, _) and
  ruby_ast_node_info(body, node, _, _) and
  ruby_tokeninfo(body, _, "end") and
  ruby_singleton_class_child(node, _, _)
select node, body

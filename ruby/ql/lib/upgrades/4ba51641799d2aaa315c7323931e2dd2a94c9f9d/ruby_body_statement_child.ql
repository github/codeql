class AstNode extends @ruby_ast_node {
  string toString() { none() }
}

from AstNode node, AstNode body, int index, AstNode child
where
  ruby_class_def(node, _) and
  ruby_ast_node_info(body, node, _, _) and
  ruby_tokeninfo(body, _, "end") and
  ruby_class_child(node, index, child)
  or
  ruby_do_block_def(node) and
  ruby_ast_node_info(body, node, _, _) and
  ruby_tokeninfo(body, _, "end") and
  ruby_do_block_child(node, index, child)
  or
  ruby_method_def(node, _) and
  ruby_ast_node_info(body, node, _, _) and
  ruby_tokeninfo(body, _, "end") and
  ruby_method_child(node, index, child)
  or
  ruby_module_def(node, _) and
  ruby_ast_node_info(body, node, _, _) and
  ruby_tokeninfo(body, _, "end") and
  ruby_module_child(node, index, child)
  or
  ruby_singleton_class_def(node, _) and
  ruby_ast_node_info(body, node, _, _) and
  ruby_tokeninfo(body, _, "end") and
  ruby_singleton_class_child(node, index, child)
  or
  ruby_singleton_method_def(node, _, _) and
  ruby_ast_node_info(body, node, _, _) and
  ruby_tokeninfo(body, _, "end") and
  ruby_singleton_method_child(node, index, child)
select body, index, child

class AstNode extends @ruby_ast_node {
  string toString() { none() }
}

/*
 * It's not possible to generate fresh IDs for the new ruby_body_statement nodes,
 * therefore we re-purpose the "end"-token that closes the block and use its ID instead.
 * As a result the AST will be missing the "end" tokens, but those are unlikely to be used
 * for anything.
 */

from AstNode node, AstNode body
where
  ruby_class_def(node, _) and
  ruby_ast_node_info(body, node, _, _) and
  ruby_tokeninfo(body, _, "end") and
  ruby_class_child(node, _, _)
  or
  ruby_do_block_def(node) and
  ruby_ast_node_info(body, node, _, _) and
  ruby_tokeninfo(body, _, "end") and
  ruby_do_block_child(node, _, _)
  or
  ruby_method_def(node, _) and
  ruby_ast_node_info(body, node, _, _) and
  ruby_tokeninfo(body, _, "end") and
  ruby_method_child(node, _, _)
  or
  ruby_module_def(node, _) and
  ruby_ast_node_info(body, node, _, _) and
  ruby_tokeninfo(body, _, "end") and
  ruby_module_child(node, _, _)
  or
  ruby_singleton_class_def(node, _) and
  ruby_ast_node_info(body, node, _, _) and
  ruby_tokeninfo(body, _, "end") and
  ruby_singleton_class_child(node, _, _)
  or
  ruby_singleton_method_def(node, _, _) and
  ruby_ast_node_info(body, node, _, _) and
  ruby_tokeninfo(body, _, "end") and
  ruby_singleton_method_child(node, _, _)
select body

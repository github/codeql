class AstNode extends @ruby_ast_node {
  string toString() { none() }
}

from AstNode node, AstNode body
where
  ruby_do_block_def(node) and
  ruby_ast_node_info(body, node, _, _) and
  ruby_tokeninfo(body, _, "end") and
  ruby_do_block_child(node, _, _)
select node, body

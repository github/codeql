class AstNode extends @ruby_ast_node {
  string toString() { none() }
}

from AstNode ruby_block, AstNode body, int index, AstNode child
where
  ruby_block_def(ruby_block) and
  ruby_ast_node_info(body, ruby_block, _, _) and
  ruby_tokeninfo(body, _, "}") and
  ruby_block_child(ruby_block, index, child)
select body, index, child

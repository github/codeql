class AstNode extends @ruby_ast_node {
  string toString() { none() }
}

from AstNode ruby_block, AstNode body, int index, AstNode child
where ruby_block_body(ruby_block, body) and ruby_block_body_child(body, index, child)
select ruby_block, index, child

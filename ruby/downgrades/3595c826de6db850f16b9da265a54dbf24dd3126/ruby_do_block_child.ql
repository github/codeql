class AstNode extends @ruby_ast_node {
  string toString() { none() }
}

from AstNode ruby_do_block, AstNode body, int index, AstNode child
where ruby_do_block_body(ruby_do_block, body) and ruby_body_statement_child(body, index, child)
select ruby_do_block, index, child

class AstNode extends @ruby_ast_node {
  string toString() { none() }
}

from AstNode ruby_block_argument, AstNode child
where ruby_block_argument_def(ruby_block_argument, child, _)
select ruby_block_argument, child

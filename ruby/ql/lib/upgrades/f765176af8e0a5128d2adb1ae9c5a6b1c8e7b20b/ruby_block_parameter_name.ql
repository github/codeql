class AstNode extends @ruby_ast_node {
  string toString() { none() }
}

from AstNode ruby_block_parameter, AstNode name
where ruby_block_parameter_def(ruby_block_parameter, name, _)
select ruby_block_parameter, name

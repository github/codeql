class AstNode extends @ruby_ast_node {
  string toString() { none() }
}

class Location extends @location {
  string toString() { none() }
}

from AstNode id, AstNode operand, int operator, Location loc
where ruby_unary_def(id, operand, operator) and ruby_ast_node_info(id, _, _, loc)
select id, operand, operator, loc

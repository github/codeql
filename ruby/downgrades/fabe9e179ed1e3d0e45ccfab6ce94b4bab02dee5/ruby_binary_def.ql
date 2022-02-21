class AstNode extends @ruby_ast_node {
  string toString() { none() }
}

class Location extends @location {
  string toString() { none() }
}

from AstNode id, AstNode left, int operator, AstNode right, Location loc
where ruby_binary_def(id, left, operator, right) and ruby_ast_node_info(id, _, _, loc)
select id, left, operator, right, loc

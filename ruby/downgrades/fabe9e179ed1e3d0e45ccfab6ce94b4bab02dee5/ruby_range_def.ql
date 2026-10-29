class AstNode extends @ruby_ast_node {
  string toString() { none() }
}

class Location extends @location {
  string toString() { none() }
}

from AstNode id, int operator, Location loc
where ruby_range_def(id, operator) and ruby_ast_node_info(id, _, _, loc)
select id, operator, loc

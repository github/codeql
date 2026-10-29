class AstNode extends @ruby_ast_node {
  string toString() { none() }
}

class Location extends @location {
  string toString() { none() }
}

from AstNode id, AstNode left, AstNode right, Location loc
where ruby_assignment_def(id, left, right) and ruby_ast_node_info(id, _, _, loc)
select id, left, right, loc

class AstNode extends @ruby_ast_node {
  string toString() { none() }
}

class Location extends @location {
  string toString() { none() }
}

from AstNode id, AstNode condition, Location loc
where ruby_unless_guard_def(id, condition) and ruby_ast_node_info(id, _, _, loc)
select id, condition, loc

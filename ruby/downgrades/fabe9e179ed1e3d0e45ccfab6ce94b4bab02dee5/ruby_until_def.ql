class AstNode extends @ruby_ast_node {
  string toString() { none() }
}

class Location extends @location {
  string toString() { none() }
}

from AstNode id, AstNode body, AstNode condition, Location loc
where ruby_until_def(id, body, condition) and ruby_ast_node_info(id, _, _, loc)
select id, body, condition, loc

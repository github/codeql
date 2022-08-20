class AstNode extends @ruby_ast_node {
  string toString() { none() }
}

class Location extends @location {
  string toString() { none() }
}

from AstNode id, AstNode body, AstNode pattern, AstNode value, Location loc
where ruby_for_def(id, body, pattern, value) and ruby_ast_node_info(id, _, _, loc)
select id, body, pattern, value, loc

class AstNode extends @ruby_ast_node {
  string toString() { none() }
}

class Location extends @location {
  string toString() { none() }
}

from AstNode id, AstNode body, AstNode handler, Location loc
where ruby_rescue_modifier_def(id, body, handler) and ruby_ast_node_info(id, _, _, loc)
select id, body, handler, loc

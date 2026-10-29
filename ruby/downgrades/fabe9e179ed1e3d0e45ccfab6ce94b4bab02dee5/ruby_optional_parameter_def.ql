class AstNode extends @ruby_ast_node {
  string toString() { none() }
}

class Location extends @location {
  string toString() { none() }
}

from AstNode id, AstNode name, AstNode value, Location loc
where ruby_optional_parameter_def(id, name, value) and ruby_ast_node_info(id, _, _, loc)
select id, name, value, loc

class AstNode extends @ruby_ast_node {
  string toString() { none() }
}

class Location extends @location {
  string toString() { none() }
}

from AstNode id, AstNode method, Location loc
where ruby_call_def(id, method) and ruby_ast_node_info(id, _, _, loc)
select id, method, loc

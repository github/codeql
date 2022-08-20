class AstNode extends @ruby_ast_node {
  string toString() { none() }
}

class Location extends @location {
  string toString() { none() }
}

from AstNode id, Location loc
where ruby_begin_def(id) and ruby_ast_node_info(id, _, _, loc)
select id, loc

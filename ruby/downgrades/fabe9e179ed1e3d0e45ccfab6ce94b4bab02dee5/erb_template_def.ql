class AstNode extends @erb_ast_node {
  string toString() { none() }
}

class Location extends @location {
  string toString() { none() }
}

from AstNode id, Location loc
where erb_template_def(id) and erb_ast_node_info(id, _, _, loc)
select id, loc

class AstNode extends @erb_ast_node {
  string toString() { none() }
}

class Location extends @location {
  string toString() { none() }
}

from AstNode id, int kind, string value, Location loc
where erb_tokeninfo(id, kind, value) and erb_ast_node_info(id, _, _, loc)
select id, kind, value, loc

class AstNode extends @ruby_ast_node {
  string toString() { none() }
}

class Location extends @location_default {
  string toString() { none() }
}

from AstNode n, Location location
where ruby_ast_node_info(n, _, _, location)
select n, location

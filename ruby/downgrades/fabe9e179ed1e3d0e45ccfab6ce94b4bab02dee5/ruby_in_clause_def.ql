class AstNode extends @ruby_ast_node {
  string toString() { none() }
}

class Location extends @location {
  string toString() { none() }
}

from AstNode id, AstNode pattern, Location loc
where ruby_in_clause_def(id, pattern) and ruby_ast_node_info(id, _, _, loc)
select id, pattern, loc

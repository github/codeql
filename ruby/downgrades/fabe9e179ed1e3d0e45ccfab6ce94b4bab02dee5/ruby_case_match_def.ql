class AstNode extends @ruby_ast_node {
  string toString() { none() }
}

class Location extends @location {
  string toString() { none() }
}

from AstNode id, AstNode value, Location loc
where ruby_case_match_def(id, value) and ruby_ast_node_info(id, _, _, loc)
select id, value, loc

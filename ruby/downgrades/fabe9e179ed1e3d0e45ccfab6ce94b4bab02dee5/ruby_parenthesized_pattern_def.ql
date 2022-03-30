class AstNode extends @ruby_ast_node {
  string toString() { none() }
}

class Location extends @location {
  string toString() { none() }
}

from AstNode id, AstNode child, Location loc
where ruby_parenthesized_pattern_def(id, child) and ruby_ast_node_info(id, _, _, loc)
select id, child, loc

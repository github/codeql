class AstNode extends @ruby_ast_node {
  string toString() { none() }
}

class Location extends @location {
  string toString() { none() }
}

from AstNode id, AstNode alternative, AstNode condition, AstNode consequence, Location loc
where
  ruby_conditional_def(id, alternative, condition, consequence) and
  ruby_ast_node_info(id, _, _, loc)
select id, alternative, condition, consequence, loc

class AstNode extends @ruby_ast_node {
  string toString() { none() }
}

class Location extends @location {
  string toString() { none() }
}

from AstNode id, AstNode name, AstNode object, Location loc
where ruby_singleton_method_def(id, name, object) and ruby_ast_node_info(id, _, _, loc)
select id, name, object, loc

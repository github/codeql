class AstNode extends @ruby_ast_node {
  string toString() { none() }
}

class Location extends @location {
  string toString() { none() }
}

from AstNode id, AstNode object, Location loc
where ruby_element_reference_def(id, object) and ruby_ast_node_info(id, _, _, loc)
select id, object, loc

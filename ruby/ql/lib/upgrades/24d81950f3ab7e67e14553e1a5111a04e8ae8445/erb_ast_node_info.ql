class Location extends @location {
  string toString() { none() }
}

class ErbAstNodeParent extends @erb_ast_node_parent {
  string toString() { none() }
}

class ErbAstNode extends @erb_ast_node {
  string toString() { none() }

  ErbAstNodeParent getParent(int index) { erb_ast_node_parent(this, result, index) }

  Location getLocation() {
    erb_tokeninfo(this, _, _, result) or
    erb_comment_directive_def(this, _, result) or
    erb_directive_def(this, _, result) or
    erb_graphql_directive_def(this, _, result) or
    erb_output_directive_def(this, _, result) or
    erb_template_def(this, result)
  }
}

from ErbAstNode node, ErbAstNodeParent parent, int index, Location loc
where parent = node.getParent(index) and loc = node.getLocation()
select node, parent, index, loc

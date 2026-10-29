class AstNode extends @ruby_ast_node_parent {
  string toString() { none() }
}

class Location extends @location {
  string toString() { none() }
}

class Wrapper = @ruby_body_statement or @ruby_block_body;

predicate astNodeInfo(AstNode child, AstNode parent, int primaryIndex, int secondaryIndex) {
  not parent instanceof Wrapper and
  exists(AstNode node, Location l |
    ruby_ast_node_info(node, parent, primaryIndex, _) and
    (
      not node instanceof Wrapper and secondaryIndex = 0 and child = node
      or
      node instanceof Wrapper and ruby_ast_node_info(child, node, secondaryIndex, _)
    )
  )
}

from AstNode node, AstNode parent, int parent_index, Location loc
where
  node =
    rank[parent_index + 1](AstNode n, int i, int j | astNodeInfo(n, parent, i, j) | n order by i, j) and
  ruby_ast_node_info(node, _, _, loc)
select node, parent, parent_index, loc

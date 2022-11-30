class AstNode extends @ruby_ast_node_parent {
  string toString() { none() }
}

class Location extends @location {
  string toString() { none() }
}

private predicate body_statement(AstNode body, AstNode firstChild) {
  exists(AstNode node |
    ruby_class_def(node, _) and
    ruby_ast_node_info(body, node, _, _) and
    ruby_tokeninfo(body, _, "end") and
    ruby_class_child(node, 0, firstChild)
    or
    ruby_do_block_def(node) and
    ruby_ast_node_info(body, node, _, _) and
    ruby_tokeninfo(body, _, "end") and
    ruby_do_block_child(node, 0, firstChild)
    or
    ruby_method_def(node, _) and
    ruby_ast_node_info(body, node, _, _) and
    ruby_tokeninfo(body, _, "end") and
    ruby_method_child(node, 0, firstChild)
    or
    ruby_module_def(node, _) and
    ruby_ast_node_info(body, node, _, _) and
    ruby_tokeninfo(body, _, "end") and
    ruby_module_child(node, 0, firstChild)
    or
    ruby_singleton_class_def(node, _) and
    ruby_ast_node_info(body, node, _, _) and
    ruby_tokeninfo(body, _, "end") and
    ruby_singleton_class_child(node, 0, firstChild)
    or
    ruby_singleton_method_def(node, _, _) and
    ruby_ast_node_info(body, node, _, _) and
    ruby_tokeninfo(body, _, "end") and
    ruby_singleton_method_child(node, 0, firstChild)
    or
    ruby_block_def(node) and
    ruby_ast_node_info(body, node, _, _) and
    ruby_tokeninfo(body, _, "}") and
    ruby_block_child(node, 0, firstChild)
  )
}

private predicate body_statement_child(AstNode body, int index, AstNode child) {
  exists(AstNode parent, AstNode firstChild, int firstChildIndex |
    body_statement(body, firstChild) and
    ruby_ast_node_info(firstChild, parent, firstChildIndex, _) and
    child =
      rank[index + 1](AstNode c, int i |
        ruby_ast_node_info(c, parent, i, _) and i >= firstChildIndex and c != body
      |
        c order by i
      )
  )
}

private predicate astNodeInfo(AstNode node, AstNode parent, int parent_index, Location loc) {
  ruby_ast_node_info(node, parent, parent_index, loc) and
  not body_statement(node, _) and
  not body_statement_child(_, _, node)
}

from AstNode node, AstNode parent, int parent_index, Location loc
where
  astNodeInfo(node, parent, parent_index, loc)
  or
  body_statement_child(parent, parent_index, node) and ruby_ast_node_info(node, _, _, loc)
  or
  body_statement(node, _) and
  ruby_ast_node_info(node, parent, _, loc) and
  parent_index = count(AstNode n | astNodeInfo(n, parent, _, _))
select node, parent, parent_index, loc

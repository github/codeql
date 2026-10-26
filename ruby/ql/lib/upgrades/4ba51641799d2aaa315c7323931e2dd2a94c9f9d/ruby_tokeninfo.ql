class AstNode extends @ruby_ast_node {
  string toString() { none() }
}

private predicate body_statement(AstNode body) {
  exists(AstNode node |
    ruby_class_def(node, _) and
    ruby_ast_node_info(body, node, _, _) and
    ruby_tokeninfo(body, _, "end") and
    ruby_class_child(node, _, _)
    or
    ruby_do_block_def(node) and
    ruby_ast_node_info(body, node, _, _) and
    ruby_tokeninfo(body, _, "end") and
    ruby_do_block_child(node, _, _)
    or
    ruby_method_def(node, _) and
    ruby_ast_node_info(body, node, _, _) and
    ruby_tokeninfo(body, _, "end") and
    ruby_method_child(node, _, _)
    or
    ruby_module_def(node, _) and
    ruby_ast_node_info(body, node, _, _) and
    ruby_tokeninfo(body, _, "end") and
    ruby_module_child(node, _, _)
    or
    ruby_singleton_class_def(node, _) and
    ruby_ast_node_info(body, node, _, _) and
    ruby_tokeninfo(body, _, "end") and
    ruby_singleton_class_child(node, _, _)
    or
    ruby_singleton_method_def(node, _, _) and
    ruby_ast_node_info(body, node, _, _) and
    ruby_tokeninfo(body, _, "end") and
    ruby_singleton_method_child(node, _, _)
    or
    ruby_block_def(node) and
    ruby_ast_node_info(body, node, _, _) and
    ruby_tokeninfo(body, _, "}") and
    ruby_block_child(node, _, _)
  )
}

from AstNode token, int kind, string value
where ruby_tokeninfo(token, kind, value) and not body_statement(token)
select token, kind, value

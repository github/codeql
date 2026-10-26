class AstNode extends @ruby_ast_node {
  string toString() { none() }
}

class Location extends @location {
  string toString() { none() }
}

class File extends @file {
  string toString() { none() }
}

private predicate body_statement(AstNode body, int index, Location loc) {
  exists(AstNode node, AstNode child | ruby_ast_node_info(child, _, _, loc) |
    ruby_class_def(node, _) and
    ruby_ast_node_info(body, node, _, _) and
    ruby_tokeninfo(body, _, "end") and
    ruby_class_child(node, index, child)
    or
    ruby_do_block_def(node) and
    ruby_ast_node_info(body, node, _, _) and
    ruby_tokeninfo(body, _, "end") and
    ruby_do_block_child(node, index, child)
    or
    ruby_method_def(node, _) and
    ruby_ast_node_info(body, node, _, _) and
    ruby_tokeninfo(body, _, "end") and
    ruby_method_child(node, index, child)
    or
    ruby_module_def(node, _) and
    ruby_ast_node_info(body, node, _, _) and
    ruby_tokeninfo(body, _, "end") and
    ruby_module_child(node, index, child)
    or
    ruby_singleton_class_def(node, _) and
    ruby_ast_node_info(body, node, _, _) and
    ruby_tokeninfo(body, _, "end") and
    ruby_singleton_class_child(node, index, child)
    or
    ruby_singleton_method_def(node, _, _) and
    ruby_ast_node_info(body, node, _, _) and
    ruby_tokeninfo(body, _, "end") and
    ruby_singleton_method_child(node, index, child)
    or
    ruby_block_def(node) and
    ruby_ast_node_info(body, node, _, _) and
    ruby_tokeninfo(body, _, "}") and
    ruby_block_child(node, index, child)
  )
}

from Location loc, File file, int start_line, int start_column, int end_line, int end_column
where
  locations_default(loc, file, start_line, start_column, end_line, end_column) and
  not exists(AstNode node | ruby_ast_node_info(node, _, _, loc) and body_statement(node, _, _))
  or
  exists(AstNode node |
    ruby_ast_node_info(node, _, _, loc) and
    exists(Location first |
      body_statement(node, 0, first) and
      locations_default(first, pragma[only_bind_into](file), start_line, start_column, _, _)
    ) and
    exists(Location last |
      last = max(Location l, int i | body_statement(node, i, l) | l order by i) and
      locations_default(last, pragma[only_bind_into](file), _, _, end_line, end_column)
    )
  )
select loc, file, start_line, start_column, end_line, end_column

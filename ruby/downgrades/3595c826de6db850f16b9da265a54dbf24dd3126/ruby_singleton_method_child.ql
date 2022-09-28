class AstNode extends @ruby_ast_node {
  string toString() { none() }
}

from AstNode ruby_singleton_method, int index, AstNode child
where
  exists(AstNode body |
    ruby_singleton_method_body(ruby_singleton_method, body) and
    ruby_body_statement_child(body, index, child)
  )
  or
  ruby_singleton_method_body(ruby_singleton_method, child) and
  not child instanceof @ruby_body_statement and
  index = 0
select ruby_singleton_method, index, child

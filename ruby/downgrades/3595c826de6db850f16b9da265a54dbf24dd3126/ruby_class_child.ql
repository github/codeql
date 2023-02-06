class AstNode extends @ruby_ast_node {
  string toString() { none() }
}

from AstNode ruby_class, AstNode body, int index, AstNode child
where ruby_class_body(ruby_class, body) and ruby_body_statement_child(body, index, child)
select ruby_class, index, child

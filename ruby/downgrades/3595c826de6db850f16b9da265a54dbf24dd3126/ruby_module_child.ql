class AstNode extends @ruby_ast_node {
  string toString() { none() }
}

from AstNode ruby_module, AstNode body, int index, AstNode child
where ruby_module_body(ruby_module, body) and ruby_body_statement_child(body, index, child)
select ruby_module, index, child

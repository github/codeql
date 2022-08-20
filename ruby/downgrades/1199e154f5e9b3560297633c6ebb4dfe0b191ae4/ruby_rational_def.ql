private class RubyAstNode extends @ruby_ast_node {
  string toString() { none() }
}

from RubyAstNode node, RubyAstNode child
where ruby_rational_def(node, child) and not ruby_complex_def(_, node)
select node, child

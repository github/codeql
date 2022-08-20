class AstNode extends @ruby_ast_node {
  string toString() { none() }
}

from AstNode ruby_pair, AstNode value
where ruby_pair_def(ruby_pair, _, value, _)
select ruby_pair, value

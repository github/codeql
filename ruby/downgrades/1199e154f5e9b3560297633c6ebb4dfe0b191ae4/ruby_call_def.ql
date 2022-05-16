class RubyAstNode extends @ruby_ast_node {
  string toString() { none() }
}

class RubyCall extends RubyAstNode, @ruby_call { }

from RubyCall ruby_call, RubyAstNode method
where
  ruby_call_method(ruby_call, method)
  or
  ruby_call_def(ruby_call) and
  not ruby_call_method(ruby_call, _) and
  ruby_call_arguments(ruby_call, method)
select ruby_call, method

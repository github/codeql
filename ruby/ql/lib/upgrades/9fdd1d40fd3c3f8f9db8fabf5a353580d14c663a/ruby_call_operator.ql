class RubyCallOperator extends @ruby_reserved_word {
  RubyCallOperator() { ruby_tokeninfo(this, _, [".", "::", "&."]) }

  string toString() { none() }
}

class RubyCallMethodType = @ruby_token_operator or @ruby_underscore_variable;

abstract class RubyCall extends @ruby_ast_node {
  string toString() { none() }

  abstract RubyCallOperator getOperator();
}

class NormalRubyCall extends RubyCall, @ruby_call {
  NormalRubyCall() { ruby_call_def(this, any(RubyCallMethodType m)) }

  override RubyCallOperator getOperator() { ruby_ast_node_info(result, this, _, _) }
}

class ImplicitRubyCall extends RubyCall, @ruby_call {
  ImplicitRubyCall() { ruby_call_def(this, any(@ruby_argument_list a)) }

  override RubyCallOperator getOperator() { ruby_ast_node_info(result, this, _, _) }
}

class ScopeResolutionCall extends RubyCall, @ruby_scope_resolution {
  ScopeResolutionCall() {
    ruby_scope_resolution_def(this, any(@ruby_token_identifier m)) and
    not ruby_call_def(_, this)
  }

  override RubyCallOperator getOperator() { ruby_ast_node_info(result, this, _, _) }
}

class ScopeResolutionMethodCall extends RubyCall, @ruby_call {
  private @ruby_scope_resolution scope;

  ScopeResolutionMethodCall() { ruby_call_def(this, scope) }

  override RubyCallOperator getOperator() { ruby_ast_node_info(result, scope, _, _) }
}

from RubyCall ruby_call
select ruby_call, ruby_call.getOperator()

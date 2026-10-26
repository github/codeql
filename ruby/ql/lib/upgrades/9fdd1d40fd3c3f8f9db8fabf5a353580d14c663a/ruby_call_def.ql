class RubyCallMethodType = @ruby_token_operator or @ruby_underscore_variable;

abstract class RubyCall extends @ruby_ast_node {
  string toString() { none() }
}

class NormalRubyCall extends RubyCall, @ruby_call {
  NormalRubyCall() { ruby_call_def(this, any(RubyCallMethodType m)) }
}

class ImplicitRubyCall extends RubyCall, @ruby_call {
  ImplicitRubyCall() { ruby_call_def(this, any(@ruby_argument_list a)) }
}

class ScopeResolutionCall extends RubyCall, @ruby_scope_resolution {
  ScopeResolutionCall() {
    ruby_scope_resolution_def(this, any(@ruby_token_identifier m)) and
    not ruby_call_def(_, this)
  }
}

class ScopeResolutionMethodCall extends RubyCall, @ruby_call {
  ScopeResolutionMethodCall() { ruby_call_def(this, any(@ruby_scope_resolution s)) }
}

from RubyCall ruby_call
select ruby_call

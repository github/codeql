class RubyCallMethodType = @ruby_token_operator or @ruby_underscore_variable;

class RubyArgumentList extends @ruby_argument_list {
  string toString() { none() }
}

abstract class RubyCall extends @ruby_ast_node {
  string toString() { none() }

  abstract RubyArgumentList getArguments();
}

class NormalRubyCall extends RubyCall, @ruby_call {
  NormalRubyCall() { ruby_call_def(this, any(RubyCallMethodType m)) }

  override RubyArgumentList getArguments() { ruby_call_arguments(this, result) }
}

class ImplicitRubyCall extends RubyCall, @ruby_call {
  RubyArgumentList arguments;

  ImplicitRubyCall() { ruby_call_def(this, arguments) }

  override RubyArgumentList getArguments() { result = arguments }
}

class ScopeResolutionCall extends RubyCall, @ruby_scope_resolution {
  ScopeResolutionCall() {
    ruby_scope_resolution_def(this, any(@ruby_token_identifier m)) and
    not ruby_call_def(_, this)
  }

  override RubyArgumentList getArguments() { none() }
}

class ScopeResolutionMethodCall extends RubyCall, @ruby_call {
  ScopeResolutionMethodCall() { ruby_call_def(this, any(@ruby_scope_resolution s)) }

  override RubyArgumentList getArguments() { ruby_call_arguments(this, result) }
}

from RubyCall ruby_call
select ruby_call, ruby_call.getArguments()

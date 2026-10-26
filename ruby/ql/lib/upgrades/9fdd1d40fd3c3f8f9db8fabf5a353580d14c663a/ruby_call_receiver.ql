class RubyCallMethodType = @ruby_token_operator or @ruby_underscore_variable;

class RubyPrimary extends @ruby_underscore_primary {
  string toString() { none() }
}

abstract class RubyCall extends @ruby_ast_node {
  string toString() { none() }

  abstract RubyPrimary getReceiver();
}

class NormalRubyCall extends RubyCall, @ruby_call {
  NormalRubyCall() { ruby_call_def(this, any(RubyCallMethodType m)) }

  override RubyPrimary getReceiver() { ruby_call_receiver(this, result) }
}

class ImplicitRubyCall extends RubyCall, @ruby_call {
  ImplicitRubyCall() { ruby_call_def(this, any(@ruby_argument_list a)) }

  override RubyPrimary getReceiver() { ruby_call_receiver(this, result) }
}

class ScopeResolutionCall extends RubyCall, @ruby_scope_resolution {
  ScopeResolutionCall() {
    ruby_scope_resolution_def(this, any(@ruby_token_identifier m)) and
    not ruby_call_def(_, this)
  }

  override RubyPrimary getReceiver() { ruby_scope_resolution_scope(this, result) }
}

class ScopeResolutionMethodCall extends RubyCall, @ruby_call {
  private @ruby_scope_resolution scope;

  ScopeResolutionMethodCall() { ruby_call_def(this, scope) }

  override RubyPrimary getReceiver() { ruby_scope_resolution_scope(scope, result) }
}

from RubyCall ruby_call
select ruby_call, ruby_call.getReceiver()

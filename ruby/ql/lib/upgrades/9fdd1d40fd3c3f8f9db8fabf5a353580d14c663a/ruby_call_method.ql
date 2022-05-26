class RubyCallMethodType = @ruby_token_operator or @ruby_underscore_variable;

class RubyMethod extends RubyCallMethodType {
  string toString() { none() }
}

abstract class RubyCall extends @ruby_ast_node {
  string toString() { none() }

  abstract RubyMethod getMethod();
}

class NormalRubyCall extends RubyCall, @ruby_call {
  private RubyMethod method;

  NormalRubyCall() { ruby_call_def(this, method) }

  override RubyMethod getMethod() { result = method }
}

class ScopeResolutionCall extends RubyCall, @ruby_scope_resolution {
  private @ruby_token_identifier method;

  ScopeResolutionCall() {
    ruby_scope_resolution_def(this, method) and
    not ruby_call_def(_, this)
  }

  override RubyMethod getMethod() { result = method }
}

class ScopeResolutionMethodCall extends RubyCall, @ruby_call {
  private RubyMethod method;

  ScopeResolutionMethodCall() {
    exists(@ruby_scope_resolution scope |
      ruby_call_def(this, scope) and
      ruby_scope_resolution_def(scope, method)
    )
  }

  override RubyMethod getMethod() { result = method }
}

from RubyCall ruby_call
select ruby_call, ruby_call.getMethod()

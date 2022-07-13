class RubyScopeResolution extends @ruby_scope_resolution {
  RubyScopeResolution() {
    exists(RubyConstant name | ruby_scope_resolution_def(this, name)) and
    not ruby_call_def(_, this)
  }

  string toString() { none() }
}

class RubyConstant extends @ruby_token_constant {
  string toString() { none() }
}

from RubyScopeResolution scope, RubyConstant name
where ruby_scope_resolution_def(scope, name)
select scope, name

import codeql_ruby.AST
private import codeql_ruby.Generated
private import codeql.Locations
private import Pattern

private Generated::AstNode parent(Generated::AstNode n) {
  result = n.getParent() and
  not n = any(VariableScope s).getScopeElement()
}

/** Gets the enclosing scope for `node`. */
private VariableScope enclosingScope(Generated::AstNode node) {
  result.getScopeElement() = parent*(node.getParent())
}

/** Holds if `scope` defines `name` in its parameter declaration at `i`. */
private predicate scopeDefinesParameterVariable(
  CallableScope scope, string name, Generated::Identifier i
) {
  assignment(i, true) and
  scope = enclosingScope(i) and
  name = i.getValue()
  or
  exists(Parameter p |
    p = scope.getScopeElement().getAParameter() and
    name = p.(NamedParameter).getName()
  |
    i = p.(Generated::BlockParameter).getName() or
    i = p.(Generated::HashSplatParameter).getName() or
    i = p.(Generated::KeywordParameter).getName() or
    i = p.(Generated::OptionalParameter).getName() or
    i = p.(Generated::SplatParameter).getName()
  )
}

/** Holds if `name` is assigned in `scope` at `i`. */
private predicate scopeAssigns(VariableScope scope, string name, Generated::Identifier i) {
  assignment(i, false) and
  name = i.getValue() and
  scope = enclosingScope(i)
}

/** Holds if location `one` starts strictly before location `two` */
pragma[inline]
private predicate strictlyBefore(Location one, Location two) {
  one.getStartLine() < two.getStartLine()
  or
  one.getStartLine() = two.getStartLine() and one.getStartColumn() < two.getStartColumn()
}

/** A scope that may capture outer local variables. */
private class CapturingScope extends CallableScope {
  CapturingScope() {
    exists(Callable c | c = this.getScopeElement() |
      c instanceof Block
      or
      c instanceof DoBlock
      or
      c instanceof Lambda // TODO: Check if this is actually the case
    )
  }

  /** Gets the scope in which this scope is nested, if any. */
  private VariableScope getOuterScope() { result = enclosingScope(this.getScopeElement()) }

  /** Holds if this scope inherits `name` from an outer scope `outer`. */
  predicate inherits(string name, VariableScope outer) {
    not scopeDefinesParameterVariable(this, name, _) and
    (
      outer = this.getOuterScope() and
      (
        scopeDefinesParameterVariable(outer, name, _)
        or
        exists(Generated::Identifier i |
          scopeAssigns(outer, name, i) and
          strictlyBefore(i.getLocation(), this.getLocation())
        )
      )
      or
      this.getOuterScope().(CapturingScope).inherits(name, outer)
    )
  }
}

cached
private module Cached {
  cached
  newtype TScope =
    TTopLevelScope(Generated::Program node) or
    TModuleScope(Generated::Module node) or
    TClassScope(AstNode cls) {
      cls instanceof Generated::Class or cls instanceof Generated::SingletonClass
    } or
    TCallableScope(Callable c)

  cached
  newtype TVariable =
    TLocalVariable(VariableScope scope, string name, Generated::Identifier i) {
      scopeDefinesParameterVariable(scope, name, i)
      or
      scopeAssigns(scope, name, i) and
      i =
        min(Generated::Identifier other |
          scopeAssigns(scope, name, other)
        |
          other order by other.getLocation().getStartLine(), other.getLocation().getStartColumn()
        ) and
      not scopeDefinesParameterVariable(scope, name, _) and
      not scope.(CapturingScope).inherits(name, _)
    }

  cached
  predicate access(Generated::Identifier access, Variable variable) {
    exists(string name |
      name = access.getValue() and
      // Do not generate an access at the defining location
      not variable = TLocalVariable(_, name, access)
    |
      variable = enclosingScope(access).getVariable(name) and
      not strictlyBefore(access.getLocation(), variable.getLocation())
      or
      exists(VariableScope declScope |
        variable = declScope.getVariable(name) and
        enclosingScope(access).(CapturingScope).inherits(name, declScope)
      )
    )
  }
}

import Cached

private import TreeSitter
private import codeql.Locations
private import codeql_ruby.AST
private import codeql_ruby.ast.internal.Expr
private import codeql_ruby.ast.internal.Pattern

private Generated::AstNode parent(Generated::AstNode n) {
  result = n.getParent() and
  not n = any(VariableScope s).getScopeElement()
}

/** Gets the enclosing scope for `node`. */
private VariableScope enclosingScope(Generated::AstNode node) {
  result.getScopeElement() = parent*(node.getParent())
}

private predicate parameterAssignment(
  CallableScope::Range scope, string name, Generated::Identifier i
) {
  assignment(i, true) and
  scope = enclosingScope(i) and
  name = i.getValue()
}

/** Holds if `scope` defines `name` in its parameter declaration at `i`. */
private predicate scopeDefinesParameterVariable(
  CallableScope::Range scope, string name, Generated::Identifier i
) {
  parameterAssignment(scope, name, i) and
  // In case of overlapping parameter names (e.g. `_`), only the first
  // parameter will give rise to a variable
  i =
    min(Generated::Identifier other |
      parameterAssignment(scope, name, other)
    |
      other order by other.getLocation().getStartLine(), other.getLocation().getStartColumn()
    )
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
private class CapturingScope extends VariableScope {
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
    exists(string name | name = access.getValue() |
      variable = enclosingScope(access).getVariable(name) and
      not strictlyBefore(access.getLocation(), variable.getLocation()) and
      // In case of overlapping parameter names, later parameters should not
      // be considered accesses to the first parameter
      if parameterAssignment(_, _, access)
      then scopeDefinesParameterVariable(_, _, access)
      else any()
      or
      exists(VariableScope declScope |
        variable = declScope.getVariable(name) and
        enclosingScope(access).(CapturingScope).inherits(name, declScope)
      )
    )
  }
}

import Cached

module VariableScope {
  abstract class Range extends TScope {
    abstract string toString();

    abstract AstNode getScopeElement();
  }
}

module TopLevelScope {
  class Range extends VariableScope::Range, TTopLevelScope {
    override string toString() { result = "top-level scope" }

    override AstNode getScopeElement() { TTopLevelScope(result) = this }
  }
}

module ModuleScope {
  class Range extends VariableScope::Range, TModuleScope {
    override string toString() { result = "module scope" }

    override AstNode getScopeElement() { TModuleScope(result) = this }
  }
}

module ClassScope {
  class Range extends VariableScope::Range, TClassScope {
    override string toString() { result = "class scope" }

    override AstNode getScopeElement() { TClassScope(result) = this }
  }
}

module CallableScope {
  class Range extends VariableScope::Range, TCallableScope {
    private Callable c;

    Range() { this = TCallableScope(c) }

    override string toString() {
      (c instanceof Method or c instanceof SingletonMethod) and
      result = "method scope"
      or
      c instanceof Lambda and
      result = "lambda scope"
      or
      c instanceof Block and
      result = "block scope"
    }

    override Callable getScopeElement() { TCallableScope(result) = this }
  }
}

module Variable {
  class Range extends TVariable {
    abstract string getName();

    string toString() { result = this.getName() }

    abstract Location getLocation();

    abstract VariableScope getDeclaringScope();
  }
}

module LocalVariable {
  class Range extends Variable::Range {
    private VariableScope scope;
    private string name;
    private Generated::Identifier i;

    Range() { this = TLocalVariable(scope, name, i) }

    final override string getName() { result = name }

    final override Location getLocation() { result = i.getLocation() }

    final override VariableScope getDeclaringScope() { result = scope }
  }
}

module VariableAccess {
  class Range extends Expr::Range, @token_identifier {
    override Generated::Identifier generated;
    Variable variable;

    Range() { access(this, variable) }

    Variable getVariable() { result = variable }
  }
}

module LocalVariableAccess {
  class Range extends VariableAccess::Range {
    override LocalVariable variable;

    override LocalVariable getVariable() { result = variable }
  }
}

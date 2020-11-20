/** Provides classes for modeling program variables. */

private import ast
private import codeql.Locations

private newtype TScope =
  TTopLevelScope(Program node) or
  TModuleScope(Module node) or
  TClassScope(AstNode cls) { cls instanceof Class or cls instanceof SingletonClass } or
  TMethodScope(AstNode method) { method instanceof Method or method instanceof SingletonMethod } or
  TBlockScope(AstNode block) { block instanceof Block or block instanceof DoBlock }

/** A scope in which variables can be declared. */
class VariableScope extends TScope {
  /** Gets a textual representation of this element. */
  abstract string toString();

  /** Gets the program element this scope is associated with, if any. */
  abstract AstNode getScopeElement();

  /** Gets the location of the program element this scope is associated with. */
  final Location getLocation() { result = getScopeElement().getLocation() }

  /**
   * Gets a variable that is visible in this scope.
   *
   * A variable is visible if it is either declared in this scope, or in some outer scope
   * (only when this scope is a block scope).
   */
  final Variable getAVariable() { result.getDeclaringScope() = this }

  /**
   * Gets the variable with the given name that is visible in this scope.
   *
   * A variable is visible if it is either declared in this scope, or in some outer scope
   * (only when this scope is a block scope).
   */
  Variable getVariable(string name) {
    result = this.getAVariable() and
    result.getName() = name
  }
}

private AstNode parent(AstNode n) {
  result = n.getParent() and
  not n = any(VariableScope s).getScopeElement()
}

/** Gets the enclosing scope for `node`. */
private VariableScope enclosingScope(AstNode node) {
  result.getScopeElement() = parent*(node.getParent())
}

/** Holds if `scope` defines `name` as a parameter. */
private predicate scopeDefinesParameter(VariableScope scope, string name, Location location) {
  exists(Identifier var |
    name = var.getValue() and
    location = var.getLocation() and
    var in [scope
              .(BlockScope)
              .getScopeElement()
              .getAFieldOrChild()
              .(BlockParameters)
              .getAFieldOrChild+(),
          scope
              .(MethodScope)
              .getScopeElement()
              .getAFieldOrChild()
              .(MethodParameters)
              .getAFieldOrChild+()]
  )
}

/** Holds if `var` is assigned in `scope`. */
private predicate scopeAssigns(VariableScope scope, Identifier var) {
  var in [any(Assignment assign).getLeft(), any(OperatorAssignment assign).getLeft()] and
  scope = enclosingScope(var)
}

/** Holds if location `one` starts strictly before location `two` */
pragma[inline]
predicate strictlyBefore(Location one, Location two) {
  one.getStartLine() < two.getStartLine()
  or
  one.getStartLine() = two.getStartLine() and one.getStartColumn() < two.getStartColumn()
}

/** Holds if block scope `scope` inherits `var` from an outer scope. */
private predicate blockScopeInherits(BlockScope scope, string var) {
  exists(VariableScope outer | outer = scope.getOuterScope() |
    scopeDefinesParameter(outer, var, _)
    or
    exists(Identifier i | i.getValue() = var |
      scopeAssigns(outer, i) and
      strictlyBefore(i.getLocation(), scope.getLocation())
    )
    or
    blockScopeInherits(outer, var)
  )
}

newtype TVariable =
  TParameter(VariableScope scope, string name, Location location) {
    scopeDefinesParameter(scope, name, location)
  } or
  TLocalVariable(VariableScope scope, string name, Location location) {
    not scopeDefinesParameter(scope, name, _) and
    not blockScopeInherits(scope, name) and
    location =
      min(Location loc, Identifier other |
        loc = other.getLocation() and name = other.getValue() and scopeAssigns(scope, other)
      |
        loc order by loc.getStartLine(), loc.getStartColumn()
      )
  }

/** A variable declared in a scope. */
class Variable extends TVariable {
  VariableScope scope;
  string name;
  Location location;

  Variable() {
    this = TParameter(scope, name, location)
    or
    this = TLocalVariable(scope, name, location)
  }

  /** Gets the name of this variable. */
  final string getName() { result = name }

  /** Gets a textual representation of this variable. */
  final string toString() { result = name }

  /** Gets the location of this variable. */
  final Location getLocation() { result = location }

  /** Gets the scope this variable is declared in. */
  final VariableScope getDeclaringScope() { result = scope }

  /** Gets an access to this variable. */
  VariableAccess getAnAccess() { result.getVariable() = this }
}

/** A parameter. */
class Parameter extends Variable {
  Parameter() { this = TParameter(scope, name, location) }

  final override ParameterAccess getAnAccess() { result = super.getAnAccess() }
}

/** A local variable. */
class LocalVariable extends Variable {
  LocalVariable() { this = TLocalVariable(scope, name, location) }

  final override LocalVariableAccess getAnAccess() { result = super.getAnAccess() }
}

/** An identifier that refers to a variable. */
class VariableAccess extends Identifier {
  Variable variable;

  VariableAccess() {
    exists(VariableScope scope | scope = enclosingScope(this) |
      variable = scope.getVariable(this.getValue()) and
      not strictlyBefore(this.getLocation(), variable.getLocation())
    )
  }

  /**
   * Gets the variable this identifier refers to.
   */
  Variable getVariable() { result = variable }
}

/** An identifier that refers to a parameter. */
class ParameterAccess extends VariableAccess {
  override Parameter variable;

  final override Parameter getVariable() { result = variable }
}

/** An identifier that refers to a local variable. */
class LocalVariableAccess extends VariableAccess {
  override LocalVariable variable;

  final override LocalVariable getVariable() { result = super.getVariable() }
}

/** A top-level scope. */
class TopLevelScope extends VariableScope, TTopLevelScope {
  final override string toString() { result = "top-level scope" }

  final override AstNode getScopeElement() { TTopLevelScope(result) = this }
}

/** A module scope. */
class ModuleScope extends VariableScope, TModuleScope {
  final override string toString() { result = "module scope" }

  final override Module getScopeElement() { TModuleScope(result) = this }
}

/** A class scope. */
class ClassScope extends VariableScope, TClassScope {
  final override string toString() { result = "class scope" }

  final override AstNode getScopeElement() { TClassScope(result) = this }
}

/** A method scope. */
class MethodScope extends VariableScope, TMethodScope {
  final override string toString() { result = "method scope" }

  final override AstNode getScopeElement() { TMethodScope(result) = this }
}

/** A block scope. */
class BlockScope extends VariableScope, TBlockScope {
  final override string toString() { result = "block scope" }

  final override AstNode getScopeElement() { TBlockScope(result) = this }

  /** Gets the scope in which this scope is nested, if any. */
  final VariableScope getOuterScope() { result = enclosingScope(this.getScopeElement()) }

  final override Variable getVariable(string name) {
    result = VariableScope.super.getVariable(name)
    or
    not exists(VariableScope.super.getVariable(name)) and
    result = this.getOuterScope().getVariable(name)
  }
}

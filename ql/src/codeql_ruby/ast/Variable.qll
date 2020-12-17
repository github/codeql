/** Provides classes for modeling program variables. */

private import codeql_ruby.AST
private import codeql.Locations
private import internal.TreeSitter
private import internal.Variable

/** A scope in which variables can be declared. */
class VariableScope extends TScope {
  VariableScope::Range range;

  VariableScope() { range = this }

  /** Gets a textual representation of this element. */
  final string toString() { result = range.toString() }

  /** Gets the program element this scope is associated with, if any. */
  final AstNode getScopeElement() { result = range.getScopeElement() }

  /** Gets the location of the program element this scope is associated with. */
  final Location getLocation() { result = getScopeElement().getLocation() }

  /** Gets a variable that is declared in this scope. */
  final Variable getAVariable() { result.getDeclaringScope() = this }

  /** Gets the variable with the given name that is declared in this scope. */
  final Variable getVariable(string name) {
    result = this.getAVariable() and
    result.getName() = name
  }
}

/** A variable declared in a scope. */
class Variable extends TVariable {
  Variable::Range range;

  Variable() { range = this }

  /** Gets the name of this variable. */
  final string getName() { result = range.getName() }

  /** Gets a textual representation of this variable. */
  final string toString() { result = this.getName() }

  /** Gets the location of this variable. */
  final Location getLocation() { result = range.getLocation() }

  /** Gets the scope this variable is declared in. */
  final VariableScope getDeclaringScope() { result = range.getDeclaringScope() }

  /** Gets an access to this variable. */
  VariableAccess getAnAccess() { result.getVariable() = this }
}

/** A local variable. */
class LocalVariable extends Variable {
  override LocalVariable::Range range;

  final override LocalVariableAccess getAnAccess() { result.getVariable() = this }
}

/** An access to a variable. */
class VariableAccess extends Expr, @token_identifier {
  override VariableAccess::Range range;

  /** Gets the variable this identifier refers to. */
  Variable getVariable() { result = range.getVariable() }

  final override string toString() { result = this.getVariable().getName() }

  override string getAPrimaryQlClass() { result = "VariableAccess" }
}

/** An access to a local variable. */
class LocalVariableAccess extends VariableAccess {
  final override LocalVariableAccess::Range range;

  /** Gets the variable this identifier refers to. */
  override LocalVariable getVariable() { result = range.getVariable() }

  final override string getAPrimaryQlClass() { result = "LocalVariableAccess" }
}

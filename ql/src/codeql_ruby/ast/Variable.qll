/** Provides classes for modeling program variables. */

import codeql_ruby.AST
private import codeql.Locations
private import internal.TreeSitter
private import internal.Variable

/** A scope in which variables can be declared. */
class VariableScope extends TScope {
  VariableScopeRange self;

  VariableScope() { self = this }

  /** Gets a textual representation of this element. */
  final string toString() { result = self.toString() }

  /** Gets the program element this scope is associated with, if any. */
  final AstNode getScopeElement() { result = self.getScopeElement() }

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
  VariableRange self;

  Variable() { self = this }

  /** Gets the name of this variable. */
  final string getName() { result = self.getName() }

  /** Gets a textual representation of this variable. */
  final string toString() { result = this.getName() }

  /** Gets the location of this variable. */
  final Location getLocation() { result = self.getLocation() }

  /** Gets the scope this variable is declared in. */
  final VariableScope getDeclaringScope() { result = self.getDeclaringScope() }

  /** Gets an access to this variable. */
  VariableAccess getAnAccess() { result.getVariable() = this }
}

/** A local variable. */
class LocalVariable extends Variable {
  override LocalVariableRange self;

  final override LocalVariableAccess getAnAccess() { result.getVariable() = this }
}

/** An access to a variable. */
class VariableAccess extends AstNode, @token_identifier {
  override Generated::Identifier generated;
  Variable variable;

  VariableAccess() { access(this, variable) }

  /** Gets the variable this identifier refers to. */
  Variable getVariable() { result = variable }

  final override string toString() { result = variable.getName() }
}

/** An access to a local variable. */
class LocalVariableAccess extends VariableAccess {
  override LocalVariable variable;

  override LocalVariable getVariable() { result = variable }
}

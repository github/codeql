/** Provides classes for modeling program variables. */

import codeql_ruby.AST
private import codeql_ruby.Generated
private import codeql.Locations
private import internal.Variable

/** A scope in which variables can be declared. */
class VariableScope extends TScope {
  /** Gets a textual representation of this element. */
  string toString() { none() }

  /** Gets the program element this scope is associated with, if any. */
  AstNode getScopeElement() { none() }

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

/** A top-level scope. */
class TopLevelScope extends VariableScope, TTopLevelScope {
  final override string toString() { result = "top-level scope" }

  final override AstNode getScopeElement() { TTopLevelScope(result) = this }
}

/** A module scope. */
class ModuleScope extends VariableScope, TModuleScope {
  final override string toString() { result = "module scope" }

  final override AstNode getScopeElement() { TModuleScope(result) = this }
}

/** A class scope. */
class ClassScope extends VariableScope, TClassScope {
  final override string toString() { result = "class scope" }

  final override AstNode getScopeElement() { TClassScope(result) = this }
}

/** A callable scope. */
class CallableScope extends VariableScope, TCallableScope {
  private Callable c;

  CallableScope() { this = TCallableScope(c) }

  final override string toString() {
    (c instanceof Method or c instanceof SingletonMethod) and
    result = "method scope"
    or
    c instanceof Lambda and
    result = "lambda scope"
    or
    c instanceof Block and
    result = "block scope"
  }

  final override Callable getScopeElement() { TCallableScope(result) = this }
}

/** A variable declared in a scope. */
class Variable extends TVariable {
  /** Gets the name of this variable. */
  string getName() { none() }

  /** Gets a textual representation of this variable. */
  final string toString() { result = this.getName() }

  /** Gets the location of this variable. */
  Location getLocation() { none() }

  /** Gets the scope this variable is declared in. */
  VariableScope getDeclaringScope() { none() }

  /** Gets an access to this variable. */
  VariableAccess getAnAccess() { result.getVariable() = this }
}

/** A local variable. */
class LocalVariable extends Variable {
  private VariableScope scope;
  private string name;
  private Generated::Identifier i;

  LocalVariable() { this = TLocalVariable(scope, name, i) }

  final override string getName() { result = name }

  final override Location getLocation() { result = i.getLocation() }

  final override VariableScope getDeclaringScope() { result = scope }

  final override LocalVariableAccess getAnAccess() { result.getVariable() = this }
}

/** An access to a variable. */
class VariableAccess extends AstNode, @token_identifier {
  override Generated::Identifier generated;
  Variable variable;

  VariableAccess() { access(this, variable) }

  /** Gets the variable this identifier refers to. */
  Variable getVariable() { result = variable }

  override string toString() { result = variable.getName() }
}

/** An access to a local variable. */
class LocalVariableAccess extends VariableAccess {
  override LocalVariable variable;

  override LocalVariable getVariable() { result = variable }

  override string toString() { result = variable.getName() }
}

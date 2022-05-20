private import codeql.ruby.AST
private import internal.AST
private import internal.Scope
private import internal.TreeSitter

/**
 * A variable scope. This is either a top-level (file), a module, a class,
 * or a callable.
 */
class Scope extends AstNode, TScopeType instanceof ScopeImpl {
  /** Gets the outer scope, if any. */
  Scope getOuterScope() { result = super.getOuterScopeImpl() }

  /** Gets a variable declared in this scope. */
  Variable getAVariable() { result = super.getAVariableImpl() }

  /** Gets the variable named `name` declared in this scope. */
  Variable getVariable(string name) { result = super.getVariableImpl(name) }
}

/** A scope in which a `self` variable exists. */
class SelfScope extends Scope, TSelfScopeType { }

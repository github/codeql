private import codeql_ruby.AST
private import internal.Scope

class Scope extends AstNode, Scope::ScopeType {
  override Scope::Range range;

  AstNode getADescendant() { result = range.getADescendant() }

  ModuleBase getEnclosingModule() { result = range.getEnclosingModule() }

  MethodBase getEnclosingMethod() { result = range.getEnclosingMethod() }

  /** Gets the scope in which this scope is nested, if any. */
  Scope getOuterScope() { result = range.getOuterScope() }

  /** Gets a variable that is declared in this scope. */
  final Variable getAVariable() { result.getDeclaringScope() = this }

  /** Gets the variable declared in this scope with the given name, if any. */
  final Variable getVariable(string name) {
    result = this.getAVariable() and
    result.getName() = name
  }
}

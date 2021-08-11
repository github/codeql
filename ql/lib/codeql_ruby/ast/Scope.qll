private import codeql_ruby.AST
private import internal.AST
private import internal.Scope
private import internal.TreeSitter

class Scope extends AstNode, TScopeType {
  private Scope::Range range;

  Scope() { range = toGenerated(this) }

  /** Gets the scope in which this scope is nested, if any. */
  Scope getOuterScope() { toGenerated(result) = range.getOuterScope() }

  /** Gets a variable that is declared in this scope. */
  final Variable getAVariable() { result.getDeclaringScope() = this }

  /** Gets the variable declared in this scope with the given name, if any. */
  final Variable getVariable(string name) {
    result = this.getAVariable() and
    result.getName() = name
  }
}

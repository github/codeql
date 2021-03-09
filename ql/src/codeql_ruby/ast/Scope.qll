private import codeql_ruby.AST
private import internal.Scope

class Scope extends AstNode, Scope::ScopeType {
  override Scope::Range range;

  AstNode getADescendant() { result = range.getADescendant() }

  ModuleBase getEnclosingModule() { result = range.getEnclosingModule() }

  MethodBase getEnclosingMethod() { result = range.getEnclosingMethod() }

  /** Gets the scope in which this scope is nested, if any. */
  Scope getOuterScope() { result = range.getOuterScope() }
}

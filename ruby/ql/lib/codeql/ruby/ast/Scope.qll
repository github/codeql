private import codeql.ruby.AST
private import internal.AST
private import internal.Scope
private import internal.TreeSitter

class Scope extends AstNode, TScopeType instanceof ScopeImpl {
  Scope getOuterScope() { result = super.getOuterScopeImpl() }

  Variable getAVariable() { result = super.getAVariableImpl() }

  Variable getVariable(string name) { result = super.getVariableImpl(name) }
}

class SelfScope extends Scope, TSelfScopeType { }

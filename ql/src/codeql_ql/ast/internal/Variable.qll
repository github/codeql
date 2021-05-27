import ql
import codeql_ql.ast.internal.AstNodes

private class TScope =
  TClass or TAggregate or TQuantifier or TSelect or TPredicate or TNewTypeBranch;

/** A variable scope. */
class VariableScope extends TScope, AstNode {
  /** Gets the outer scope, if any. */
  VariableScope getOuterScope() { result = scopeOf(this) }

  /** Gets a variable declared directly in this scope. */
  VarDecl getADeclaration() { result.getParent() = this }

  /** Holds if this scope contains declaration `decl`, either directly or inherited. */
  predicate contains(VarDecl decl) {
    decl = this.getADeclaration()
    or
    this.getOuterScope().contains(decl) and
    not this.getADeclaration().getName() = decl.getName()
  }
}

private AstNode parent(AstNode child) {
  result = child.getParent() and
  not child instanceof VariableScope
}

VariableScope scopeOf(AstNode n) { result = parent*(n.getParent()) }

predicate resolveVariable(Identifier i, VarDecl decl) {
  scopeOf(i).contains(decl) and
  decl.getName() = i.getName()
}

module VarConsistency {
  query predicate multipleVarDecls(VarAccess v, VarDecl decl) {
    decl = v.getDeclaration() and
    strictcount(v.getDeclaration()) > 1
  }
}

import ql
private import codeql_ql.ast.internal.AstNodes

private class TScope =
  TClass or TAggregate or TQuantifier or TSelect or TPredicate or TNewTypeBranch;

/** A variable scope. */
class VariableScope extends TScope, AstNode {
  /** Gets the outer scope, if any. */
  VariableScope getOuterScope() { result = scopeOf(this) }

  /** Gets a variable declared directly in this scope. */
  VarDef getADefinition(string name) {
    result.getParent() = this and
    name = result.getName()
  }

  /** Holds if this scope contains variable `decl`, either directly or inherited. */
  predicate containsVar(VarDef decl, string name) {
    name = decl.getName() and
    (
      not this instanceof Class and
      decl = this.getADefinition(name)
      or
      decl = this.(Select).getExpr(_).(AsExpr)
      or
      decl = this.(FullAggregate).getExpr(_).(AsExpr)
      or
      decl = this.(ExprAggregate).getExpr(_).(AsExpr)
      or
      this.getOuterScope().containsVar(decl, name) and
      not exists(this.getADefinition(name))
    )
  }

  /** Holds if this scope contains field `decl`, either directly or inherited. */
  predicate containsField(VarDef decl, string name) {
    name = decl.getName() and
    (
      decl = this.(Class).getAField().getVarDecl()
      or
      this.getOuterScope().containsField(decl, name) and
      not exists(this.getADefinition(name))
      or
      exists(VariableScope sup |
        sup = this.(Class).getASuperType().getResolvedType().(ClassType).getDeclaration() and
        sup.containsField(decl, name) and
        not this.(Class).getAField().getName() = name
      )
    )
  }
}

private AstNode parent(AstNode child) {
  result = child.getParent() and
  not child instanceof VariableScope
}

pragma[nomagic]
VariableScope scopeOf(AstNode n) { result = parent*(n.getParent()) }

private string getName(Identifier i) {
  exists(QL::Variable v |
    i = TIdentifier(v) and
    result = v.getChild().(QL::VarName).getChild().getValue()
  )
}

cached
private module Cached {
  cached
  predicate resolveVariable(Identifier i, VarDef decl) { scopeOf(i).containsVar(decl, getName(i)) }

  cached
  predicate resolveField(Identifier i, VarDef decl) {
    scopeOf(i).containsField(decl, pragma[only_bind_into](getName(i)))
  }
}

import Cached

module VarConsistency {
  query predicate multipleVarDefs(VarAccess v, VarDef decl) {
    decl = v.getDeclaration() and
    strictcount(v.getDeclaration()) > 1
  }

  query predicate multipleFieldDefs(FieldAccess f, FieldDecl decl) {
    decl = f.getDeclaration() and
    strictcount(f.getDeclaration()) > 1
  }

  query predicate noFieldDef(FieldAccess f) { not exists(f.getDeclaration()) }

  query predicate noVarDef(VarAccess v) { not exists(v.getDeclaration()) }
}

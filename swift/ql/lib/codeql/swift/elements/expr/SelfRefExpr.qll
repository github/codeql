private import codeql.swift.elements.expr.DeclRefExpr
private import codeql.swift.elements.decl.MethodDecl
private import codeql.swift.elements.decl.VarDecl

/** A reference to `self`. */
class SelfRefExpr extends DeclRefExpr {
  MethodDecl methodDecl;

  SelfRefExpr() { this.getDecl() = methodDecl.getSelfParam() }

  VarDecl getSelf() { result = this.getDecl() }

  MethodDecl getDeclaringMethod() { result = methodDecl }
}

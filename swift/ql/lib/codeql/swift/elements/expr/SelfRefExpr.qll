private import codeql.swift.elements.expr.DeclRefExpr
private import codeql.swift.elements.decl.Method
private import codeql.swift.elements.decl.VarDecl

/** A reference to `self`. */
final class SelfRefExpr extends DeclRefExpr {
  Method method;

  SelfRefExpr() { this.getDecl() = method.getSelfParam() }

  VarDecl getSelf() { result = this.getDecl() }

  Method getDeclaringMethod() { result = method }
}

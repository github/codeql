private import codeql.swift.generated.expr.SuperRefExpr
private import codeql.swift.elements.decl.MethodDecl

/** A reference to `super`. */
class SuperRefExpr extends Generated::SuperRefExpr {
  override string toString() { result = "super" }

  MethodDecl getDeclaringMethod() { this.getSelf() = result.getSelfParam() }
}

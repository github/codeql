private import codeql.swift.generated.expr.DotSyntaxBaseIgnoredExpr
private import codeql.swift.elements.expr.AutoClosureExpr
private import codeql.swift.elements.expr.CallExpr
private import codeql.swift.elements.expr.TypeExpr
private import codeql.swift.elements.decl.MethodDecl

class DotSyntaxBaseIgnoredExpr extends Generated::DotSyntaxBaseIgnoredExpr {
  override string toString() {
    result =
      concat(this.getQualifier().(TypeExpr).getTypeRepr().toString()) + "." + this.getMethod()
  }

  /**
   * Gets the underlying instance method that is called when the result of this
   * expression is fully applied.
   */
  MethodDecl getMethod() {
    result =
      this.getSubExpr()
          .(AutoClosureExpr)
          .getExpr()
          .(AutoClosureExpr)
          .getExpr()
          .(CallExpr)
          .getStaticTarget()
  }
}

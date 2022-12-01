private import codeql.swift.generated.expr.ApplyExpr
private import codeql.swift.elements.Callable
private import codeql.swift.elements.expr.DeclRefExpr
private import codeql.swift.elements.expr.MethodLookupExpr
private import codeql.swift.elements.expr.ConstructorRefCallExpr
private import codeql.swift.elements.decl.MethodDecl

class ApplyExpr extends Generated::ApplyExpr {
  Callable getStaticTarget() {
    exists(Expr f |
      f = this.getFunction() and
      (
        result = f.(DeclRefExpr).getDecl()
        or
        result = f.(ConstructorRefCallExpr).getFunction().(DeclRefExpr).getDecl() // TODO: fix this
      )
    )
  }

  /** Gets the method qualifier, if this is applying a method */
  Expr getQualifier() { none() }

  /**
   * Gets the argument of this `ApplyExpr` called `label` (if any).
   */
  final Argument getArgumentWithLabel(string label) {
    result = this.getAnArgument() and
    result.getLabel() = label
  }

  override string toString() {
    result = "call to " + this.getStaticTarget().toString()
    or
    not exists(this.getStaticTarget()) and
    result = "call to ..."
  }
}

class MethodApplyExpr extends ApplyExpr {
  private MethodLookupExpr method;

  MethodApplyExpr() { method = this.getFunction() }

  override MethodDecl getStaticTarget() { result = method.getMethod() }

  override Expr getQualifier() { result = method.getBase() }
}

private import codeql.swift.generated.expr.ApplyExpr
private import codeql.swift.elements.Callable
private import codeql.swift.elements.expr.DeclRefExpr
private import codeql.swift.elements.expr.MethodLookupExpr
private import codeql.swift.elements.expr.DotSyntaxBaseIgnoredExpr
private import codeql.swift.elements.expr.AutoClosureExpr
private import codeql.swift.elements.decl.Method

module Impl {
  class ApplyExpr extends Generated::ApplyExpr {
    Callable getStaticTarget() { result = this.getFunction().(DeclRefExpr).getDecl() }

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

    override Method getStaticTarget() { result = method.getMethod() }

    override Expr getQualifier() { result = method.getBase() }
  }

  private class PartialDotSyntaxBaseIgnoredApplyExpr extends ApplyExpr {
    private DotSyntaxBaseIgnoredExpr expr;

    PartialDotSyntaxBaseIgnoredApplyExpr() { expr = this.getFunction() }

    override AutoClosureExpr getStaticTarget() { result = expr.getSubExpr() }

    override Expr getQualifier() { result = expr.getQualifier() }

    override string toString() { result = "call to " + expr }
  }

  private class FullDotSyntaxBaseIgnoredApplyExpr extends ApplyExpr {
    private PartialDotSyntaxBaseIgnoredApplyExpr expr;

    FullDotSyntaxBaseIgnoredApplyExpr() { expr = this.getFunction() }

    override AutoClosureExpr getStaticTarget() { result = expr.getStaticTarget().getExpr() }
  }
}

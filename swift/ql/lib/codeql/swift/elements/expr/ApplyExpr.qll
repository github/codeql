private import codeql.swift.generated.expr.ApplyExpr
private import codeql.swift.elements.decl.AbstractFunctionDecl
private import codeql.swift.elements.expr.DeclRefExpr
private import codeql.swift.elements.expr.MethodRefExpr
private import codeql.swift.elements.expr.ConstructorRefCallExpr

class ApplyExpr extends Generated::ApplyExpr {
  AbstractFunctionDecl getStaticTarget() {
    exists(Expr f |
      f = this.getFunction() and
      (
        result = f.(DeclRefExpr).getDecl()
        or
        result = f.(ConstructorRefCallExpr).getFunction().(DeclRefExpr).getDecl()
      )
    )
  }

  /** Gets the method qualifier, if this is applying a method */
  Expr getQualifier() { none() }

  /**
   * Gets the argument that has corresponding parameter name `paramName` (if
   * any). If this call does not have a static target, there will be no result.
   */
  final Argument getArgumentByParamName(string paramName) {
    exists(int arg |
      this.getStaticTarget().getParam(pragma[only_bind_into](arg)).getName() = paramName and
      this.getArgument(pragma[only_bind_into](arg)) = result
    )
  }

  override string toString() {
    result = "call to " + this.getStaticTarget().toString()
    or
    not exists(this.getStaticTarget()) and
    result = "call to ..."
  }
}

class MethodApplyExpr extends ApplyExpr {
  private MethodRefExpr method;

  MethodApplyExpr() { method = this.getFunction() }

  override AbstractFunctionDecl getStaticTarget() { result = method.getMethod() }

  override Expr getQualifier() { result = method.getBase() }
}

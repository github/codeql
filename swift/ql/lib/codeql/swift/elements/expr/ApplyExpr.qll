private import codeql.swift.generated.expr.ApplyExpr
private import codeql.swift.elements.decl.AbstractFunctionDecl
private import codeql.swift.elements.expr.DeclRefExpr

class ApplyExpr extends ApplyExprBase {
  AbstractFunctionDecl getStaticTarget() { result = this.getFunction().(DeclRefExpr).getDecl() }

  override string toString() {
    result = "call to " + this.getStaticTarget().toString()
    or
    not exists(this.getStaticTarget()) and
    result = "call to " + this.getFunction().toString()
    or
    not exists(this.getFunction()) and // (this implies there is no `getStaticTarget` either)
    result = "call to ..."
  }
}

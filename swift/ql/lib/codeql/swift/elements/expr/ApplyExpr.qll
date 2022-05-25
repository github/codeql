private import codeql.swift.generated.expr.ApplyExpr
private import codeql.swift.elements.decl.FuncDecl
private import codeql.swift.elements.expr.DeclRefExpr

class ApplyExpr extends ApplyExprBase {
  FuncDecl getStaticTarget() { result = this.getFunction().(DeclRefExpr).getDecl() }

  override string toString() {
    result = "call to " + this.getStaticTarget().toString()
    or
    not exists(this.getStaticTarget()) and
    result = "call to ..."
  }
}

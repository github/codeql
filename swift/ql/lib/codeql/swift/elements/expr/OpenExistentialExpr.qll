private import codeql.swift.generated.expr.OpenExistentialExpr

class OpenExistentialExpr extends Generated::OpenExistentialExpr {
  override predicate convertsFrom(Expr e) { e = this.getImmediateSubExpr() }
}

private import codeql.swift.generated.expr.IfExpr

class IfExpr extends Generated::IfExpr {
  Expr getBranch(boolean b) {
    b = true and
    result = this.getThenExpr()
    or
    b = false and
    result = this.getElseExpr()
  }

  override string toString() { result = "... ? ... : ..." }
}

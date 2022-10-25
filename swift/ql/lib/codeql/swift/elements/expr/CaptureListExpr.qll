private import codeql.swift.generated.expr.CaptureListExpr

class CaptureListExpr extends Generated::CaptureListExpr {
  override string toString() { result = this.getClosureBody().toString() }
}

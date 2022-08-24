private import codeql.swift.generated.expr.CaptureListExpr

class CaptureListExpr extends CaptureListExprBase {
  override string toString() { result = this.getClosureBody().toString() }
}

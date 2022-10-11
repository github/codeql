private import codeql.swift.generated.expr.TupleExpr

class TupleExpr extends TupleExprBase {
  override string toString() { result = "(...)" }
}

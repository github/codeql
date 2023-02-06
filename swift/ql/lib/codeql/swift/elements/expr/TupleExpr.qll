private import codeql.swift.generated.expr.TupleExpr

class TupleExpr extends Generated::TupleExpr {
  override string toString() { result = "(...)" }
}

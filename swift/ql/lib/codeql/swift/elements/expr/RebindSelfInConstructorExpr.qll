private import codeql.swift.generated.expr.RebindSelfInConstructorExpr

class RebindSelfInConstructorExpr extends RebindSelfInConstructorExprBase {
  override string toString() { result = "self = ..." }
}

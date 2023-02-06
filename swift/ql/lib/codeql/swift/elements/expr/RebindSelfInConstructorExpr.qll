private import codeql.swift.generated.expr.RebindSelfInConstructorExpr

class RebindSelfInConstructorExpr extends Generated::RebindSelfInConstructorExpr {
  override string toString() { result = "self = ..." }
}

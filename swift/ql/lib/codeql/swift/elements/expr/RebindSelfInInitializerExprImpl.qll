private import codeql.swift.generated.expr.RebindSelfInInitializerExpr

class RebindSelfInInitializerExpr extends Generated::RebindSelfInInitializerExpr {
  override string toString() { result = "self = ..." }
}

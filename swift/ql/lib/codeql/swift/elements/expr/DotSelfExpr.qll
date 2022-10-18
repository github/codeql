private import codeql.swift.generated.expr.DotSelfExpr

class DotSelfExpr extends Generated::DotSelfExpr {
  override string toString() { result = ".self" }
}

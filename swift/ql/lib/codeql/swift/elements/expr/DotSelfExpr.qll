private import codeql.swift.generated.expr.DotSelfExpr

class DotSelfExpr extends DotSelfExprBase {
  override string toString() { result = ".self" }
}

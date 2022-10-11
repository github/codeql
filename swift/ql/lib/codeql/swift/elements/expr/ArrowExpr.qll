private import codeql.swift.generated.expr.ArrowExpr

class ArrowExpr extends ArrowExprBase {
  override string toString() { result = "... -> ..." }
}

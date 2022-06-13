private import codeql.swift.generated.expr.ArrayExpr

class ArrayExpr extends ArrayExprBase {
  override string toString() { result = "[...]" }
}

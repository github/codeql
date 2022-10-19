private import codeql.swift.generated.expr.ArrayExpr

class ArrayExpr extends Generated::ArrayExpr {
  override string toString() { result = "[...]" }
}

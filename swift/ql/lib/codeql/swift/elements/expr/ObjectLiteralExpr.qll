private import codeql.swift.generated.expr.ObjectLiteralExpr

class ObjectLiteralExpr extends Generated::ObjectLiteralExpr {
  override string toString() {
    result = "#...(...)" // TOOD: We can improve this once we extract the kind
  }
}

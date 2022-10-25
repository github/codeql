private import codeql.swift.generated.expr.DynamicTypeExpr

class DynamicTypeExpr extends Generated::DynamicTypeExpr {
  override string toString() { result = "type(of: ...)" }
}

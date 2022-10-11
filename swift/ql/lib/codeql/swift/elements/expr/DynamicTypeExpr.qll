private import codeql.swift.generated.expr.DynamicTypeExpr

class DynamicTypeExpr extends DynamicTypeExprBase {
  override string toString() { result = "type(of: ...)" }
}

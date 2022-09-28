private import codeql.swift.generated.expr.ObjCSelectorExpr

class ObjCSelectorExpr extends ObjCSelectorExprBase {
  override string toString() { result = "#selector(...)" }
}

private import codeql.swift.generated.expr.ObjCSelectorExpr

class ObjCSelectorExpr extends Generated::ObjCSelectorExpr {
  override string toString() { result = "#selector(...)" }
}

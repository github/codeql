private import codeql.swift.generated.expr.VarargExpansionExpr

class VarargExpansionExpr extends VarargExpansionExprBase {
  override string toString() { result = this.getSubExpr().toString() }
}

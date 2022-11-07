private import codeql.swift.generated.expr.VarargExpansionExpr

class VarargExpansionExpr extends Generated::VarargExpansionExpr {
  override string toString() { result = this.getSubExpr().toString() }
}

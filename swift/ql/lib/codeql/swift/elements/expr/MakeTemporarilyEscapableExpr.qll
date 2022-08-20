private import codeql.swift.generated.expr.MakeTemporarilyEscapableExpr

class MakeTemporarilyEscapableExpr extends MakeTemporarilyEscapableExprBase {
  override string toString() { result = this.getSubExpr().toString() }
}

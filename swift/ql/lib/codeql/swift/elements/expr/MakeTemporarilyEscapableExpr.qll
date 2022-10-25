private import codeql.swift.generated.expr.MakeTemporarilyEscapableExpr

class MakeTemporarilyEscapableExpr extends Generated::MakeTemporarilyEscapableExpr {
  override string toString() { result = this.getSubExpr().toString() }
}

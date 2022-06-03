private import codeql.swift.generated.expr.TupleElementExpr

class TupleElementExpr extends TupleElementExprBase {
  override string toString() {
    result = "." + this.getIndex() // TODO: Can be improved once we extract the name
  }
}

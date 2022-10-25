private import codeql.swift.generated.expr.TupleElementExpr

class TupleElementExpr extends Generated::TupleElementExpr {
  override string toString() {
    result = "." + this.getIndex() // TODO: Can be improved once we extract the name
  }
}

private import codeql.swift.generated.expr.Argument

class Argument extends ArgumentBase {
  override string toString() { result = this.getLabel() + ": " + this.getExpr().toString() }
}

private import codeql.swift.generated.expr.Argument
private import codeql.swift.elements.expr.ApplyExpr

class Argument extends ArgumentBase {
  override string toString() { result = this.getLabel() + ": " + this.getExpr().toString() }

  int getIndex() { any(ApplyExpr apply).getArgument(result) = this }
}

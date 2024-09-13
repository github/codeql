private import codeql.swift.generated.expr.EnumIsCaseExpr

class EnumIsCaseExpr extends Generated::EnumIsCaseExpr {
  override string toString() { result = "... is " + this.getElement().toString() }
}

private import codeql.swift.generated.expr.EnumIsCaseExpr

class EnumIsCaseExpr extends EnumIsCaseExprBase {
  override string toString() { result = "... is " + this.getElement().toString() }
}

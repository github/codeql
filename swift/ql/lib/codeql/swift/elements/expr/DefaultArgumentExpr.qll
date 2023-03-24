private import codeql.swift.generated.expr.DefaultArgumentExpr

class DefaultArgumentExpr extends Generated::DefaultArgumentExpr {
  override string toString() { result = "default " + this.getParamDecl().getName() }
}

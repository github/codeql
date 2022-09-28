private import codeql.swift.generated.expr.DefaultArgumentExpr

class DefaultArgumentExpr extends DefaultArgumentExprBase {
  override string toString() { result = "default " + this.getParamDecl().getName() }
}

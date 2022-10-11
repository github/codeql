private import codeql.swift.generated.expr.LazyInitializerExpr

class LazyInitializerExpr extends LazyInitializerExprBase {
  override string toString() { result = this.getSubExpr().toString() }
}

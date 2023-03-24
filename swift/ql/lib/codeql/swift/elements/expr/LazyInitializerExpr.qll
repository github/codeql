private import codeql.swift.generated.expr.LazyInitializerExpr

class LazyInitializerExpr extends Generated::LazyInitializerExpr {
  override string toString() { result = this.getSubExpr().toString() }
}

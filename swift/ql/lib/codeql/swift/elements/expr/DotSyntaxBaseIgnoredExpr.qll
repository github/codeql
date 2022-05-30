private import codeql.swift.generated.expr.DotSyntaxBaseIgnoredExpr

class DotSyntaxBaseIgnoredExpr extends DotSyntaxBaseIgnoredExprBase {
  override string toString() { result = "." + this.getSubExpr().toString() }
}

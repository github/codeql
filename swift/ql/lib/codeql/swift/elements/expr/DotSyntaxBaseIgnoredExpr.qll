private import codeql.swift.generated.expr.DotSyntaxBaseIgnoredExpr

class DotSyntaxBaseIgnoredExpr extends Generated::DotSyntaxBaseIgnoredExpr {
  override string toString() { result = "." + this.getSubExpr().toString() }
}

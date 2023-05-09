private import codeql.swift.generated.expr.RegexLiteralExpr

class RegexLiteralExpr extends Generated::RegexLiteralExpr {
  override string toString() { result = this.getPattern() }
}

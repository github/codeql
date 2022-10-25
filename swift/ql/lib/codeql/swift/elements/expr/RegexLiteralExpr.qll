private import codeql.swift.generated.expr.RegexLiteralExpr

class RegexLiteralExpr extends Generated::RegexLiteralExpr {
  override string toString() {
    result = "..." // TODO: We can improve this once we extract the regex
  }
}

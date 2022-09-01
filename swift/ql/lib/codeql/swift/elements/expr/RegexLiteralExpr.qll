private import codeql.swift.generated.expr.RegexLiteralExpr

class RegexLiteralExpr extends RegexLiteralExprBase {
  override string toString() {
    result = "..." // TODO: We can improve this once we extract the regex
  }
}

private import codeql.swift.generated.expr.MagicIdentifierLiteralExpr

class MagicIdentifierLiteralExpr extends MagicIdentifierLiteralExprBase {
  override string toString() { result = "#..." }
}

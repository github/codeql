private import codeql.swift.generated.expr.MagicIdentifierLiteralExpr

class MagicIdentifierLiteralExpr extends Generated::MagicIdentifierLiteralExpr {
  override string toString() { result = "#..." }
}

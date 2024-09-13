private import codeql.swift.generated.expr.MagicIdentifierLiteralExpr

module Impl {
  /**
   * An identifier literal that is expanded at compile time. For example `#file` in:
   * ```
   * let x = #file
   * ```
   */
  class MagicIdentifierLiteralExpr extends Generated::MagicIdentifierLiteralExpr {
    override string toString() { result = "#..." }

    override string getValueString() { none() } // TODO: value not yet extracted
  }
}

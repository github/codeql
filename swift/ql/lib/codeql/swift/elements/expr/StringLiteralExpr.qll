private import codeql.swift.generated.expr.StringLiteralExpr

/**
 * A string literal. For example `"abc"` in:
 * ```
 * let x = "abc"
 * ```
 */
class StringLiteralExpr extends Generated::StringLiteralExpr {
  override string toString() { result = this.getValue() }

  override string getValueString() { result = this.getValue() }
}

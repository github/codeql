private import codeql.swift.generated.expr.IntegerLiteralExpr

/**
 * An integer literal. For example `1` in:
 * ```
 * let x = 1
 * ```
 */
class IntegerLiteralExpr extends Generated::IntegerLiteralExpr {
  override string toString() { result = this.getStringValue() }

  override string getValueString() { result = this.getStringValue() }
}

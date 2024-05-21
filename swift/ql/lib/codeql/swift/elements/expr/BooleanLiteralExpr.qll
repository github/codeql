private import codeql.swift.generated.expr.BooleanLiteralExpr

/**
 * A boolean literal. For example `true` in:
 * ```
 * let x = true
 * ```
 */
class BooleanLiteralExpr extends Generated::BooleanLiteralExpr {
  override string toString() { result = this.getValue().toString() }

  override string getValueString() { result = this.getValue().toString() }
}

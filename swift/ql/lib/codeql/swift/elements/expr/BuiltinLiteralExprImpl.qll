/**
 * This module provides a hand-modifiable wrapper around the generated class `BuiltinLiteralExpr`.
 */

private import codeql.swift.generated.expr.BuiltinLiteralExpr

module Impl {
  /**
   * A Swift literal of a kind that is built in to the Swift language.
   */
  class BuiltinLiteralExpr extends Generated::BuiltinLiteralExpr {
    /**
     * Gets the value of this literal expression (as a string).
     */
    string getValueString() { none() }
  }
}

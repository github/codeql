/**
 * This module provides a hand-modifiable wrapper around the generated class `LabelableExpr`.
 *
 * INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.LabelableExpr

/**
 * INTERNAL: This module contains the customizable definition of `LabelableExpr` and should not
 * be referenced directly.
 */
module Impl {
  // the following QLdoc is generated: if you need to edit it, do it in the schema file
  /**
   * The base class for expressions that can be labeled (`LoopExpr`, `ForExpr`, `WhileExpr` or `BlockExpr`).
   */
  class LabelableExpr extends Generated::LabelableExpr {
    final override string toString() {
      result = strictconcat(int i | | this.toStringPart(i), " " order by i)
    }

    private string toStringPart(int index) {
      index = 0 and result = this.getLabel().getText() + ":"
      or
      index = 1 and result = this.toStringPrefix()
      or
      index = 2 and result = "{ ... }"
    }

    /**
     * Get the prefix for the string representation of this element.
     *
     * INTERNAL: Do not use.
     */
    string toStringPrefix() { none() }
  }
}

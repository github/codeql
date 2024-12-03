/**
 * This module provides a hand-modifiable wrapper around the generated class `ArrayRepeatExpr`.
 *
 * INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.ArrayRepeatExpr
private import codeql.rust.elements.internal.generated.Raw
private import codeql.rust.elements.internal.generated.Synth

/**
 * INTERNAL: This module contains the customizable definition of `ArrayRepeatExpr` and should not
 * be referenced directly.
 */
module Impl {
  // the following QLdoc is generated: if you need to edit it, do it in the schema file
  /**
   * An array expression with a repeat operand and a repeat length. For example:
   * ```rust
   * [1; 10];
   * ```
   */
  class ArrayRepeatExpr extends Generated::ArrayRepeatExpr {
    override string toString() {
      result =
        "[" + this.getRepeatOperand().toAbbreviatedString() + "; " +
          this.getRepeatLength().toAbbreviatedString() + "]"
    }

    override Expr getRepeatOperand() { result = this.getExpr(0) }

    override Expr getRepeatLength() { result = this.getExpr(1) }
  }
}

/**
 * This module provides a hand-modifiable wrapper around the generated class `ArrayExpr`.
 *
 * INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.ArrayExpr
private import codeql.rust.elements.internal.generated.Raw
private import codeql.rust.elements.internal.generated.Synth

/**
 * INTERNAL: This module contains the customizable definition of `ArrayExpr` and should not
 * be referenced directly.
 */
module Impl {
  // the following QLdoc is generated: if you need to edit it, do it in the schema file
  /**
   * The base class for array expressions. For example:
   * ```rust
   * [1, 2, 3];
   * [1; 10];
   * ```
   */
  class ArrayExpr extends Generated::ArrayExpr {
    pragma[nomagic]
    private Raw::ArrayExprInternal getUnderlyingEntity() {
      this = Synth::TArrayListExpr(result) or this = Synth::TArrayRepeatExpr(result)
    }

    override Expr getExpr(int index) {
      result = Synth::convertExprFromRaw(this.getUnderlyingEntity().getExpr(index))
    }

    override Attr getAttr(int index) {
      result = Synth::convertAttrFromRaw(this.getUnderlyingEntity().getAttr(index))
    }
  }
}

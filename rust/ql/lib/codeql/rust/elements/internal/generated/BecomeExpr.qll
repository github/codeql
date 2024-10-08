// generated by codegen, do not edit
/**
 * This module provides the generated definition of `BecomeExpr`.
 * INTERNAL: Do not import directly.
 */

private import codeql.rust.elements.internal.generated.Synth
private import codeql.rust.elements.internal.generated.Raw
import codeql.rust.elements.Attr
import codeql.rust.elements.Expr
import codeql.rust.elements.internal.ExprImpl::Impl as ExprImpl

/**
 * INTERNAL: This module contains the fully generated definition of `BecomeExpr` and should not
 * be referenced directly.
 */
module Generated {
  /**
   * A `become` expression. For example:
   * ```rust
   * fn fact_a(n: i32, a: i32) -> i32 {
   *      if n == 0 {
   *          a
   *      } else {
   *          become fact_a(n - 1, n * a)
   *      }
   * }
   * ```
   * INTERNAL: Do not reference the `Generated::BecomeExpr` class directly.
   * Use the subclass `BecomeExpr`, where the following predicates are available.
   */
  class BecomeExpr extends Synth::TBecomeExpr, ExprImpl::Expr {
    override string getAPrimaryQlClass() { result = "BecomeExpr" }

    /**
     * Gets the `index`th attr of this become expression (0-based).
     */
    Attr getAttr(int index) {
      result =
        Synth::convertAttrFromRaw(Synth::convertBecomeExprToRaw(this)
              .(Raw::BecomeExpr)
              .getAttr(index))
    }

    /**
     * Gets any of the attrs of this become expression.
     */
    final Attr getAnAttr() { result = this.getAttr(_) }

    /**
     * Gets the number of attrs of this become expression.
     */
    final int getNumberOfAttrs() { result = count(int i | exists(this.getAttr(i))) }

    /**
     * Gets the expression of this become expression, if it exists.
     */
    Expr getExpr() {
      result =
        Synth::convertExprFromRaw(Synth::convertBecomeExprToRaw(this).(Raw::BecomeExpr).getExpr())
    }

    /**
     * Holds if `getExpr()` exists.
     */
    final predicate hasExpr() { exists(this.getExpr()) }
  }
}

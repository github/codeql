/**
 * This module provides a hand-modifiable wrapper around the generated class `MatchExpr`.
 *
 * INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.MatchExpr

/**
 * INTERNAL: This module contains the customizable definition of `MatchExpr` and should not
 * be referenced directly.
 */
module Impl {
  // the following QLdoc is generated: if you need to edit it, do it in the schema file
  /**
   * A match expression. For example:
   * ```rust
   * match x {
   *     Option::Some(y) => y,
   *     Option::None => 0,
   * }
   * ```
   * ```rust
   * match x {
   *     Some(y) if y != 0 => 1 / y,
   *     _ => 0,
   * }
   * ```
   */
  class MatchExpr extends Generated::MatchExpr {
    /**
     * Gets the `index`th arm of this match expression.
     */
    MatchArm getArm(int index) { result = this.getMatchArmList().getArm(index) }

    /**
     * Gets any of the arms of this match expression.
     */
    MatchArm getAnArm() { result = this.getArm(_) }

    /**
     * Gets the number of arms of this match expression.
     */
    int getNumberOfArms() { result = this.getMatchArmList().getNumberOfArms() }
  }
}

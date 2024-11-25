/**
 * This module provides a hand-modifiable wrapper around the generated class `MatchArm`.
 *
 * INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.MatchArm

/**
 * INTERNAL: This module contains the customizable definition of `MatchArm` and should not
 * be referenced directly.
 */
module Impl {
  // the following QLdoc is generated: if you need to edit it, do it in the schema file
  /**
   * A match arm. For example:
   * ```rust
   * match x {
   *     Option::Some(y) => y,
   *     Option::None => 0,
   * };
   * ```
   * ```rust
   * match x {
   *     Some(y) if y != 0 => 1 / y,
   *     _ => 0,
   * };
   * ```
   */
  class MatchArm extends Generated::MatchArm {
    override string toString() { result = concat(int i | | this.toStringPart(i), " " order by i) }

    private string toStringPart(int index) {
      index = 0 and result = this.getPat().toAbbreviatedString()
      or
      index = 1 and result = "if " + this.getGuard().toAbbreviatedString()
      or
      index = 2 and result = "=>"
      or
      index = 3 and result = this.getExpr().toAbbreviatedString()
    }
  }
}

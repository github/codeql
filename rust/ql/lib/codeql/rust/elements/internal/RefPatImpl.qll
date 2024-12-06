/**
 * This module provides a hand-modifiable wrapper around the generated class `RefPat`.
 *
 * INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.RefPat

/**
 * INTERNAL: This module contains the customizable definition of `RefPat` and should not
 * be referenced directly.
 */
module Impl {
  // the following QLdoc is generated: if you need to edit it, do it in the schema file
  /**
   * A reference pattern. For example:
   * ```rust
   * match x {
   *     &mut Option::Some(y) => y,
   *     &Option::None => 0,
   * };
   * ```
   */
  class RefPat extends Generated::RefPat {
    override string toString() {
      result = "&" + concat(int i | | this.getSpecPart(i), " " order by i)
    }

    private string getSpecPart(int index) {
      index = 0 and this.isMut() and result = "mut"
      or
      index = 1 and result = this.getPat().toAbbreviatedString()
    }
  }
}

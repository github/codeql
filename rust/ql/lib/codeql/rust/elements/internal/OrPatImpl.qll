/**
 * This module provides a hand-modifiable wrapper around the generated class `OrPat`.
 *
 * INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.OrPat

/**
 * INTERNAL: This module contains the customizable definition of `OrPat` and should not
 * be referenced directly.
 */
module Impl {
  // the following QLdoc is generated: if you need to edit it, do it in the schema file
  /**
   * An or pattern. For example:
   * ```rust
   * match x {
   *     Option::Some(y) | Option::None => 0,
   * }
   * ```
   */
  class OrPat extends Generated::OrPat {
    override string toString() {
      result = concat(int i | | this.getPat(i).toAbbreviatedString(), " | " order by i)
    }

    /** Gets the last pattern in this or pattern. */
    pragma[nomagic]
    Pat getLastPat() { result = this.getPat(this.getNumberOfPats() - 1) }
  }
}

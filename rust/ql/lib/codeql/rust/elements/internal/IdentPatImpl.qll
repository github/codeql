/**
 * This module provides a hand-modifiable wrapper around the generated class `IdentPat`.
 *
 * INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.IdentPat

/**
 * INTERNAL: This module contains the customizable definition of `IdentPat` and should not
 * be referenced directly.
 */
module Impl {
  // the following QLdoc is generated: if you need to edit it, do it in the schema file
  /**
   * A binding pattern. For example:
   * ```rust
   * match x {
   *     Option::Some(y) => y,
   *     Option::None => 0,
   * };
   * ```
   * ```rust
   * match x {
   *     y@Option::Some(_) => y,
   *     Option::None => 0,
   * };
   * ```
   */
  class IdentPat extends Generated::IdentPat {
    override string toStringImpl() {
      result = strictconcat(int i | | this.toStringPart(i), " " order by i)
    }

    private string toStringPart(int index) {
      index = 0 and this.isRef() and result = "ref"
      or
      index = 1 and this.isMut() and result = "mut"
      or
      index = 2 and result = this.getName().getText()
      or
      index = 3 and this.hasPat() and result = "@ ..."
    }
  }
}

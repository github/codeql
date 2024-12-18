/**
 * This module provides a hand-modifiable wrapper around the generated class `TupleStructPat`.
 *
 * INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.TupleStructPat

/**
 * INTERNAL: This module contains the customizable definition of `TupleStructPat` and should not
 * be referenced directly.
 */
module Impl {
  // the following QLdoc is generated: if you need to edit it, do it in the schema file
  /**
   * A tuple struct pattern. For example:
   * ```rust
   * match x {
   *     Tuple("a", 1, 2, 3) => "great",
   *     Tuple(.., 3) => "fine",
   *     Tuple(..) => "fail",
   * };
   * ```
   */
  class TupleStructPat extends Generated::TupleStructPat {
    override string toString() { result = this.getPath().toAbbreviatedString() + "(...)" }
  }
}

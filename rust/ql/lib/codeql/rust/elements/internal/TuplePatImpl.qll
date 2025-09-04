/**
 * This module provides a hand-modifiable wrapper around the generated class `TuplePat`.
 *
 * INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.TuplePat

/**
 * INTERNAL: This module contains the customizable definition of `TuplePat` and should not
 * be referenced directly.
 */
module Impl {
  private import rust

  // the following QLdoc is generated: if you need to edit it, do it in the schema file
  /**
   * A tuple pattern. For example:
   * ```rust
   * let (x, y) = (1, 2);
   * let (a, b, ..,  z) = (1, 2, 3, 4, 5);
   * ```
   */
  class TuplePat extends Generated::TuplePat {
    /**
     * Gets the arity of the tuple matched by this pattern, if any.
     *
     * This is the number of fields in the tuple pattern if and only if the
     * pattern does not contain a `..` pattern.
     */
    int getTupleArity() {
      result = this.getNumberOfFields() and not this.getAField() instanceof RestPat
    }
  }
}

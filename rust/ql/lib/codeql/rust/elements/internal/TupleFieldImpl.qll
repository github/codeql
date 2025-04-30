/**
 * This module provides a hand-modifiable wrapper around the generated class `TupleField`.
 *
 * INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.TupleField

/**
 * INTERNAL: This module contains the customizable definition of `TupleField` and should not
 * be referenced directly.
 */
module Impl {
  private import rust

  // the following QLdoc is generated: if you need to edit it, do it in the schema file
  /**
   * A TupleField. For example:
   * ```rust
   * todo!()
   * ```
   */
  class TupleField extends Generated::TupleField {
    /** Holds if this tuple field is the `pos`th field of variant `v`. */
    predicate isVariantField(Variant v, int pos) { this = v.getTupleField(pos) }

    /** Holds if this tuple field is the `pos`th field of struct `s`. */
    predicate isStructField(Struct s, int pos) { this = s.getTupleField(pos) }
  }
}

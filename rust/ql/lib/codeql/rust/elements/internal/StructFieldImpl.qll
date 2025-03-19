/**
 * This module provides a hand-modifiable wrapper around the generated class `StructField`.
 *
 * INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.StructField

/**
 * INTERNAL: This module contains the customizable definition of `StructField` and should not
 * be referenced directly.
 */
module Impl {
  private import rust

  // the following QLdoc is generated: if you need to edit it, do it in the schema file
  /**
   * A StructField. For example:
   * ```rust
   * todo!()
   * ```
   */
  class StructField extends Generated::StructField {
    /** Holds if this record field is named `name` and belongs to the variant `v`. */
    predicate isVariantField(Variant v, string name) { this = v.getStructField(name) }

    /** Holds if this record field is named `name` and belongs to the struct `s`. */
    predicate isStructField(Struct s, string name) { this = s.getStructField(name) }
  }
}

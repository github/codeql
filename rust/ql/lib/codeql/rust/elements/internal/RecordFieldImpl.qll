/**
 * This module provides a hand-modifiable wrapper around the generated class `RecordField`.
 *
 * INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.RecordField

/**
 * INTERNAL: This module contains the customizable definition of `RecordField` and should not
 * be referenced directly.
 */
module Impl {
  private import rust

  // the following QLdoc is generated: if you need to edit it, do it in the schema file
  /**
   * A RecordField. For example:
   * ```rust
   * todo!()
   * ```
   */
  class RecordField extends Generated::RecordField {
    /** Holds if this record field is named `name` and belongs to the variant `v`. */
    predicate isVariantField(Variant v, string name) { this = v.getRecordField(name) }

    /** Holds if this record field is named `name` and belongs to the struct `s`. */
    predicate isStructField(Struct s, string name) { this = s.getRecordField(name) }
  }
}

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
   * A field in a struct declaration.
   *
   * For example:
   * ```rust
   * struct S { x: i32 }
   * //         ^^^^^^^
   * ```
   */
  class StructField extends Generated::StructField {
    /** Holds if this record field is named `name` and belongs to the variant `v`. */
    predicate isVariantField(Variant v, string name) { this = v.getStructField(name) }

    /** Holds if this record field is named `name` and belongs to the struct `s`. */
    predicate isStructField(Struct s, string name) { this = s.getStructField(name) }

    override string toStringImpl() {
      result = strictconcat(int i | | this.toStringPart(i) order by i)
    }

    private string toStringPart(int index) {
      index = 0 and result = this.getVisibility().toAbbreviatedString() + " "
      or
      index = 1 and result = this.getName().getText()
      or
      index = 2 and result = ": "
      or
      index = 3 and result = this.getTypeRepr().toAbbreviatedString()
    }
  }
}

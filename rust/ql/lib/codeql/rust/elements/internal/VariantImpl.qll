/**
 * This module provides a hand-modifiable wrapper around the generated class `Variant`.
 *
 * INTERNAL: Do not use.
 */

private import rust
private import codeql.rust.elements.internal.generated.Variant

/**
 * INTERNAL: This module contains the customizable definition of `Variant` and should not
 * be referenced directly.
 */
module Impl {
  // the following QLdoc is generated: if you need to edit it, do it in the schema file
  /**
   * A Variant. For example:
   * ```rust
   * todo!()
   * ```
   */
  class Variant extends Generated::Variant {
    override string toStringImpl() { result = this.getName().getText() }

    /** Gets the record field named `name`, if any. */
    pragma[nomagic]
    RecordField getRecordField(string name) {
      result = this.getFieldList().(RecordFieldList).getAField() and
      result.getName().getText() = name
    }

    /** Gets the `i`th tuple field, if any. */
    pragma[nomagic]
    TupleField getTupleField(int i) { result = this.getFieldList().(TupleFieldList).getField(i) }

    /** Holds if this variant uses tuple fields. */
    pragma[nomagic]
    predicate isTuple() { this.getFieldList() instanceof TupleFieldList }

    /**
     * Holds if this variant uses record fields.
     *
     * Empty variants are considered to use record fields.
     */
    pragma[nomagic]
    predicate isRecord() { not this.isTuple() }

    /** Gets the enum that this variant belongs to. */
    Enum getEnum() { this = result.getVariantList().getAVariant() }
  }
}

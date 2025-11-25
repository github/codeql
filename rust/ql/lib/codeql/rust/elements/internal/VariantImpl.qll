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
   * A variant in an enum declaration.
   *
   * For example:
   * ```rust
   * enum E { A, B(i32), C { x: i32 } }
   * //       ^  ^^^^^^  ^^^^^^^^^^^^
   * ```
   */
  class Variant extends Generated::Variant {
    override string toStringImpl() { result = this.getName().getText() }

    /** Gets the record field named `name`, if any. */
    pragma[nomagic]
    StructField getStructField(string name) {
      result = this.getFieldList().(StructFieldList).getAField() and
      result.getName().getText() = name
    }

    /** Gets the `i`th tuple field, if any. */
    pragma[nomagic]
    TupleField getTupleField(int i) { result = this.getFieldList().(TupleFieldList).getField(i) }

    /** Gets the number of fields of this variant. */
    int getNumberOfFields() {
      not this.hasFieldList() and
      result = 0
      or
      result = this.getFieldList().(StructFieldList).getNumberOfFields()
      or
      result = this.getFieldList().(TupleFieldList).getNumberOfFields()
    }

    /** Holds if this variant uses tuple fields. */
    pragma[nomagic]
    predicate isTuple() { this.getFieldList() instanceof TupleFieldList }

    /** Holds if this variant uses struct fields. */
    pragma[nomagic]
    predicate isStruct() { this.getFieldList() instanceof StructFieldList }

    /** Holds if this variant does not have a field list. */
    pragma[nomagic]
    predicate isUnit() { not this.hasFieldList() }

    /** Gets the enum that this variant belongs to. */
    Enum getEnum() { this = result.getVariantList().getAVariant() }
  }
}

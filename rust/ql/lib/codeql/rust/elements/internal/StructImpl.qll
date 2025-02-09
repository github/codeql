/**
 * This module provides a hand-modifiable wrapper around the generated class `Struct`.
 *
 * INTERNAL: Do not use.
 */

private import rust
private import codeql.rust.elements.internal.generated.Struct

/**
 * INTERNAL: This module contains the customizable definition of `Struct` and should not
 * be referenced directly.
 */
module Impl {
  // the following QLdoc is generated: if you need to edit it, do it in the schema file
  /**
   * A Struct. For example:
   * ```rust
   * todo!()
   * ```
   */
  class Struct extends Generated::Struct {
    override string toString() { result = "struct " + this.getName().getText() }

    /** Gets the record field named `name`, if any. */
    pragma[nomagic]
    RecordField getRecordField(string name) {
      result = this.getFieldList().(RecordFieldList).getAField() and
      result.getName().getText() = name
    }

    /** Gets the `i`th tuple field, if any. */
    pragma[nomagic]
    TupleField getTupleField(int i) { result = this.getFieldList().(TupleFieldList).getField(i) }
  }
}

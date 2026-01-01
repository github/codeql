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
   * struct Point {
   *     x: i32,
   *     y: i32,
   * }
   * ```
   */
  class Struct extends Generated::Struct {
    override string toStringImpl() { result = "struct " + this.getName().getText() }

    /** Gets the record field named `name`, if any. */
    pragma[nomagic]
    StructField getStructField(string name) {
      result = this.getFieldList().(StructFieldList).getAField() and
      result.getName().getText() = name
    }

    /** Gets a record field, if any. */
    StructField getAStructField() { result = this.getStructField(_) }

    /** Gets the `i`th tuple field, if any. */
    pragma[nomagic]
    TupleField getTupleField(int i) { result = this.getFieldList().(TupleFieldList).getField(i) }

    /** Gets a tuple field, if any. */
    TupleField getATupleField() { result = this.getTupleField(_) }

    /** Holds if this struct uses tuple fields. */
    pragma[nomagic]
    predicate isTuple() { this.getFieldList() instanceof TupleFieldList }

    /** Holds if this struct uses struct fields. */
    pragma[nomagic]
    predicate isStruct() { this.getFieldList() instanceof StructFieldList }

    /** Holds if this struct does not have a field list. */
    predicate isUnit() { not this.hasFieldList() }
  }
}

/**
 * This module provides a hand-modifiable wrapper around the generated class `TupleFieldList`.
 *
 * INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.TupleFieldList

/**
 * INTERNAL: This module contains the customizable definition of `TupleFieldList` and should not
 * be referenced directly.
 */
module Impl {
  // the following QLdoc is generated: if you need to edit it, do it in the schema file
  /**
   * A list of fields in a tuple struct or tuple variant.
   *
   * For example:
   * ```rust
   * struct S(i32, String);
   * //      ^^^^^^^^^^^^^
   * ```
   */
  class TupleFieldList extends Generated::TupleFieldList {
    override string toStringImpl() { result = this.getAPrimaryQlClass() }
  }
}

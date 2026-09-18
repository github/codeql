/**
 * This module provides a hand-modifiable wrapper around the generated class `StructExprFieldList`.
 *
 * INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.StructExprFieldList

/**
 * INTERNAL: This module contains the customizable definition of `StructExprFieldList` and should not
 * be referenced directly.
 */
module Impl {
  // the following QLdoc is generated: if you need to edit it, do it in the schema file
  /**
   * A list of fields in a struct expression.
   *
   * For example:
   * ```rust
   * Foo { a: 1, b: 2 }
   * //    ^^^^^^^^^^^
   * ```
   */
  class StructExprFieldList extends Generated::StructExprFieldList {
    override string toStringImpl() { result = this.getAPrimaryQlClass() }
  }
}

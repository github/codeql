/**
 * This module provides a hand-modifiable wrapper around the generated class `ItemList`.
 *
 * INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.ItemList

/**
 * INTERNAL: This module contains the customizable definition of `ItemList` and should not
 * be referenced directly.
 */
module Impl {
  // the following QLdoc is generated: if you need to edit it, do it in the schema file
  /**
   * A list of items in a module or block.
   *
   * For example:
   * ```rust
   * mod m {
   *     fn foo() {}
   *     struct S;
   * }
   * ```
   */
  class ItemList extends Generated::ItemList {
    override string toStringImpl() { result = this.getAPrimaryQlClass() }
  }
}

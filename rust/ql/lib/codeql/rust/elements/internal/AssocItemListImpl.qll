/**
 * This module provides a hand-modifiable wrapper around the generated class `AssocItemList`.
 *
 * INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.AssocItemList

/**
 * INTERNAL: This module contains the customizable definition of `AssocItemList` and should not
 * be referenced directly.
 */
module Impl {
  // the following QLdoc is generated: if you need to edit it, do it in the schema file
  /**
   * A list of `AssocItem` elements, as appearing in a `Trait` or `Impl`.
   */
  class AssocItemList extends Generated::AssocItemList {
    override string toStringImpl() { result = this.getAPrimaryQlClass() }
  }
}

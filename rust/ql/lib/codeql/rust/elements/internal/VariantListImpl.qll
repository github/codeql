/**
 * This module provides a hand-modifiable wrapper around the generated class `VariantList`.
 *
 * INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.VariantList

/**
 * INTERNAL: This module contains the customizable definition of `VariantList` and should not
 * be referenced directly.
 */
module Impl {
  // the following QLdoc is generated: if you need to edit it, do it in the schema file
  /**
   * A list of variants in an enum declaration.
   *
   * For example:
   * ```rust
   * enum E { A, B, C }
   * //     ^^^^^^^^^^^
   * ```
   */
  class VariantList extends Generated::VariantList {
    override string toStringImpl() { result = this.getAPrimaryQlClass() }
  }
}

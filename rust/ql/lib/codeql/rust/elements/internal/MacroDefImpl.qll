/**
 * This module provides a hand-modifiable wrapper around the generated class `MacroDef`.
 *
 * INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.MacroDef

/**
 * INTERNAL: This module contains the customizable definition of `MacroDef` and should not
 * be referenced directly.
 */
module Impl {
  // the following QLdoc is generated: if you need to edit it, do it in the schema file
  /**
   * A Rust 2.0 style declarative macro definition.
   *
   * For example:
   * ```rust
   * pub macro vec_of_two($element:expr) {
   *     vec![$element, $element]
   * }
   * ```
   */
  class MacroDef extends Generated::MacroDef {
    override string toStringImpl() { result = this.getAPrimaryQlClass() }
  }
}

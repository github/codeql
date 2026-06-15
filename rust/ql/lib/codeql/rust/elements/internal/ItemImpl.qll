/**
 * This module provides a hand-modifiable wrapper around the generated class `Item`.
 *
 * INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.Item

/**
 * INTERNAL: This module contains the customizable definition of `Item` and should not
 * be referenced directly.
 */
module Impl {
  // the following QLdoc is generated: if you need to edit it, do it in the schema file
  /**
   * An item such as a function, struct, enum, etc.
   *
   * For example:
   * ```rust
   * fn foo() {}
   * struct S;
   * enum E {}
   * ```
   */
  class Item extends Generated::Item { }

  private class ItemWithAttributeMacroExpansion extends Item {
    ItemWithAttributeMacroExpansion() { this.hasAttributeMacroExpansion() }

    override string toStringImpl() { result = "(item with attribute macro expansion)" }
  }
}

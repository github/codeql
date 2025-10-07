/**
 * This module provides a hand-modifiable wrapper around the generated class `Enum`.
 *
 * INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.Enum

/**
 * INTERNAL: This module contains the customizable definition of `Enum` and should not
 * be referenced directly.
 */
module Impl {
  private import rust

  // the following QLdoc is generated: if you need to edit it, do it in the schema file
  /**
   * An enum declaration.
   *
   * For example:
   * ```rust
   * enum E {A, B(i32), C {x: i32}}
   * ```
   */
  class Enum extends Generated::Enum {
    override string toStringImpl() { result = "enum " + this.getName().getText() }

    /** Gets the variant named `name`, if any. */
    pragma[nomagic]
    Variant getVariant(string name) {
      result = this.getVariantList().getAVariant() and
      result.getName().getText() = name
    }
  }
}

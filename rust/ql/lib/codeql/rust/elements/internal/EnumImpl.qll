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

    /**
     * Holds if this is a field-less enum, that is, an enum where no constructors contain fields.
     *
     * See: https://doc.rust-lang.org/reference/items/enumerations.html#r-items.enum.fieldless
     */
    predicate isFieldless() {
      forall(Variant v | v = this.getVariantList().getAVariant() | v.getNumberOfFields() = 0)
    }

    /**
     * Holds if this is a unit-only enum, that is, an enum where all constructors are unit variants.
     *
     * See: https://doc.rust-lang.org/reference/items/enumerations.html#r-items.enum.unit-only
     */
    predicate isUnitOnly() {
      forall(Variant v | v = this.getVariantList().getAVariant() | v.isUnit())
    }
  }
}

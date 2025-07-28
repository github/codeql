/**
 * This module provides a hand-modifiable wrapper around the generated class `ImplTraitTypeRepr`.
 *
 * INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.ImplTraitTypeRepr
private import rust

/**
 * INTERNAL: This module contains the customizable definition of `ImplTraitTypeRepr` and should not
 * be referenced directly.
 */
module Impl {
  // the following QLdoc is generated: if you need to edit it, do it in the schema file
  /**
   * An `impl Trait` type.
   *
   * For example:
   * ```rust
   * fn foo() -> impl Iterator<Item = i32> { 0..10 }
   * //          ^^^^^^^^^^^^^^^^^^^^^^^^^^
   * ```
   */
  class ImplTraitTypeRepr extends Generated::ImplTraitTypeRepr {
    /** Gets the function for which this impl trait type occurs, if any. */
    Function getFunction() {
      this.getParentNode*() = [result.getRetType().getTypeRepr(), result.getAParam().getTypeRepr()]
    }

    /** Holds if this impl trait type occurs in the return type of a function. */
    predicate isInReturnPos() {
      this.getParentNode*() = this.getFunction().getRetType().getTypeRepr()
    }
  }
}

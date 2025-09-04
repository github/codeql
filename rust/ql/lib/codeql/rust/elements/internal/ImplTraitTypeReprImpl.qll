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
    pragma[nomagic]
    private TypeRepr getFunctionTypeRepr(Function f) {
      this.getParentNode*() = result and
      result = [f.getRetType().getTypeRepr(), f.getAParam().getTypeRepr()]
    }

    /** Gets the function for which this impl trait type occurs, if any. */
    Function getFunction() { exists(this.getFunctionTypeRepr(result)) }

    /** Holds if this impl trait type occurs in the return type of a function. */
    predicate isInReturnPos() {
      exists(Function f | f.getRetType().getTypeRepr() = this.getFunctionTypeRepr(f))
    }
  }
}

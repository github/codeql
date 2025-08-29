/**
 * This module provides a hand-modifiable wrapper around the generated class `Trait`.
 *
 * INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.Trait

/**
 * INTERNAL: This module contains the customizable definition of `Trait` and should not
 * be referenced directly.
 */
module Impl {
  // the following QLdoc is generated: if you need to edit it, do it in the schema file
  /**
   * A Trait. For example:
   * ```
   * trait Frobinizable {
   *   type Frobinator;
   *   type Result: Copy;
   *   fn frobinize_with(&mut self, frobinator: &Self::Frobinator) -> Result;
   * }
   *
   * pub trait Foo<T: Frobinizable> where T::Frobinator: Eq {}
   * ```
   */
  class Trait extends Generated::Trait {
    override string toStringImpl() { result = "trait " + this.getName().getText() }

    /**
     * Gets the number of generic parameters of this trait.
     */
    int getNumberOfGenericParams() {
      result = this.getGenericParamList().getNumberOfGenericParams()
      or
      not this.hasGenericParamList() and
      result = 0
    }

    private int nrOfDirectTypeBounds() {
      result = this.getTypeBoundList().getNumberOfBounds()
      or
      not this.hasTypeBoundList() and
      result = 0
    }

    /**
     * Gets the `index`th type bound of this trait, if any.
     *
     * This includes type bounds directly on the trait and bounds from any
     * `where` clauses for `Self`.
     */
    TypeBound getTypeBound(int index) {
      result = this.getTypeBoundList().getBound(index)
      or
      exists(WherePred wp |
        wp = this.getWhereClause().getAPredicate() and
        wp.getTypeRepr().(PathTypeRepr).getPath().getText() = "Self" and
        result = wp.getTypeBoundList().getBound(index - this.nrOfDirectTypeBounds())
      )
    }

    /**
     * Gets a type bound of this trait.
     *
     * This includes type bounds directly on the trait and bounds from any
     * `where` clauses for `Self`.
     */
    TypeBound getATypeBound() { result = this.getTypeBound(_) }
  }
}

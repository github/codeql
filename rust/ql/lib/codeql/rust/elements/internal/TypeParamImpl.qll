/**
 * This module provides a hand-modifiable wrapper around the generated class `TypeParam`.
 *
 * INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.TypeParam

/**
 * INTERNAL: This module contains the customizable definition of `TypeParam` and should not
 * be referenced directly.
 */
module Impl {
  private import rust
  private import codeql.rust.internal.PathResolution

  // the following QLdoc is generated: if you need to edit it, do it in the schema file
  /**
   * A type parameter in a generic parameter list.
   *
   * For example:
   * ```rust
   * fn foo<T>(t: T) {}
   * //     ^
   * ```
   */
  class TypeParam extends Generated::TypeParam {
    /** Gets the position of this type parameter. */
    int getPosition() { this = any(GenericParamList l).getTypeParam(result) }

    /**
     * Gets the `index`th type bound of this type parameter, if any.
     *
     * This includes type bounds directly on this type parameter and bounds from
     * any `where` clauses for this type parameter.
     */
    TypeBound getTypeBound(int index) {
      result =
        rank[index + 1](int i, int j | | this.(TypeParamItemNode).getTypeBoundAt(i, j) order by i, j)
    }

    /**
     * Gets a type bound of this type parameter.
     *
     * This includes type bounds directly on this type parameter and bounds from
     * any `where` clauses for this type parameter.
     */
    TypeBound getATypeBound() { result = this.getTypeBound(_) }

    override string toAbbreviatedString() { result = this.getName().getText() }

    override string toStringImpl() { result = this.getName().getText() }
  }
}

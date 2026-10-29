/**
 * This module provides a hand-modifiable wrapper around the generated class `GenericParamList`.
 *
 * INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.GenericParamList

/**
 * INTERNAL: This module contains the customizable definition of `GenericParamList` and should not
 * be referenced directly.
 */
module Impl {
  private import rust

  // the following QLdoc is generated: if you need to edit it, do it in the schema file
  /**
   * A list of generic parameters. For example:
   * ```rust
   * fn f<A, B>(a: A, b: B) {}
   * //  ^^^^^^
   * type Foo<T1, T2> = (T1, T2);
   * //      ^^^^^^^^
   * ```
   */
  class GenericParamList extends Generated::GenericParamList {
    override string toStringImpl() { result = this.toAbbreviatedString() }

    override string toAbbreviatedString() { result = "<...>" }

    /** Gets the `i`th type parameter of this list. */
    TypeParam getTypeParam(int i) {
      result = rank[i + 1](TypeParam res, int j | res = this.getGenericParam(j) | res order by j)
    }

    /** Gets a type parameter of this list. */
    TypeParam getATypeParam() { result = this.getTypeParam(_) }
  }
}

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

  // the following QLdoc is generated: if you need to edit it, do it in the schema file
  /**
   * A TypeParam. For example:
   * ```rust
   * todo!()
   * ```
   */
  class TypeParam extends Generated::TypeParam {
    /** Gets the position of this type parameter. */
    int getPosition() { this = any(GenericParamList l).getTypeParam(result) }

    override string toAbbreviatedString() { result = this.getName().getText() }

    override string toString() { result = this.getName().getText() }
  }
}

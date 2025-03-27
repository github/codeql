/**
 * This module provides a hand-modifiable wrapper around the generated class `TypeAlias`.
 *
 * INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.TypeAlias

/**
 * INTERNAL: This module contains the customizable definition of `TypeAlias` and should not
 * be referenced directly.
 */
module Impl {
  // the following QLdoc is generated: if you need to edit it, do it in the schema file
  /**
   * A type alias. For example:
   * ```rust
   * type Point = (u8, u8);
   *
   * trait Trait {
   *     type Output;
   * //  ^^^^^^^^^^^
   * }
   * ```
   */
  class TypeAlias extends Generated::TypeAlias {
    override string toStringImpl() {
      result = concat(int i | | this.toStringPart(i), "" order by i)
    }

    private string toStringPart(int index) {
      index = 0 and result = "type "
      or
      index = 1 and result = this.getName().getText()
      or
      index = 2 and result = this.getGenericParamList().toAbbreviatedString()
    }
  }
}

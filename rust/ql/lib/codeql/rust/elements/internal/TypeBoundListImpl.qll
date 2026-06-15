/**
 * This module provides a hand-modifiable wrapper around the generated class `TypeBoundList`.
 *
 * INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.TypeBoundList

/**
 * INTERNAL: This module contains the customizable definition of `TypeBoundList` and should not
 * be referenced directly.
 */
module Impl {
  // the following QLdoc is generated: if you need to edit it, do it in the schema file
  /**
   * A list of type bounds.
   *
   * For example:
   * ```rust
   * fn foo<T: Debug + Clone>(t: T) {}
   * //        ^^^^^^^^^^^^^
   * ```
   */
  class TypeBoundList extends Generated::TypeBoundList {
    override string toStringImpl() { result = this.toAbbreviatedString() }

    private string toAbbreviatedStringPart(int index) {
      result = this.getBound(index).toAbbreviatedString()
    }

    override string toAbbreviatedString() {
      result = strictconcat(int i | | this.toAbbreviatedStringPart(i), " + " order by i)
    }
  }
}

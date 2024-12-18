/**
 * This module provides a hand-modifiable wrapper around the generated class `Param`.
 *
 * INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.Param

/**
 * INTERNAL: This module contains the customizable definition of `Param` and should not
 * be referenced directly.
 */
module Impl {
  // the following QLdoc is generated: if you need to edit it, do it in the schema file
  /**
   * A parameter in a function or method. For example `x` in:
   * ```rust
   * fn new(x: T) -> Foo<T> {
   *   // ...
   * }
   * ```
   */
  class Param extends Generated::Param {
    override string toString() { result = concat(int i | | this.toStringPart(i) order by i) }

    private string toStringPart(int index) {
      index = 0 and result = this.getPat().toAbbreviatedString()
      or
      index = 1 and result = ": " + this.getTypeRepr().toAbbreviatedString()
    }
  }
}

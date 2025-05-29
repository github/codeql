/**
 * This module provides a hand-modifiable wrapper around the generated class `PathTypeRepr`.
 *
 * INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.PathTypeRepr

/**
 * INTERNAL: This module contains the customizable definition of `PathTypeRepr` and should not
 * be referenced directly.
 */
module Impl {
  // the following QLdoc is generated: if you need to edit it, do it in the schema file
  /**
   * A path referring to a type. For example:
   * ```rust
   * let x: (i32);
   * //      ^^^
   * ```
   */
  class PathTypeRepr extends Generated::PathTypeRepr {
    override string toStringImpl() { result = this.toAbbreviatedString() }

    override string toAbbreviatedString() { result = this.getPath().toAbbreviatedString() }
  }
}

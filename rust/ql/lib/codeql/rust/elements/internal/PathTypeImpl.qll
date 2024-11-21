/**
 * This module provides a hand-modifiable wrapper around the generated class `PathType`.
 *
 * INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.PathType

/**
 * INTERNAL: This module contains the customizable definition of `PathType` and should not
 * be referenced directly.
 */
module Impl {
  // the following QLdoc is generated: if you need to edit it, do it in the schema file
  /**
   * A PathType. For example:
   * ```rust
   * todo!()
   * ```
   */
  class PathType extends Generated::PathType {
    override string toString() { result = this.toAbbreviatedString() }

    override string toAbbreviatedString() {
      result = "<" + this.getPath().toAbbreviatedString() + ">"
    }
  }
}

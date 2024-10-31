/**
 * This module provides a hand-modifiable wrapper around the generated class `PathSegment`.
 *
 * INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.PathSegment

/**
 * INTERNAL: This module contains the customizable definition of `PathSegment` and should not
 * be referenced directly.
 */
module Impl {
  // the following QLdoc is generated: if you need to edit it, do it in the schema file
  /**
   * A PathSegment. For example:
   * ```rust
   * todo!()
   * ```
   */
  class PathSegment extends Generated::PathSegment {
    override string toString() {
      // TODO: this does not cover everything
      if this.hasGenericArgList()
      then result = this.getNameRef().toString() + "::<...>"
      else result = this.getNameRef().toString()
    }
  }
}

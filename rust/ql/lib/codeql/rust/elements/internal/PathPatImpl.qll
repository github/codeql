/**
 * This module provides a hand-modifiable wrapper around the generated class `PathPat`.
 *
 * INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.PathPat

/**
 * INTERNAL: This module contains the customizable definition of `PathPat` and should not
 * be referenced directly.
 */
module Impl {
  // the following QLdoc is generated: if you need to edit it, do it in the schema file
  /**
   * A path pattern. For example:
   * ```rust
   * match x {
   *     Foo::Bar => "ok",
   *     _ => "fail",
   * }
   * ```
   */
  class PathPat extends Generated::PathPat {
    override string toString() { result = this.toAbbreviatedString() }

    override string toAbbreviatedString() { result = this.getPath().toAbbreviatedString() }
  }
}

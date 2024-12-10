/**
 * This module provides a hand-modifiable wrapper around the generated class `RecordPat`.
 *
 * INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.RecordPat

/**
 * INTERNAL: This module contains the customizable definition of `RecordPat` and should not
 * be referenced directly.
 */
module Impl {
  // the following QLdoc is generated: if you need to edit it, do it in the schema file
  /**
   * A record pattern. For example:
   * ```rust
   * match x {
   *     Foo { a: 1, b: 2 } => "ok",
   *     Foo { .. } => "fail",
   * }
   * ```
   */
  class RecordPat extends Generated::RecordPat {
    override string toString() { result = this.getPath().toAbbreviatedString() + " {...}" }
  }
}

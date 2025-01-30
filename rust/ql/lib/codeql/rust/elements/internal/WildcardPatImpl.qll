/**
 * This module provides a hand-modifiable wrapper around the generated class `WildcardPat`.
 *
 * INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.WildcardPat

/**
 * INTERNAL: This module contains the customizable definition of `WildcardPat` and should not
 * be referenced directly.
 */
module Impl {
  // the following QLdoc is generated: if you need to edit it, do it in the schema file
  /**
   * A wildcard pattern. For example:
   * ```rust
   * let _ = 42;
   * ```
   */
  class WildcardPat extends Generated::WildcardPat {
    override string toString() { result = this.toAbbreviatedString() }

    override string toAbbreviatedString() { result = "_" }
  }
}

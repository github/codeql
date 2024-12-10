/**
 * This module provides a hand-modifiable wrapper around the generated class `UnderscoreExpr`.
 *
 * INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.UnderscoreExpr

/**
 * INTERNAL: This module contains the customizable definition of `UnderscoreExpr` and should not
 * be referenced directly.
 */
module Impl {
  // the following QLdoc is generated: if you need to edit it, do it in the schema file
  /**
   * An underscore expression. For example:
   * ```rust
   * _ = 42;
   * ```
   */
  class UnderscoreExpr extends Generated::UnderscoreExpr {
    override string toString() { result = this.toAbbreviatedString() }

    override string toAbbreviatedString() { result = "_" }
  }
}

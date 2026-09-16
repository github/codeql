/**
 * This module provides a hand-modifiable wrapper around the generated class `FormatArgsArg`.
 *
 * INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.FormatArgsArg

/**
 * INTERNAL: This module contains the customizable definition of `FormatArgsArg` and should not
 * be referenced directly.
 */
module Impl {
  // the following QLdoc is generated: if you need to edit it, do it in the schema file
  /**
   * A FormatArgsArg. For example the `"world"` in:
   * ```rust
   * format_args!("Hello, {}!", "world")
   * ```
   */
  class FormatArgsArg extends Generated::FormatArgsArg {
    override string toStringImpl() { result = this.getAPrimaryQlClass() }
  }
}

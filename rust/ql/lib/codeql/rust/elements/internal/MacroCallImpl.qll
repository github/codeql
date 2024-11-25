/**
 * This module provides a hand-modifiable wrapper around the generated class `MacroCall`.
 *
 * INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.MacroCall

/**
 * INTERNAL: This module contains the customizable definition of `MacroCall` and should not
 * be referenced directly.
 */
module Impl {
  // the following QLdoc is generated: if you need to edit it, do it in the schema file
  /**
   * A MacroCall. For example:
   * ```rust
   * todo!()
   * ```
   */
  class MacroCall extends Generated::MacroCall {
    override string toString() { result = this.getPath().toAbbreviatedString() + "!..." }
  }
}

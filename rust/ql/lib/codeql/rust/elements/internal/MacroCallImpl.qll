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
  private import rust
  private import codeql.rust.internal.PathResolution

  // the following QLdoc is generated: if you need to edit it, do it in the schema file
  /**
   * A macro invocation.
   *
   * For example:
   * ```rust
   * println!("Hello, world!");
   * ```
   */
  class MacroCall extends Generated::MacroCall {
    override string toStringImpl() { result = this.getPath().toAbbreviatedString() + "!..." }

    /**
     * Gets the macro definition that this macro call resolves to.
     *
     * The result is either a `MacroDef` or a `MacroRules`.
     */
    Item resolveMacro() { result = resolvePath(this.getPath()) }
  }
}

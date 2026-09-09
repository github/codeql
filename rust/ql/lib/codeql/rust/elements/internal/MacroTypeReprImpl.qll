/**
 * This module provides a hand-modifiable wrapper around the generated class `MacroTypeRepr`.
 *
 * INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.MacroTypeRepr

/**
 * INTERNAL: This module contains the customizable definition of `MacroTypeRepr` and should not
 * be referenced directly.
 */
module Impl {
  // the following QLdoc is generated: if you need to edit it, do it in the schema file
  /**
   * A type produced by a macro.
   *
   * For example:
   * ```rust
   * macro_rules! macro_type {
   *     () => { i32 };
   * }
   * type T = macro_type!();
   * //       ^^^^^^^^^^^^^
   * ```
   */
  class MacroTypeRepr extends Generated::MacroTypeRepr {
    override string toStringImpl() { result = this.getAPrimaryQlClass() }
  }
}

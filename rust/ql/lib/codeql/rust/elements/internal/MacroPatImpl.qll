/**
 * This module provides a hand-modifiable wrapper around the generated class `MacroPat`.
 *
 * INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.MacroPat

/**
 * INTERNAL: This module contains the customizable definition of `MacroPat` and should not
 * be referenced directly.
 */
module Impl {
  // the following QLdoc is generated: if you need to edit it, do it in the schema file
  /**
   * A macro pattern, representing the invocation of a macro that produces a pattern.
   *
   * For example:
   * ```rust
   * macro_rules! my_macro {
   *     () => {
   *         Ok(_)
   *     };
   * }
   * match x {
   *     my_macro!() => "matched",
   * //  ^^^^^^^^^^^
   *     _ => "not matched",
   * }
   * ```
   */
  class MacroPat extends Generated::MacroPat {
    override string toStringImpl() { result = this.getAPrimaryQlClass() }
  }
}

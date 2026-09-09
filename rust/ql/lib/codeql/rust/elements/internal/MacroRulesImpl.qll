/**
 * This module provides a hand-modifiable wrapper around the generated class `MacroRules`.
 *
 * INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.MacroRules

/**
 * INTERNAL: This module contains the customizable definition of `MacroRules` and should not
 * be referenced directly.
 */
module Impl {
  // the following QLdoc is generated: if you need to edit it, do it in the schema file
  /**
   * A macro definition using the `macro_rules!` syntax.
   * ```rust
   * macro_rules! my_macro {
   *     () => {
   *         println!("This is a macro!");
   *     };
   * }
   * ```
   */
  class MacroRules extends Generated::MacroRules {
    override string toStringImpl() { result = this.getAPrimaryQlClass() }
  }
}

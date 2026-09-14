/**
 * This module provides a hand-modifiable wrapper around the generated class `TokenTree`.
 *
 * INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.TokenTree

/**
 * INTERNAL: This module contains the customizable definition of `TokenTree` and should not
 * be referenced directly.
 */
module Impl {
  // the following QLdoc is generated: if you need to edit it, do it in the schema file
  /**
   * A token tree in a macro definition or invocation.
   *
   * For example:
   * ```rust
   * println!("{} {}!", "Hello", "world");
   * //      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^
   * ```
   * ```rust
   * macro_rules! foo { ($x:expr) => { $x + 1 }; }
   * //               ^^^^^^^^^^^^^^^^^^^^^^^^^^^^
   * ```
   */
  class TokenTree extends Generated::TokenTree {
    override string toStringImpl() { result = this.getAPrimaryQlClass() }
  }
}

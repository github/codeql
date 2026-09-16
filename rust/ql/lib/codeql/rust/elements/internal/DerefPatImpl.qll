/**
 * This module provides a hand-modifiable wrapper around the generated class `DerefPat`.
 *
 * INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.DerefPat

/**
 * INTERNAL: This module contains the customizable definition of `DerefPat` and should not
 * be referenced directly.
 */
module Impl {
  // the following QLdoc is generated: if you need to edit it, do it in the schema file
  /**
   * A deref pattern, matching the value behind a smart pointer. This is an experimental
   * Rust feature that cannot be written directly in stable Rust; the example below uses
   * rust-analyzer's canonical `builtin#deref` syntax for such patterns:
   * ```rust
   * match x {
   *     builtin#deref(y) => y,
   *     _ => 0,
   * };
   * ```
   */
  class DerefPat extends Generated::DerefPat {
    override string toStringImpl() { result = this.getAPrimaryQlClass() }
  }
}

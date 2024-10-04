/**
 * This module provides a hand-modifiable wrapper around the generated class `IdentPat`.
 *
 * INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.IdentPat

/**
 * INTERNAL: This module contains the customizable definition of `IdentPat` and should not
 * be referenced directly.
 */
module Impl {
  // the following QLdoc is generated: if you need to edit it, do it in the schema file
  /**
   * A binding pattern. For example:
   * ```rust
   * match x {
   *     Option::Some(y) => y,
   *     Option::None => 0,
   * };
   * ```
   * ```rust
   * match x {
   *     y@Option::Some(_) => y,
   *     Option::None => 0,
   * };
   * ```
   */
  class IdentPat extends Generated::IdentPat {
    override string toString() { result = this.getName().getText() }
  }
}

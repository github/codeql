/**
 * This module provides a hand-modifiable wrapper around the generated class `LetElse`.
 *
 * INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.LetElse

/**
 * INTERNAL: This module contains the customizable definition of `LetElse` and should not
 * be referenced directly.
 */
module Impl {
  // the following QLdoc is generated: if you need to edit it, do it in the schema file
  /**
   * An else block in a let-else statement.
   *
   * For example:
   * ```rust
   * let Some(x) = opt else {
   *     return;
   * };
   * //                ^^^^^^
   * ```
   */
  class LetElse extends Generated::LetElse {
    override string toStringImpl() { result = this.toAbbreviatedString() }

    override string toAbbreviatedString() { result = "else {...}" }
  }
}

/**
 * This module provides a hand-modifiable wrapper around the generated class `Visibility`.
 *
 * INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.Visibility

/**
 * INTERNAL: This module contains the customizable definition of `Visibility` and should not
 * be referenced directly.
 */
module Impl {
  // the following QLdoc is generated: if you need to edit it, do it in the schema file
  /**
   * A visibility modifier.
   *
   * For example:
   * ```rust
   *   pub struct S;
   * //^^^
   * ```
   */
  class Visibility extends Generated::Visibility {
    override string toStringImpl() { result = this.toAbbreviatedString() }

    override string toAbbreviatedString() {
      result = "pub(" + this.getPath().toAbbreviatedString() + ")"
      or
      not this.hasPath() and result = "pub"
    }
  }
}

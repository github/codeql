/**
 * This module provides a hand-modifiable wrapper around the generated class `Enum`.
 *
 * INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.Enum

/**
 * INTERNAL: This module contains the customizable definition of `Enum` and should not
 * be referenced directly.
 */
module Impl {
  // the following QLdoc is generated: if you need to edit it, do it in the schema file
  /**
   * A Enum. For example:
   * ```rust
   * todo!()
   * ```
   */
  class Enum extends Generated::Enum {
    override string toString() { result = "enum " + this.getName().getText() }
  }
}

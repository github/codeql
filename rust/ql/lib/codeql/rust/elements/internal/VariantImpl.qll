/**
 * This module provides a hand-modifiable wrapper around the generated class `Variant`.
 *
 * INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.Variant

/**
 * INTERNAL: This module contains the customizable definition of `Variant` and should not
 * be referenced directly.
 */
module Impl {
  // the following QLdoc is generated: if you need to edit it, do it in the schema file
  /**
   * A Variant. For example:
   * ```rust
   * todo!()
   * ```
   */
  class Variant extends Generated::Variant {
    override string toString() { result = this.getName().getText() }
  }
}

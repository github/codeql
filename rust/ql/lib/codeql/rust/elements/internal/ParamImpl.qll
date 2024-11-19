/**
 * This module provides a hand-modifiable wrapper around the generated class `Param`.
 *
 * INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.Param

/**
 * INTERNAL: This module contains the customizable definition of `Param` and should not
 * be referenced directly.
 */
module Impl {
  // the following QLdoc is generated: if you need to edit it, do it in the schema file
  /**
   * A Param. For example:
   * ```rust
   * todo!()
   * ```
   */
  class Param extends Generated::Param {
    override string toString() {
      result = this.getPat().toString() + ": " + this.getTy().toString()
    }
  }
}

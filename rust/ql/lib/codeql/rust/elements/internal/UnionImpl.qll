/**
 * This module provides a hand-modifiable wrapper around the generated class `Union`.
 *
 * INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.Union

/**
 * INTERNAL: This module contains the customizable definition of `Union` and should not
 * be referenced directly.
 */
module Impl {
  // the following QLdoc is generated: if you need to edit it, do it in the schema file
  /**
   * A Union. For example:
   * ```rust
   * todo!()
   * ```
   */
  class Union extends Generated::Union {
    override string toString() { result = "union " + this.getName().getText() }
  }
}

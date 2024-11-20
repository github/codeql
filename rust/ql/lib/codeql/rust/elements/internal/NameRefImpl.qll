/**
 * This module provides a hand-modifiable wrapper around the generated class `NameRef`.
 *
 * INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.NameRef

/**
 * INTERNAL: This module contains the customizable definition of `NameRef` and should not
 * be referenced directly.
 */
module Impl {
  // the following QLdoc is generated: if you need to edit it, do it in the schema file
  /**
   * A NameRef. For example:
   * ```rust
   * todo!()
   * ```
   */
  class NameRef extends Generated::NameRef {
    override string toString() { result = this.getText() }
  }
}

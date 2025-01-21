/**
 * This module provides a hand-modifiable wrapper around the generated class `Name`.
 *
 * INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.Name

/**
 * INTERNAL: This module contains the customizable definition of `Name` and should not
 * be referenced directly.
 */
module Impl {
  // the following QLdoc is generated: if you need to edit it, do it in the schema file
  /**
   * A Name. For example:
   * ```rust
   * todo!()
   * ```
   */
  class Name extends Generated::Name {
    override string toString() { result = this.getText() }
  }
}

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
   * A union declaration.
   *
   * For example:
   * ```rust
   * union U { f1: u32, f2: f32 }
   * ```
   */
  class Union extends Generated::Union {
    override string toStringImpl() { result = "union " + this.getName().getText() }
  }
}

/**
 * This module provides a hand-modifiable wrapper around the generated class `Module`.
 *
 * INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.Module

/**
 * INTERNAL: This module contains the customizable definition of `Module` and should not
 * be referenced directly.
 */
module Impl {
  // the following QLdoc is generated: if you need to edit it, do it in the schema file
  /**
   * A module declaration. For example:
   * ```rust
   * mod foo;
   * ```
   * ```rust
   * mod bar {
   *     pub fn baz() {}
   * }
   * ```
   */
  class Module extends Generated::Module {
    override string toString() { result = "mod " + this.getName() }
  }
}

/**
 * This module provides a hand-modifiable wrapper around the generated class `Function`.
 *
 * INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.Function

/**
 * INTERNAL: This module contains the customizable definition of `Function` and should not
 * be referenced directly.
 */
module Impl {
  // the following QLdoc is generated: if you need to edit it, do it in the schema file
  /**
   * A function declaration. For example
   * ```rust
   * fn foo(x: u32) -> u64 {(x + 1).into()}
   * ```
   * A function declaration within a trait might not have a body:
   * ```rust
   * trait Trait {
   *     fn bar();
   * }
   * ```
   */
  class Function extends Generated::Function {
    override string toString() { result = "fn " + this.getName().getText() }
  }
}

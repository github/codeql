/**
 * This module provides a hand-modifiable wrapper around the generated class `SelfParam`.
 *
 * INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.SelfParam

/**
 * INTERNAL: This module contains the customizable definition of `SelfParam` and should not
 * be referenced directly.
 */
module Impl {
  // the following QLdoc is generated: if you need to edit it, do it in the schema file
  /**
   * A `self` parameter. For example `self` in:
   * ```rust
   * struct X;
   * impl X {
   *   fn one(&self) {}
   *   fn two(&mut self) {}
   *   fn three(self) {}
   *   fn four(mut self) {}
   *   fn five<'a>(&'a self) {}
   * }
   * ```
   */
  class SelfParam extends Generated::SelfParam {
    override string toStringImpl() { result = this.getAPrimaryQlClass() }
  }
}

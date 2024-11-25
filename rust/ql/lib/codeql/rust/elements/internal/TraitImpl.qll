/**
 * This module provides a hand-modifiable wrapper around the generated class `Trait`.
 *
 * INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.Trait

/**
 * INTERNAL: This module contains the customizable definition of `Trait` and should not
 * be referenced directly.
 */
module Impl {
  // the following QLdoc is generated: if you need to edit it, do it in the schema file
  /**
   * A Trait. For example:
   * ```
   * trait Frobinizable {
   *   type Frobinator;
   *   type Result: Copy;
   *   fn frobinize_with(&mut self, frobinator: &Self::Frobinator) -> Result;
   * }
   *
   * pub trait Foo<T: Frobinizable> where T::Frobinator: Eq {}
   * ```
   */
  class Trait extends Generated::Trait {
    override string toString() { result = "trait " + this.getName().getText() }
  }
}

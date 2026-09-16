/**
 * This module provides a hand-modifiable wrapper around the generated class `ReturnTypeSyntax`.
 *
 * INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.ReturnTypeSyntax

/**
 * INTERNAL: This module contains the customizable definition of `ReturnTypeSyntax` and should not
 * be referenced directly.
 */
module Impl {
  // the following QLdoc is generated: if you need to edit it, do it in the schema file
  /**
   * A return type notation `(..)` to reference or bound the type returned by a trait method
   *
   * For example:
   * ```rust
   * struct ReverseWidgets<F: Factory<widgets(..): DoubleEndedIterator>> {
   *     factory: F,
   * }
   *
   * impl<F> Factory for ReverseWidgets<F>
   * where
   *   F: Factory<widgets(..): DoubleEndedIterator>,
   * {
   *   fn widgets(&self) -> impl Iterator<Item = Widget> {
   *     self.factory.widgets().rev()
   *   }
   * }
   * ```
   */
  class ReturnTypeSyntax extends Generated::ReturnTypeSyntax {
    override string toStringImpl() { result = this.getAPrimaryQlClass() }
  }
}

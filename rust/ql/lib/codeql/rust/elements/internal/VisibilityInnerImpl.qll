/**
 * This module provides a hand-modifiable wrapper around the generated class `VisibilityInner`.
 *
 * INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.VisibilityInner

/**
 * INTERNAL: This module contains the customizable definition of `VisibilityInner` and should not
 * be referenced directly.
 */
module Impl {
  // the following QLdoc is generated: if you need to edit it, do it in the schema file
  /**
   * The parenthesized inner part of a visibility modifier or restriction, such as the `(in path)` in `pub(in path)`, or the `(crate)` in `pub(crate)`. For example the `(in foo::bar)` in:
   * ```rust
   * pub(in foo::bar) struct S;
   * //  ^^^^^^^^^^^^
   * ```
   */
  class VisibilityInner extends Generated::VisibilityInner {
    override string toStringImpl() { result = this.getAPrimaryQlClass() }
  }
}

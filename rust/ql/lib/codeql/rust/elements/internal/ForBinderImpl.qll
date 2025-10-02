/**
 * This module provides a hand-modifiable wrapper around the generated class `ForBinder`.
 *
 * INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.ForBinder

/**
 * INTERNAL: This module contains the customizable definition of `ForBinder` and should not
 * be referenced directly.
 */
module Impl {
  // the following QLdoc is generated: if you need to edit it, do it in the schema file
  /**
   * A for binder, specifying lifetime or type parameters for a closure or a type.
   *
   * For example:
   * ```rust
   * let print_any = for<T: std::fmt::Debug> |x: T| {
   * //              ^^^^^^^^^^^^^^^^^^^^^^^
   *     println!("{:?}", x);
   * };
   *
   * print_any(42);
   * print_any("hello");
   * ```
   */
  class ForBinder extends Generated::ForBinder {
    override string toStringImpl() { result = "for<...>" }
  }
}

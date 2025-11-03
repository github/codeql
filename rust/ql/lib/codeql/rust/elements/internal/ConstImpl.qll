/**
 * This module provides a hand-modifiable wrapper around the generated class `Const`.
 *
 * INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.Const
private import codeql.rust.elements.internal.PathExprImpl::Impl as PathExprImpl
private import codeql.rust.internal.PathResolution

/**
 * INTERNAL: This module contains the customizable definition of `Const` and should not
 * be referenced directly.
 */
module Impl {
  // the following QLdoc is generated: if you need to edit it, do it in the schema file
  /**
   * A constant item declaration.
   *
   * For example:
   * ```rust
   * const X: i32 = 42;
   * ```
   */
  class Const extends Generated::Const { }

  /**
   * A constant access.
   *
   * For example:
   * ```rust
   * const X: i32 = 42;
   *
   * fn main() {
   *     println!("{}", X);
   * }
   * ```
   */
  class ConstAccess extends PathExprImpl::PathExpr {
    private Const c;

    ConstAccess() { c = resolvePath(this.getPath()) }

    /** Gets the constant being accessed. */
    Const getConst() { result = c }

    override string getAPrimaryQlClass() { result = "ConstAccess" }
  }
}

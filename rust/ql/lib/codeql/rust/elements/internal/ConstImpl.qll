/**
 * This module provides a hand-modifiable wrapper around the generated class `Const`.
 *
 * INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.Const
private import codeql.rust.elements.internal.AstNodeImpl::Impl as AstNodeImpl
private import codeql.rust.elements.internal.IdentPatImpl::Impl as IdentPatImpl
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
  abstract class ConstAccess extends AstNodeImpl::AstNode {
    /** Gets the constant being accessed. */
    abstract Const getConst();

    override string getAPrimaryQlClass() { result = "ConstAccess" }
  }

  private class PathExprConstAccess extends ConstAccess, PathExprImpl::PathExpr {
    private Const c;

    PathExprConstAccess() { c = resolvePath(this.getPath()) }

    override Const getConst() { result = c }

    override string getAPrimaryQlClass() { result = ConstAccess.super.getAPrimaryQlClass() }
  }

  private class IdentPatConstAccess extends ConstAccess, IdentPatImpl::IdentPat {
    private Const c;

    IdentPatConstAccess() { c = resolvePath(this) }

    override Const getConst() { result = c }

    override string getAPrimaryQlClass() { result = ConstAccess.super.getAPrimaryQlClass() }
  }
}

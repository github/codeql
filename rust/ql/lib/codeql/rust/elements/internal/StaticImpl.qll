/**
 * This module provides a hand-modifiable wrapper around the generated class `Static`.
 *
 * INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.Static
private import codeql.rust.elements.internal.AstNodeImpl::Impl as AstNodeImpl
private import codeql.rust.elements.internal.PathExprImpl::Impl as PathExprImpl
private import codeql.rust.elements.internal.VariableImpl::Impl as VariableImpl
private import codeql.rust.internal.PathResolution

/**
 * INTERNAL: This module contains the customizable definition of `Static` and should not
 * be referenced directly.
 */
module Impl {
  // the following QLdoc is generated: if you need to edit it, do it in the schema file
  /**
   * A static item declaration.
   *
   * For example:
   * ```rust
   * static X: i32 = 42;
   * ```
   */
  class Static extends Generated::Static {
    /** Gets an access to this static item. */
    StaticAccess getAnAccess() { this = result.getStatic() }

    override string toStringImpl() { result = "static " + this.getName().getText() }
  }

  /**
   * A static access.
   *
   * For example:
   * ```rust
   * static X: i32 = 42;
   *
   * fn main() {
   *     println!("{}", X);
   * }
   * ```
   */
  class StaticAccess extends AstNodeImpl::AstNode, PathExprImpl::PathExpr {
    private Static s;

    StaticAccess() { s = resolvePath(this.getPath()) }

    /** Gets the static being accessed. */
    Static getStatic() { result = s }

    override string getAPrimaryQlClass() { result = "StaticAccess" }
  }

  /** A static write access. */
  class StaticWriteAccess extends StaticAccess {
    StaticWriteAccess() { VariableImpl::assignmentOperationDescendant(_, this) }
  }

  /** A static read access. */
  class StaticReadAccess extends StaticAccess {
    StaticReadAccess() { not this instanceof StaticWriteAccess }
  }
}

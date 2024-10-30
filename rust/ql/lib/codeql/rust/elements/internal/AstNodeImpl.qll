/**
 * This module provides a hand-modifiable wrapper around the generated class `AstNode`.
 *
 * INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.AstNode

/**
 * INTERNAL: This module contains the customizable definition of `AstNode` and should not
 * be referenced directly.
 */
module Impl {
  private import rust
  private import codeql.rust.elements.internal.generated.ParentChild

  /**
   * Gets the immediate parent of a non-`AstNode` element `e`.
   *
   * We restrict `e` to be a non-`AstNode` to skip past non-`AstNode` in
   * the transitive closure computation in `getParentOfAst`. This is
   * necessary because the parent of an `AstNode` is not necessarily an `AstNode`.
   */
  private Element getParentOfAstStep(Element e) {
    not e instanceof AstNode and
    result = getImmediateParent(e)
  }

  /** Gets the nearest enclosing parent of `ast` that is an `AstNode`. */
  private AstNode getParentOfAst(AstNode ast) {
    result = getParentOfAstStep*(getImmediateParent(ast))
  }

  class AstNode extends Generated::AstNode {
    /** Gets the immediately enclosing callable of this node, if any. */
    cached
    Callable getEnclosingCallable() {
      exists(AstNode p | p = getParentOfAst(this) |
        result = p
        or
        not p instanceof Callable and
        result = p.getEnclosingCallable()
      )
    }
  }
}

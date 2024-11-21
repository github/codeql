/**
 * This module provides a hand-modifiable wrapper around the generated class `AstNode`.
 *
 * INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.AstNode
private import codeql.rust.controlflow.ControlFlowGraph

/**
 * INTERNAL: This module contains the customizable definition of `AstNode` and should not
 * be referenced directly.
 */
module Impl {
  private import rust
  private import codeql.rust.elements.internal.generated.ParentChild
  private import codeql.rust.controlflow.ControlFlowGraph

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

  class AstNode extends Generated::AstNode {
    /**
     * Gets the nearest enclosing parent of this node, which is also an `AstNode`,
     * if any.
     */
    AstNode getParentNode() { result = getParentOfAstStep*(getImmediateParent(this)) }

    /** Gets the immediately enclosing callable of this node, if any. */
    cached
    Callable getEnclosingCallable() {
      exists(AstNode p | p = this.getParentNode() |
        result = p
        or
        not p instanceof Callable and
        result = p.getEnclosingCallable()
      )
    }

    /** Gets the CFG scope that encloses this node, if any. */
    cached
    CfgScope getEnclosingCfgScope() {
      exists(AstNode p | p = this.getParentNode() |
        result = p
        or
        not p instanceof CfgScope and
        result = p.getEnclosingCfgScope()
      )
    }

    /** Holds if this node is inside a macro expansion. */
    predicate isInMacroExpansion() {
      this = any(MacroCall mc).getExpanded()
      or
      this.getParentNode().isInMacroExpansion()
    }

    /**
     * Gets a control flow node for this AST node, if any.
     *
     * Note that because of _control flow splitting_, one `AstNode` node may correspond
     * to multiple `CfgNode`s. Example:
     *
     * ```rust
     * if a && b {
     *   // ...
     * }
     * ```
     *
     * The CFG for the condition above looks like
     *
     * ```mermaid
     * flowchart TD
     * 1["a"]
     * 2["b"]
     * 3["[false] a && b"]
     * 4["[true] a && b"]
     *
     * 1 -- false --> 3
     * 1 -- true --> 2
     * 2 -- false --> 3
     * 2 -- true --> 4
     * ```
     *
     * That is, the AST node for `a && b` corresponds to _two_ CFG nodes (it is
     * split into two).
     */
    CfgNode getACfgNode() { this = result.getAstNode() }
  }
}

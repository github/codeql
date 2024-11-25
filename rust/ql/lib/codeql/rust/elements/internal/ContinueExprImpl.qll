/**
 * This module provides a hand-modifiable wrapper around the generated class `ContinueExpr`.
 *
 * INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.ContinueExpr

/**
 * INTERNAL: This module contains the customizable definition of `ContinueExpr` and should not
 * be referenced directly.
 */
module Impl {
  private import codeql.rust.elements.internal.BreakExprImpl::Impl as BreakExprImpl
  private import codeql.rust.elements.internal.generated.ParentChild

  pragma[nomagic]
  private AstNode getAContinueAncestor(ContinueExpr ce, string label) {
    (
      label = ce.getLifetime().getText()
      or
      not ce.hasLifetime() and
      label = ""
    ) and
    exists(AstNode n0 | result = getImmediateParent(n0) |
      n0 = ce
      or
      n0 = getAContinueAncestor(ce, label) and
      not BreakExprImpl::isLabelledLoop(n0, label)
    )
  }

  // the following QLdoc is generated: if you need to edit it, do it in the schema file
  /**
   * A continue expression. For example:
   * ```rust
   * loop {
   *     if not_ready() {
   *         continue;
   *     }
   * }
   * ```
   * ```rust
   * 'label: loop {
   *     if not_ready() {
   *         continue 'label;
   *     }
   * }
   * ```
   */
  class ContinueExpr extends Generated::ContinueExpr {
    override string toString() {
      result = strictconcat(int i | | this.toStringPart(i), " " order by i)
    }

    private string toStringPart(int index) {
      index = 0 and result = "continue"
      or
      index = 1 and result = this.getLifetime().getText()
    }

    /**
     * Gets the target of this `continue` expression.
     *
     * The target is either a `LoopExpr`, a `ForExpr`, or a `WhileExpr`.
     */
    pragma[nomagic]
    LoopingExpr getTarget() {
      exists(string label |
        result = getAContinueAncestor(this, label) and
        BreakExprImpl::isLabelledLoop(result, label)
      )
    }
  }
}

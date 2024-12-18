/**
 * This module provides a hand-modifiable wrapper around the generated class `BreakExpr`.
 *
 * INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.BreakExpr
import codeql.rust.elements.LabelableExpr

/**
 * INTERNAL: This module contains the customizable definition of `BreakExpr` and should not
 * be referenced directly.
 */
module Impl {
  private import rust
  private import codeql.rust.elements.internal.generated.ParentChild

  /** Holds if `e` is a loop labelled `label`. */
  pragma[nomagic]
  predicate isLabelledLoop(Expr e, string label) {
    e =
      any(LoopExpr le |
        label = le.getLabel().getLifetime().getText()
        or
        label = ""
      )
    or
    e =
      any(ForExpr fe |
        label = fe.getLabel().getLifetime().getText()
        or
        label = ""
      )
    or
    e =
      any(WhileExpr we |
        label = we.getLabel().getLifetime().getText()
        or
        label = ""
      )
  }

  pragma[nomagic]
  private predicate isLabelled(Expr e, string label) {
    isLabelledLoop(e, label)
    or
    label = e.(BlockExpr).getLabel().getLifetime().getText()
  }

  pragma[nomagic]
  private AstNode getABreakAncestor(BreakExpr be, string label) {
    (
      label = be.getLifetime().getText()
      or
      not be.hasLifetime() and
      label = ""
    ) and
    exists(AstNode n0 | result = getImmediateParent(n0) |
      n0 = be
      or
      n0 = getABreakAncestor(be, label) and
      not isLabelled(n0, label)
    )
  }

  // the following QLdoc is generated: if you need to edit it, do it in the schema file
  /**
   * A break expression. For example:
   * ```rust
   * loop {
   *     if not_ready() {
   *         break;
   *      }
   * }
   * ```
   * ```rust
   * let x = 'label: loop {
   *     if done() {
   *         break 'label 42;
   *     }
   * };
   * ```
   * ```rust
   * let x = 'label: {
   *     if exit() {
   *         break 'label 42;
   *     }
   *     0;
   * };
   * ```
   */
  class BreakExpr extends Generated::BreakExpr {
    /**
     * Gets the target of this `break` expression.
     *
     * The target is either a `LoopExpr`, a `ForExpr`, a `WhileExpr`, or a
     * `BlockExpr`.
     */
    pragma[nomagic]
    Expr getTarget() {
      exists(string label |
        result = getABreakAncestor(this, label) and
        isLabelled(result, label)
      )
    }

    override string toString() {
      result = strictconcat(int i | | this.toStringPart(i), " " order by i)
    }

    private string toStringPart(int index) {
      index = 0 and result = "break"
      or
      index = 1 and result = this.getLifetime().toString()
      or
      index = 2 and result = this.getExpr().toAbbreviatedString()
    }
  }
}

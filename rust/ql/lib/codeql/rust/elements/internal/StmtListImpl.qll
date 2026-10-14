/**
 * This module provides a hand-modifiable wrapper around the generated class `StmtList`.
 *
 * INTERNAL: Do not use.
 */

private import codeql.rust.elements.internal.generated.StmtList

/**
 * INTERNAL: This module contains the customizable definition of `StmtList` and should not
 * be referenced directly.
 */
module Impl {
  // the following QLdoc is generated: if you need to edit it, do it in the schema file
  /**
   * A list of statements in a block, with an optional tail expression at the
   * end that determines the block's value.
   *
   * For example:
   * ```rust
   * {
   *     let x = 1;
   *     let y = 2;
   *     x + y
   * }
   * //  ^^^^^^^^^
   * ```
   */
  class StmtList extends Generated::StmtList {
    /**
     * Gets the `index`th statement or expression of this statement list (0-based).
     *
     * This includes both the statements and any tail expression in the statement list. To access
     * just the statements, use `getStatement`. To access just the tail expression, if any,
     * use `getTailExpr`.
     */
    AstNode getStmtOrExpr(int index) {
      result = this.getStatement(index)
      or
      index = this.getNumberOfStatements() and
      result = this.getTailExpr()
    }

    /**
     * Gets any of the statements or expressions of this statement list.
     *
     * This includes both the statements and any tail expression in the statement list. To access
     * just the statements, use `getAStatement`. To access just the tail expression, if any,
     * use `getTailExpr`.
     */
    final AstNode getAStmtOrExpr() { result = this.getStmtOrExpr(_) }

    /**
     * Gets the number of statements or expressions of this statement list.
     */
    final int getNumberOfStmtOrExpr() { result = count(int i | exists(this.getStmtOrExpr(i))) }
  }
}

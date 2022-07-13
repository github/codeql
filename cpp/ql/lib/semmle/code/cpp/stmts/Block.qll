/**
 * Provides a class to model C/C++ block statements, enclosed by `{` and `}`.
 */

import semmle.code.cpp.Element
import semmle.code.cpp.stmts.Stmt

/**
 * A C/C++ block statement.
 *
 * For example, the block from `{` to `}` in the following code:
 * ```
 * {
 *   int a;
 *   int b = 1;
 *   a = b;
 * }
 * ```
 */
class BlockStmt extends Stmt, @stmt_block {
  override string getAPrimaryQlClass() { result = "BlockStmt" }

  /**
   * Gets a child declaration of this block.
   *
   * For example, for the block
   * ```
   * { int a; int b = 1; a = b; }
   * ```
   * it would have 2 results, for the declarations of `a` and `b`.
   */
  Declaration getADeclaration() { result = this.getAStmt().(DeclStmt).getADeclaration() }

  /**
   * Gets a body statement of this block.
   *
   * For example, for the block
   * ```
   * { int a; int b = 1; a = b; }
   * ```
   * it would have 3 results, for the declarations of `a` and `b` and
   * for the expression statement `a = b`.
   */
  Stmt getAStmt() { result = this.getAChild() }

  /**
   * Gets the `n`th body statement of this block, indexed from 0.
   *
   * For example, for the block
   * ```
   * { int a; int b = 1; a = b; }
   * ```
   * `getStmt(2)`'s result is the expression statement `a = b`.
   */
  Stmt getStmt(int n) { result = this.getChild(n) }

  /**
   * Gets the last body statement of this block.
   *
   * For example, for the block
   * ```
   * { int a; int b = 1; a = b; }
   * ```
   * the result is the expression statement `a = b`.
   */
  Stmt getLastStmt() { result = this.getStmt(this.getNumStmt() - 1) }

  /**
   * Gets the last body statement of this block. If this last statement
   * is itself a block, returns the last statement of that block, and so on.
   *
   * For example, for the block
   * ```
   * { int a; int b = 1; { a = b; } }
   * ```
   * the result is the expression statement `a = b`.
   */
  Stmt getLastStmtIn() {
    if this.getLastStmt() instanceof BlockStmt
    then result = this.getLastStmt().(BlockStmt).getLastStmtIn()
    else result = this.getLastStmt()
  }

  /**
   * Gets the number of body statements in this block.
   *
   * For example, for the block
   * ```
   * { int a; int b = 1; a = b; }
   * ```
   * the result is 3.
   */
  int getNumStmt() { result = count(this.getAStmt()) }

  /**
   * Holds if the block has no statements.
   *
   * For example, the block
   * ```
   * { }
   * ```
   * is empty, as is the block
   * ```
   * {
   *   // a comment
   * }
   * ```
   */
  predicate isEmpty() { this.getNumStmt() = 0 }

  /**
   * Gets the index of the given statement within this block, indexed from 0.
   *
   * For example, for the block
   * ```
   * { int a; int b = 1; a = b; }
   * ```
   * if `s` is the expression statement `a = b` then `getIndexOfStmt(s)`
   * has result 2.
   */
  int getIndexOfStmt(Stmt s) { this.getStmt(result) = s }

  override string toString() { result = "{ ... }" }

  override predicate mayBeImpure() { this.getAStmt().mayBeImpure() }

  override predicate mayBeGloballyImpure() { this.getAStmt().mayBeGloballyImpure() }
}

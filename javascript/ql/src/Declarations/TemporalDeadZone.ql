/**
 * @name Access to let-bound variable in temporal dead zone
 * @description Accessing a let-bound variable before its declaration will lead to a runtime
 *              error on ECMAScript 2015-compatible platforms.
 * @kind problem
 * @problem.severity error
 * @id js/variable-use-in-temporal-dead-zone
 * @tags portability
 *       correctness
 * @precision very-high
 */

import javascript

/**
 * Gets the (0-based) index among all statements in block `blk` at which
 * variable `v` is declared by statement `let`.
 */
int letDeclAt(BlockStmt blk, Variable v, LetStmt let) {
  let.getADecl().getBindingPattern().getAVariable() = v and
  let.getParentStmt*() = blk.getStmt(result)
}

from VarAccess va, LetStmt let, BlockStmt blk, int i, int j, Variable v
where
  v = va.getVariable() and
  j = letDeclAt(blk, v, let) and
  blk.getStmt(i) = va.getEnclosingStmt().getParentStmt*() and
  i < j and
  // don't flag uses in different functions
  blk.getContainer() = va.getContainer() and
  not letDeclAt(blk, v, _) < i
select va, "This expression refers to $@ inside its temporal dead zone.", let, va.getName()

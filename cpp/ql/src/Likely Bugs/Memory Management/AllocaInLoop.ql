/**
 * @name Call to alloca in a loop
 * @description Using alloca in a loop can lead to a stack overflow
 * @kind problem
 * @problem.severity warning
 * @precision high
 * @id cpp/alloca-in-loop
 * @tags reliability
 *       correctness
 *       security
 *       external/cwe/cwe-770
 */

import cpp

Loop getAnEnclosingLoopOfExpr(Expr e) {
  result = e.getEnclosingStmt().getParent*() or
  result = getAnEnclosingLoopOfStmt(e.getEnclosingStmt())
}

Loop getAnEnclosingLoopOfStmt(Stmt s) {
  result = s.getParent*() or
  result = getAnEnclosingLoopOfExpr(s.getParent*())
}

from Loop l, FunctionCall fc
where
  getAnEnclosingLoopOfExpr(fc) = l and
  (
    fc.getTarget().getName() = "__builtin_alloca"
    or
    (
      (fc.getTarget().getName() = "_alloca" or fc.getTarget().getName() = "_malloca") and
      fc.getTarget().getADeclarationEntry().getFile().getBaseName() = "malloc.h"
    )
  ) and
  not l.(DoStmt).getCondition().getValue() = "0"
select fc, "Stack allocation is inside a $@ and could lead to stack overflow.", l, l.toString()

/**
 * @name alloca in a loop
 * @description Using alloca in a loop can lead to a stack overflow
 * @kind problem
 * @problem.severity warning
 * @id cpp/alloca-in-loop
 * @tags reliability
 *       correctness
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
where getAnEnclosingLoopOfExpr(fc) = l
  and fc.getTarget().getName() = "__builtin_alloca"
  and not l.(DoStmt).getCondition().getValue() = "0"
select fc, "Stack allocation is inside a $@ and could lead to overflow.", l, l.toString()

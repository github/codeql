/**
 * @name Memory May Not Be Freed On Loop
 * @description A loop may break/continue before freeing memory that was allocated in the loop. A free/delete call should be added before the break/continue.
 * @kind problem
 * @id cpp/memory-may-not-be-freed-on-loop
 * @problem.severity critical
 * @tags efficiency
 *       security
 */

import cpp
import semmle.code.cpp.dataflow.DataFlow
import AllocAndFree

predicate sameLoop(BlockStmt b, Stmt is) {
  if is instanceof Loop then is.getAChild*() = b else sameLoop(b, is.getParent())
}

from StackVariable v, Expr def, JumpStmt b, BlockStmt bs, IfStmt is, ReturnStmt rt
where
  allocationDefinition(v, def) and
  (b instanceof BreakStmt or b instanceof ContinueStmt) and
  def.getParent() instanceof Initializer and
  bs.getParent*() instanceof Loop and
  exists(int i | i in [0 .. bs.getNumStmt() - 1] |
    bs.getChild(i) = def.getEnclosingStmt() and
    //Checking if the variable is not copied or used in a function call. If so, that might be normal if the variable is not freed in the loop.
    not exists(int y | y in [0 .. bs.getNumStmt() - 1] |
      bs.getChild(y) instanceof ExprStmt and
      bs.getChild(y).(ExprStmt).getExpr() instanceof AssignExpr and
      bs.getChild(y).(ExprStmt).getExpr().(Assignment).getRValue*() = v.getAnAccess()
    ) and
    exists(int y | y in [i .. bs.getNumStmt() - 1] |
      (bs.getChild(y) = is or bs.getChild(y).(IfStmt).getAChild*() = is) and
      sameLoop(bs, is) and
      (
        is.getAChild() = b or
        is.getThen().getAChild() = b or
        is.getAChild() = rt or
        is.getThen().getAChild() = rt
      ) and
      not is.getCondition().getAChild*() = v.getAnAccess() and
      not is.getParent*().(IfStmt).getCondition().getAChild*() = v.getAnAccess() and
      not exists(int p | p in [i .. y] | freeCallOrIndirect(bs.getChild(p).(ExprStmt).getExpr(), v)) and
      not exists(int a | a in [0 .. is.getThen().(BlockStmt).getNumStmt()] |
        freeCallOrIndirect(is.getThen().getChild(a).(ExprStmt).getExpr(), v)
      ) and
      exists(int a | a in [y .. bs.getNumStmt() - 1] |
        freeCallOrIndirect(bs.getChild(a).(ExprStmt).getExpr(), v) or
        freeCallOrIndirect(bs.getChild(a).(IfStmt).getAChild(), v)
      )
    )
  )
select def, "The memory allocated here may not be released at $@.", b, "this point"

/**
 * @name Memory May Not Be Freed On Loop
 * @description A loo may break/continue before freeing memory that was allocated in the loop. A free/delete call should be added before the break/continue.
 * @kind problem
 * @id cpp/memory-may-not-be-freed-on-loop
 * @problem.severity critical
 * @tags efficiency
 *       security
 */

import cpp
import semmle.code.cpp.dataflow.DataFlow
import MemoryFreed

predicate mayCallFunction(Expr call, Function f) {
  call.(FunctionCall).getTarget() = f or
  call.(VariableCall).getVariable().getAnAssignedValue().getAChild*().(FunctionAccess).getTarget() =
    f
}

predicate assignedToFieldOrGlobal(StackVariable v, Expr e) {
  // assigned to anything except a StackVariable
  // (typically a field or global, but for example also *ptr = v)
  e.(Assignment).getRValue() = v.getAnAccess() and
  not e.(Assignment).getLValue().(VariableAccess).getTarget() instanceof StackVariable
  or
  exists(Expr midExpr, Function mid, int arg |
    // indirect assignment
    e.(FunctionCall).getArgument(arg) = v.getAnAccess() and
    mayCallFunction(e, mid) and
    midExpr.getEnclosingFunction() = mid and
    assignedToFieldOrGlobal(mid.getParameter(arg), midExpr)
  )
  or
  // assigned to a field via constructor field initializer
  e.(ConstructorFieldInit).getExpr() = v.getAnAccess()
}

predicate allocCallOrIndirect(Expr e) {
  // direct alloc call
  e.(AllocationExpr).requiresDealloc() and
  // We are only interested in alloc calls that are
  // actually freed somehow, as MemoryNeverFreed
  // will catch those that aren't.
  allocMayBeFreed(e)
  or
  exists(ReturnStmt rtn |
    // indirect alloc call
    mayCallFunction(e, rtn.getEnclosingFunction()) and
    (
      // return alloc
      allocCallOrIndirect(rtn.getExpr())
      or
      // return variable assigned with alloc
      exists(Variable v |
        v = rtn.getExpr().(VariableAccess).getTarget() and
        allocCallOrIndirect(v.getAnAssignedValue()) and
        not assignedToFieldOrGlobal(v, _)
      )
    )
  )
}

predicate verifiedRealloc(FunctionCall reallocCall, Variable v, ControlFlowNode verified) {
  reallocCall.(AllocationExpr).getReallocPtr() = v.getAnAccess() and
  (
    exists(Variable newV, ControlFlowNode node |
      // a realloc followed by a null check at 'node' (return the non-null
      // successor, i.e. where the realloc is confirmed to have succeeded)
      newV.getAnAssignedValue() = reallocCall and
      node.(AnalysedExpr).getNonNullSuccessor(newV) = verified and
      // note: this case uses naive flow logic (getAnAssignedValue).
      // special case: if the result of the 'realloc' is assigned to the
      // same variable, we don't descriminate properly between the old
      // and the new allocation; better to not consider this a free at
      // all in that case.
      newV != v
    )
    or
    // a realloc(ptr, 0), which always succeeds and frees
    // (return the realloc itself)
    reallocCall.(AllocationExpr).getReallocPtr().getValue() = "0" and
    verified = reallocCall
  )
}

predicate allocationDefinition(StackVariable v, ControlFlowNode def) {
  exists(Expr expr | exprDefinition(v, def, expr) and allocCallOrIndirect(expr))
}

predicate freeCallOrIndirect(ControlFlowNode n, Variable v) {
  // direct free call
  n.(DeallocationExpr).getFreedExpr() = v.getAnAccess() and
  not exists(n.(AllocationExpr).getReallocPtr())
  or
  // verified realloc call
  verifiedRealloc(_, v, n)
  or
  exists(FunctionCall midcall, Function mid, int arg |
    // indirect free call
    n.(Call).getArgument(arg) = v.getAnAccess() and
    mayCallFunction(n, mid) and
    midcall.getEnclosingFunction() = mid and
    freeCallOrIndirect(midcall, mid.getParameter(arg))
  )
}

predicate sameLoop(BlockStmt b, Stmt is) {
  if is instanceof ForStmt or is instanceof WhileStmt
  then is.getAChild*() = b
  else sameLoop(b, is.getParent())
}

from StackVariable v, Expr def, JumpStmt b, BlockStmt bs, IfStmt is
where
  allocationDefinition(v, def) and
  (b instanceof BreakStmt or b instanceof ContinueStmt) and
  def.getParent() instanceof Initializer and
  (bs.getParent*() instanceof ForStmt or bs.getParent*() instanceof WhileStmt) and
  exists(int i | i in [0 .. bs.getNumStmt() - 1] |
    bs.getChild(i) = def.getEnclosingStmt() and
    not exists(int y | y in [0 .. bs.getNumStmt() - 1] |
      bs.getChild(y) instanceof ExprStmt and
      bs.getChild(y).(ExprStmt).getExpr() instanceof AssignExpr and
      bs.getChild(y).(ExprStmt).getExpr().(Assignment).getRValue*() = v.getAnAccess()
    ) and
    exists(int y | y in [i .. bs.getNumStmt() - 1] |
      (bs.getChild(y) = is or bs.getChild(y).(IfStmt).getAChild*() = is) and
      sameLoop(bs, is) and
      (is.getAChild() = b or is.getThen().getAChild() = b) and
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
select def, "The memory allocated here may not be released at $@.", b, "this break/continue"

/**
 * @name Open descriptor may not be closed
 * @description Failing to close resources in the function that opened them makes it difficult to avoid and detect resource leaks.
 * @kind problem
 * @id cpp/descriptor-may-not-be-closed
 * @problem.severity warning
 * @security-severity 7.8
 * @tags efficiency
 *       security
 *       external/cwe/cwe-775
 */

import semmle.code.cpp.pointsto.PointsTo
import Negativity

predicate closeCall(FunctionCall fc, Variable v) {
  fc.getTarget().hasGlobalOrStdName("close") and v.getAnAccess() = fc.getArgument(0)
  or
  exists(FunctionCall midcall, Function mid, int arg |
    fc.getArgument(arg) = v.getAnAccess() and
    fc.getTarget() = mid and
    midcall.getEnclosingFunction() = mid and
    closeCall(midcall, mid.getParameter(arg))
  )
}

predicate openDefinition(StackVariable v, ControlFlowNode def) {
  exists(Expr expr | exprDefinition(v, def, expr) and allocateDescriptorCall(expr))
}

predicate openReaches(ControlFlowNode def, ControlFlowNode node) {
  exists(StackVariable v | openDefinition(v, def) and node = def.getASuccessor())
  or
  exists(StackVariable v, ControlFlowNode mid |
    openDefinition(v, def) and
    openReaches(def, mid) and
    not errorSuccessor(v, mid) and
    not closeCall(mid, v) and
    not assignedToFieldOrGlobal(v, mid) and
    node = mid.getASuccessor()
  )
}

predicate assignedToFieldOrGlobal(StackVariable v, Assignment assign) {
  exists(Variable external |
    assign.getRValue() = v.getAnAccess() and
    assign.getLValue().(VariableAccess).getTarget() = external and
    (external instanceof Field or external instanceof GlobalVariable)
  )
}

from StackVariable v, ControlFlowNode def, ReturnStmt ret
where
  openDefinition(v, def) and
  openReaches(def, ret) and
  checkedSuccess(v, ret) and
  not ret.getExpr().getAChild*() = v.getAnAccess() and
  exists(ReturnStmt other | other.getExpr() = v.getAnAccess())
select ret,
  "Descriptor assigned to '" + v.getName().toString() + "' (line " +
    def.getLocation().getStartLine().toString() + ") may not be closed."

/**
 * @name Errors When Double Free
 * @description Double freeing of a previously allocated resource can lead to various vulnerabilities in the program
 *              and requires the attention of the developer.
 * @kind problem
 * @id cpp/errors-when-double-free
 * @problem.severity warning
 * @precision medium
 * @tags security
 *       external/cwe/cwe-415
 */

import cpp

/**
 * The function allows `getASuccessor` to be called recursively.
 * This provides a stop in situations of possible influence on the pointer.
 */
ControlFlowNode recursASuccessor(FunctionCall fc, LocalScopeVariable v) {
  result = fc
  or
  exists(ControlFlowNode mid |
    mid = recursASuccessor(fc, v) and
    result = mid.getASuccessor() and
    not result = v.getAnAssignedValue() and
    not result.(AddressOfExpr).getOperand() = v.getAnAccess() and
    not (
      not result instanceof DeallocationExpr and
      result.(FunctionCall).getAnArgument().(VariableAccess).getTarget() = v
    ) and
    (
      fc.getTarget().hasGlobalOrStdName("realloc") and
      (
        not fc.getParent*() instanceof IfStmt and
        not result instanceof IfStmt
      )
      or
      not fc.getTarget().hasGlobalOrStdName("realloc")
    )
  )
}

from FunctionCall fc
where
  exists(FunctionCall fc2, LocalScopeVariable v |
    freeCall(fc, v.getAnAccess()) and
    freeCall(fc2, v.getAnAccess()) and
    fc != fc2 and
    recursASuccessor(fc, v) = fc2
  )
select fc.getArgument(0), "This pointer may be cleared again later."

/**
 * @name Errors When Double Free
 * @description Freeing a previously allocated resource twice can lead to various vulnerabilities in the program.
 * @kind problem
 * @id cpp/experimental-double-free
 * @problem.severity warning
 * @precision medium
 * @tags security
 *       experimental
 *       external/cwe/cwe-415
 */

import cpp

from FunctionCall fc, FunctionCall fc2, LocalScopeVariable v
where
  fc.(DeallocationExpr).getFreedExpr() = v.getAnAccess() and
  fc2.(DeallocationExpr).getFreedExpr() = v.getAnAccess() and
  fc != fc2 and
  fc.getASuccessor*() = fc2 and
  not exists(Expr exptmp |
    (exptmp = v.getAnAssignedValue() or exptmp.(AddressOfExpr).getOperand() = v.getAnAccess()) and
    exptmp = fc.getASuccessor*() and
    exptmp = fc2.getAPredecessor*()
  ) and
  not exists(FunctionCall fctmp |
    not fctmp instanceof DeallocationExpr and
    fctmp = fc.getASuccessor*() and
    fctmp = fc2.getAPredecessor*() and
    fctmp.getAnArgument().(VariableAccess).getTarget() = v
  ) and
  (
    fc.getTarget().hasGlobalOrStdName("realloc") and
    (
      not fc.getParent*() instanceof IfStmt and
      not exists(IfStmt iftmp |
        iftmp.getCondition().getAChild*().(VariableAccess).getTarget().getAnAssignedValue() = fc
      )
    )
    or
    not fc.getTarget().hasGlobalOrStdName("realloc")
  )
select fc2.getArgument(0),
  "This pointer may have already been cleared in the line " + fc.getLocation().getStartLine() + "."

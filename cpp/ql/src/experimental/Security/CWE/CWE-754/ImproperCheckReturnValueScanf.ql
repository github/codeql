/**
 * @name Improper check of return value of scanf
 * @description Not checking the return value of scanf and related functions may lead to undefined behavior.
 * @kind problem
 * @id cpp/improper-check-return-value-scanf
 * @problem.severity warning
 * @precision medium
 * @tags correctness
 *       security
 *       external/cwe/cwe-754
 *       external/cwe/cwe-908
 */

import cpp
import semmle.code.cpp.commons.Exclusions

/** Returns the position of the first argument being filled. */
int posArgumentInFunctionCall(FunctionCall fc) {
  (
    fc.getTarget().hasGlobalOrStdName(["scanf", "scanf_s"]) and
    result = 1
    or
    fc.getTarget().hasGlobalOrStdName(["fscanf", "sscanf", "fscanf_s", "sscanf_s"]) and
    result = 2
  )
}

/** Holds if a function argument was not initialized but used after the call. */
predicate argumentIsNotInitializedAndIsUsed(Variable vt, FunctionCall fc) {
  // Fillable argument was not initialized.
  vt instanceof LocalScopeVariable and
  not vt.getAnAssignment().getASuccessor+() = fc and
  (
    not vt.hasInitializer()
    or
    exists(Expr e, Variable v |
      e = vt.getInitializer().getExpr() and
      v = e.(AddressOfExpr).getOperand().(VariableAccess).getTarget() and
      (
        not v.hasInitializer() and
        not v.getAnAssignment().getASuccessor+() = fc
      )
    )
  ) and
  not exists(AssignExpr ae |
    ae.getLValue() = vt.getAnAccess().getParent() and
    ae.getASuccessor+() = fc
  ) and
  not exists(FunctionCall f0 |
    f0.getAnArgument().getAChild() = vt.getAnAccess() and
    f0.getASuccessor+() = fc
  ) and
  exists(Expr e0 |
    // After the call, the completed arguments are assigned or returned as the result of the operation of the upper function.
    fc.getASuccessor+() = e0 and
    (
      (
        e0.(Assignment).getRValue().(VariableAccess).getTarget() = vt or
        e0.(Assignment).getRValue().(ArrayExpr).getArrayBase().(VariableAccess).getTarget() = vt
      )
      or
      e0.getEnclosingStmt() instanceof ReturnStmt and
      e0.(VariableAccess).getTarget() = vt
      or
      not exists(Expr e1 |
        fc.getASuccessor+() = e1 and
        e1.(VariableAccess).getTarget() = vt
      )
    )
  )
}

from FunctionCall fc, int i
where
  // Function return value is not evaluated.
  fc instanceof ExprInVoidContext and
  not isFromMacroDefinition(fc) and
  i in [posArgumentInFunctionCall(fc) .. fc.getNumberOfArguments() - 1] and
  (
    argumentIsNotInitializedAndIsUsed(fc.getArgument(i).(VariableAccess).getTarget(), fc) or
    argumentIsNotInitializedAndIsUsed(fc.getArgument(i)
          .(AddressOfExpr)
          .getOperand()
          .(VariableAccess)
          .getTarget(), fc) or
    argumentIsNotInitializedAndIsUsed(fc.getArgument(i)
          .(ArrayExpr)
          .getArrayBase()
          .(VariableAccess)
          .getTarget(), fc)
  ) and
  // After the call, filled arguments are not evaluated.
  not exists(Expr e0, int i1 |
    i1 in [posArgumentInFunctionCall(fc) .. fc.getNumberOfArguments() - 1] and
    fc.getASuccessor+() = e0 and
    e0.getEnclosingElement() instanceof ComparisonOperation and
    (
      e0.(VariableAccess).getTarget() = fc.getArgument(i1).(VariableAccess).getTarget() or
      e0.(VariableAccess).getTarget() =
        fc.getArgument(i1).(AddressOfExpr).getOperand().(VariableAccess).getTarget()
    )
  )
select fc, "Unchecked return value for call to '" + fc.getTarget().getName() + "'."

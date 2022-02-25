/**
 * @name Improper check return value scanf.
 * @description Using a function call without the ability to evaluate the correctness of the work can lead to unexpected results.
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
import semmle.code.cpp.valuenumbering.GlobalValueNumbering

/** Returns the starting position of the argument being filled. */
int posArgumentInFunctionCall(FunctionCall fc) {
  (
    (
      fc.getTarget().hasGlobalOrStdName("scanf") or
      fc.getTarget().hasGlobalOrStdName("scanf_s")
    ) and
    result = 1
    or
    (
      fc.getTarget().hasGlobalOrStdName("fscanf") or
      fc.getTarget().hasGlobalOrStdName("sscanf") or
      fc.getTarget().hasGlobalOrStdName("fscanf_s") or
      fc.getTarget().hasGlobalOrStdName("sscanf_s")
    ) and
    result = 2
  )
}

from FunctionCall fc, int n
where
  n = posArgumentInFunctionCall(fc) and
  // Function return value is not evaluated.
  fc instanceof ExprInVoidContext and
  not isFromMacroDefinition(fc) and
  exists(Expr e0, int i |
    i in [n .. fc.getNumberOfArguments() - 1] and
    // Fillable argument was not initialized.
    (
      fc.getArgument(i).(VariableAccess).getTarget() instanceof LocalScopeVariable or
      fc.getArgument(i).(AddressOfExpr).getOperand().(VariableAccess).getTarget() instanceof
        LocalScopeVariable
    ) and
    (
      not fc.getArgument(i).(VariableAccess).getTarget().hasInitializer() and
      not fc.getArgument(i)
          .(AddressOfExpr)
          .getOperand()
          .(VariableAccess)
          .getTarget()
          .hasInitializer()
    ) and
    (
      not fc.getArgument(i).(VariableAccess).getTarget().getAnAssignment().getASuccessor+() = fc and
      not fc.getArgument(i)
          .(AddressOfExpr)
          .getOperand()
          .(VariableAccess)
          .getTarget()
          .getAnAssignment()
          .getASuccessor+() = fc
    ) and
    // After the call, the completed arguments are assigned or returned as the result of the operation of the upper function.
    fc.getASuccessor+() = e0 and
    (
      (
        e0.(Assignment).getRValue().(VariableAccess).getTarget() =
          fc.getArgument(i).(AddressOfExpr).getOperand().(VariableAccess).getTarget() or
        e0.(Assignment).getRValue().(VariableAccess).getTarget() =
          fc.getArgument(i).(VariableAccess).getTarget()
      )
      or
      e0.getEnclosingStmt() instanceof ReturnStmt and
      (
        e0.(VariableAccess).getTarget() =
          fc.getArgument(i).(AddressOfExpr).getOperand().(VariableAccess).getTarget() or
        e0.(VariableAccess).getTarget() = fc.getArgument(i).(VariableAccess).getTarget()
      )
      or
      not exists(Expr e1 |
        fc.getASuccessor+() = e1 and
        (
          e1.(VariableAccess).getTarget() =
            fc.getArgument(i).(AddressOfExpr).getOperand().(VariableAccess).getTarget() or
          e1.(VariableAccess).getTarget() = fc.getArgument(i).(VariableAccess).getTarget()
        )
      )
    )
  ) and
  // After the call, filled arguments are not evaluated.
  not exists(Expr e0, int i |
    i in [n .. fc.getNumberOfArguments() - 1] and
    fc.getASuccessor+() = e0 and
    e0.getEnclosingElement() instanceof ComparisonOperation and
    (
      e0.(VariableAccess).getTarget() = fc.getArgument(i).(VariableAccess).getTarget() or
      e0.(VariableAccess).getTarget() =
        fc.getArgument(i).(AddressOfExpr).getOperand().(VariableAccess).getTarget()
    )
  )
select fc, "Unchecked return value for call to '" + fc.getTarget().getName() + "'."

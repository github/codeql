/**
 * @name Unchecked return value for time conversion function (AntiPattern 6)
 * @description When the return value of a fallible time conversion function is
 *              not checked for failure, its output parameters may contain
 *              invalid dates.
 * @kind problem
 * @problem.severity warning
 * @id cpp/microsoft/public/leap-year/unchecked-return-value-for-time-conversion-function
 * @precision medium
 * @tags leap-year
 *       correctness
 */

import cpp
import LeapYear

from FunctionCall fcall, TimeConversionFunction trf, Variable var
where
  fcall = trf.getACallToThisFunction() and
  fcall instanceof ExprInVoidContext and
  var.getUnderlyingType() instanceof UnpackedTimeType and
  (
    exists(AddressOfExpr aoe |
      aoe = fcall.getAnArgument() and
      aoe.getAddressable() = var
    )
    or
    exists(VariableAccess va |
      fcall.getAnArgument() = va and
      var.getAnAccess() = va
    )
  ) and
  exists(DateStructModifiedFieldAccess dsmfa, VariableAccess modifiedVarAccess |
    modifiedVarAccess = var.getAnAccess() and
    modifiedVarAccess = dsmfa.getQualifier() and
    modifiedVarAccess = fcall.getAPredecessor*()
  ) and
  // Remove false positives
  not (
    // Remove any instance where the predecessor is a SafeTimeGatheringFunction and no change to the data happened in between
    exists(FunctionCall pred |
      pred = fcall.getAPredecessor*() and
      exists(SafeTimeGatheringFunction stgf | pred = stgf.getACallToThisFunction()) and
      not exists(DateStructModifiedFieldAccess dsmfa, VariableAccess modifiedVarAccess |
        modifiedVarAccess = var.getAnAccess() and
        modifiedVarAccess = dsmfa.getQualifier() and
        modifiedVarAccess = fcall.getAPredecessor*() and
        modifiedVarAccess = pred.getASuccessor*()
      )
    )
    or
    // Remove any instance where the year is changed, but the month is set to 1 (year wrapping)
    exists(MonthFieldAccess mfa, AssignExpr ae |
      mfa.getQualifier() = var.getAnAccess() and
      mfa.isModified() and
      mfa = fcall.getAPredecessor*() and
      ae = mfa.getEnclosingElement() and
      ae.getAnOperand().getValue().toInt() = 1
    )
  )
select fcall,
  "$@: Return value of $@ function should be verified to check for any error because variable $@ is not guaranteed to be safe.",
  fcall.getEnclosingFunction(), fcall.getEnclosingFunction().toString(), trf,
  trf.getQualifiedName().toString(), var, var.getName()

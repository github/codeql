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

signature module InputSig {
  predicate isSource(ControlFlowNode n);

  predicate isSink(ControlFlowNode n);
}

module ControlFlowReachability<InputSig Input> {
  pragma[nomagic]
  private predicate fwd(ControlFlowNode n) {
    Input::isSource(n)
    or
    exists(ControlFlowNode n0 |
      fwd(n0) and
      n0.getASuccessor() = n
    )
  }

  pragma[nomagic]
  private predicate rev(ControlFlowNode n) {
    fwd(n) and
    (
      Input::isSink(n)
      or
      exists(ControlFlowNode n1 |
        rev(n1) and
        n.getASuccessor() = n1
      )
    )
  }

  pragma[nomagic]
  private predicate prunedSuccessor(ControlFlowNode n1, ControlFlowNode n2) {
    rev(n1) and
    rev(n2) and
    n1.getASuccessor() = n2
  }

  pragma[nomagic]
  predicate isSource(ControlFlowNode n) {
    Input::isSource(n) and
    rev(n)
  }

  pragma[nomagic]
  predicate isSink(ControlFlowNode n) {
    Input::isSink(n) and
    rev(n)
  }

  pragma[nomagic]
  private predicate successorPlus(ControlFlowNode n1, ControlFlowNode n2) =
    doublyBoundedFastTC(prunedSuccessor/2, isSource/1, isSink/1)(n1, n2)

  predicate flowsTo(ControlFlowNode n1, ControlFlowNode n2) {
    successorPlus(n1, n2)
    or
    n1 = n2 and
    isSource(n1) and
    isSink(n2)
  }
}

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

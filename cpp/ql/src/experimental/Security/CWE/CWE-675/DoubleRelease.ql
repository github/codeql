/**
 * @name Errors When Double Release
 * @description Double release of the descriptor can lead to a crash of the program.
 * @kind problem
 * @id cpp/double-release
 * @problem.severity warning
 * @precision medium
 * @tags security
 *       external/cwe/cwe-675
 *       external/cwe/cwe-666
 */

import cpp
import semmle.code.cpp.commons.File
import semmle.code.cpp.valuenumbering.GlobalValueNumbering
import semmle.code.cpp.valuenumbering.HashCons

/**
 * A function call that potentially does not return (such as `exit`).
 */
class CallMayNotReturn extends FunctionCall {
  CallMayNotReturn() {
    // call that is known to not return
    not exists(this.(ControlFlowNode).getASuccessor())
    or
    // call to another function that may not return
    exists(CallMayNotReturn exit | getTarget() = exit.getEnclosingFunction())
    or
    this.(ControlFlowNode).getASuccessor() instanceof ThrowExpr
  }
}

/** Holds if there are no assignment expressions to the function argument. */
pragma[inline]
predicate checkChangeVariable(FunctionCall fc0, ControlFlowNode fc1, ControlFlowNode fc2) {
  not exists(Expr exptmp |
    (
      exptmp = fc0.getArgument(0).(VariableAccess).getTarget().getAnAssignedValue() or
      exptmp.(AddressOfExpr).getOperand() =
        fc0.getArgument(0).(VariableAccess).getTarget().getAnAccess()
    ) and
    exptmp = fc1.getASuccessor*() and
    exptmp = fc2.getAPredecessor*()
  ) and
  (
    (
      not fc0.getArgument(0) instanceof PointerFieldAccess and
      not fc0.getArgument(0) instanceof ValueFieldAccess
      or
      fc0.getArgument(0).(VariableAccess).getQualifier() instanceof ThisExpr
    )
    or
    not exists(Expr exptmp |
      (
        exptmp =
          fc0.getArgument(0)
              .(VariableAccess)
              .getQualifier()
              .(VariableAccess)
              .getTarget()
              .getAnAssignedValue() or
        exptmp.(AddressOfExpr).getOperand() =
          fc0.getArgument(0)
              .(VariableAccess)
              .getQualifier()
              .(VariableAccess)
              .getTarget()
              .getAnAccess()
      ) and
      exptmp = fc1.getASuccessor*() and
      exptmp = fc2.getAPredecessor*()
    )
  )
}

/** Holds if the underlying expression is a call to the close function. Provided that the function parameter does not change after the call. */
predicate closeReturn(FunctionCall fc) {
  fcloseCall(fc, _) and
  checkChangeVariable(fc, fc, fc.getEnclosingFunction())
}

/** Holds if the underlying expression is a call to the close function. Provided that the function parameter does not change before the call. */
predicate closeWithoutChangeBefore(FunctionCall fc) {
  fcloseCall(fc, _) and
  checkChangeVariable(fc, fc.getEnclosingFunction().getEntryPoint(), fc)
}

/** Holds, if a sequential call of the specified functions is possible, via a higher-level function call. */
predicate callInOtherFunctions(FunctionCall fc, FunctionCall fc1) {
  exists(FunctionCall fec1, FunctionCall fec2 |
    fc.getEnclosingFunction() != fc1.getEnclosingFunction() and
    fec1 = fc.getEnclosingFunction().getACallToThisFunction() and
    fec2 = fc1.getEnclosingFunction().getACallToThisFunction() and
    fec1.getASuccessor*() = fec2 and
    checkChangeVariable(fc, fec1, fec2)
  )
}

/** Holds if successive calls to close functions are possible. */
predicate interDoubleCloseFunctions(FunctionCall fc, FunctionCall fc1) {
  fcloseCall(fc, _) and
  fcloseCall(fc1, _) and
  fc != fc1 and
  fc.getASuccessor*() = fc1 and
  checkChangeVariable(fc, fc, fc1)
}

/** Holds if the first arguments of the two functions are similar. */
predicate similarArguments(FunctionCall fc, FunctionCall fc1) {
  globalValueNumber(fc.getArgument(0)) = globalValueNumber(fc1.getArgument(0))
  or
  fc.getArgument(0).(VariableAccess).getTarget() = fc1.getArgument(0).(VariableAccess).getTarget() and
  (
    not fc.getArgument(0) instanceof PointerFieldAccess and
    not fc.getArgument(0) instanceof ValueFieldAccess
    or
    fc.getArgument(0).(VariableAccess).getQualifier() instanceof ThisExpr
  )
  or
  fc.getArgument(0).(VariableAccess).getTarget() = fc1.getArgument(0).(VariableAccess).getTarget() and
  (
    fc.getArgument(0) instanceof PointerFieldAccess or
    fc.getArgument(0) instanceof ValueFieldAccess
  ) and
  hashCons(fc.getArgument(0)) = hashCons(fc1.getArgument(0))
}

from FunctionCall fc, FunctionCall fc1
where
  not fc.getASuccessor*() instanceof CallMayNotReturn and
  not exists(IfStmt ifs | ifs.getCondition().getAChild*() = fc) and
  (
    // detecting a repeated call situation within one function
    closeReturn(fc) and
    closeWithoutChangeBefore(fc1) and
    callInOtherFunctions(fc, fc1)
    or
    // detection of repeated call in different functions
    interDoubleCloseFunctions(fc, fc1)
  ) and
  similarArguments(fc, fc1)
select fc, "Second call to the $@ function is possible.", fc1, fc1.getTarget().getName()

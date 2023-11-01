/**
 * @name Missed opportunity to call wrapper function
 * @description If a wrapper function is defined for a given function, any call to the given function should be via the wrapper function.
 * @kind problem
 * @id cpp/call-to-function-without-wrapper
 * @problem.severity warning
 * @precision medium
 * @tags correctness
 *       maintainability
 *       security
 *       experimental
 *       external/cwe/cwe-1041
 */

import cpp
import semmle.code.cpp.valuenumbering.GlobalValueNumbering
import semmle.code.cpp.commons.Assertions

/**
 * A function call that is used in error situations (logging, throwing an exception, abnormal termination).
 */
class CallUsedToHandleErrors extends FunctionCall {
  CallUsedToHandleErrors() {
    // call that is known to not return
    not exists(this.(ControlFlowNode).getASuccessor())
    or
    // call throwing an exception
    this.(ControlFlowNode).getASuccessor() instanceof ThrowExpr
    or
    // call logging a message, possibly an error
    this.(ControlFlowNode).getASuccessor() instanceof FormattingFunction
    or
    // enabling recursive search
    exists(CallUsedToHandleErrors fr | this.getTarget() = fr.getEnclosingFunction())
  }
}

/** Holds if the conditions for a call outside the wrapper function are met. */
predicate conditionsOutsideWrapper(FunctionCall fcp) {
  fcp.getNumberOfArguments() > 0 and
  not fcp.getEnclosingStmt().getParentStmt*() instanceof ConditionalStmt and
  not fcp.getEnclosingStmt().getParentStmt*() instanceof Loop and
  not fcp.getEnclosingStmt().getParentStmt*() instanceof ReturnStmt and
  not exists(FunctionCall fctmp2 | fcp = fctmp2.getAnArgument().getAChild*()) and
  not exists(Assignment astmp | fcp = astmp.getRValue().getAChild*()) and
  not exists(Initializer intmp | fcp = intmp.getExpr().getAChild*()) and
  not exists(Assertion astmp | fcp = astmp.getAsserted().getAChild*()) and
  not exists(Operation optmp | fcp = optmp.getAChild*()) and
  not exists(ArrayExpr aetmp | fcp = aetmp.getAChild*()) and
  not exists(ExprCall ectmp | fcp = ectmp.getAnArgument().getAChild*())
}

/** Holds if the conditions for calling `fcp` inside the `fnp` wrapper function are met. */
pragma[inline]
predicate conditionsInsideWrapper(FunctionCall fcp, Function fnp) {
  not exists(FunctionCall fctmp2 |
    fctmp2.getEnclosingFunction() = fnp and fcp = fctmp2.getAnArgument().getAChild*()
  ) and
  not fcp instanceof CallUsedToHandleErrors and
  not fcp.getAnArgument().isConstant() and
  fcp.getEnclosingFunction() = fnp and
  fnp.getNumberOfParameters() > 0 and
  // the call arguments must be passed through the arguments of the wrapper function
  forall(int i | i in [0 .. fcp.getNumberOfArguments() - 1] |
    globalValueNumber(fcp.getArgument(i)) = globalValueNumber(fnp.getAParameter().getAnAccess())
  ) and
  // there should be no more than one required call inside the wrapper function
  not exists(FunctionCall fctmp |
    fctmp.getTarget() = fcp.getTarget() and
    fctmp.getFile() = fcp.getFile() and
    fctmp != fcp and
    fctmp.getEnclosingFunction() = fnp
  ) and
  // inside the wrapper function there should be no calls without paths to the desired function
  not exists(FunctionCall fctmp |
    fctmp.getEnclosingFunction() = fnp and
    fctmp.getFile() = fcp.getFile() and
    fctmp != fcp and
    (
      fctmp = fcp.getAPredecessor+()
      or
      not exists(FunctionCall fctmp1 |
        fctmp1 = fcp and
        (
          fctmp.getASuccessor+() = fctmp1 or
          fctmp.getAPredecessor+() = fctmp1
        )
      )
    )
  )
}

/** Holds if the conditions for the wrapper function are met. */
pragma[inline]
predicate conditionsForWrapper(FunctionCall fcp, Function fnp) {
  not exists(ExprCall ectmp | fnp = ectmp.getEnclosingFunction()) and
  not exists(Loop lp | lp.getEnclosingFunction() = fnp) and
  not exists(SwitchStmt sw | sw.getEnclosingFunction() = fnp) and
  not fnp instanceof Operator and
  // inside the wrapper function there should be checks of arguments or the result,
  // perhaps by means of passing the latter as an argument to some function
  (
    exists(IfStmt ifs |
      ifs.getEnclosingFunction() = fnp and
      (
        globalValueNumber(ifs.getCondition().getAChild*()) = globalValueNumber(fcp.getAnArgument()) and
        ifs.getASuccessor*() = fcp
        or
        ifs.getCondition().getAChild() = fcp
      )
    )
    or
    exists(FunctionCall fctmp |
      fctmp.getEnclosingFunction() = fnp and
      globalValueNumber(fctmp.getAnArgument().getAChild*()) = globalValueNumber(fcp)
    )
  ) and
  // inside the wrapper function there must be a function call to handle the error
  exists(CallUsedToHandleErrors fctmp |
    fctmp.getEnclosingFunction() = fnp and
    forall(int i | i in [0 .. fnp.getNumberOfParameters() - 1] |
      fnp.getParameter(i).getAnAccess().getTarget() =
        fcp.getAnArgument().(VariableAccess).getTarget() or
      fnp.getParameter(i).getUnspecifiedType() instanceof Class or
      fnp.getParameter(i).getUnspecifiedType().(ReferenceType).getBaseType() instanceof Class or
      fnp.getParameter(i).getAnAccess().getTarget() =
        fctmp.getAnArgument().(VariableAccess).getTarget()
    )
  )
}

from FunctionCall fc, Function fn
where
  exists(FunctionCall fctmp |
    conditionsInsideWrapper(fctmp, fn) and
    conditionsForWrapper(fctmp, fn) and
    conditionsOutsideWrapper(fc) and
    fctmp.getTarget() = fc.getTarget() and
    fc.getEnclosingFunction() != fn and
    fc.getEnclosingFunction().getMetrics().getNumberOfCalls() > fn.getMetrics().getNumberOfCalls()
  )
select fc, "Consider changing the call to $@.", fn, fn.getName()

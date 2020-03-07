/**
 * @name Ignoring result from pure array method
 * @description Ignoring the result of an array method that does not modify its receiver is generally an error.
 * @kind problem
 * @problem.severity warning
 * @id js/ignore-array-result
 * @tags maintainability
 *       correctness
 * @precision high
 */

import javascript
import Expressions.ExprHasNoEffect

DataFlow::SourceNode callsArray(DataFlow::TypeBackTracker t, DataFlow::MethodCallNode call) {
  isIgnoredPureArrayCall(call) and
  t.start() and
  result = call.getReceiver().getALocalSource()
  or
  exists(DataFlow::TypeBackTracker t2 | result = callsArray(t2, call).backtrack(t2, t))
}

DataFlow::SourceNode callsArray(DataFlow::MethodCallNode call) {
  result = callsArray(DataFlow::TypeBackTracker::end(), call)
}

predicate isIgnoredPureArrayCall(DataFlow::MethodCallNode call) {
  inVoidContext(call.asExpr()) and
  (
    call.getMethodName() = "concat" and
    call.getNumArgument() = 1
    or
    call.getMethodName() = "join" and
    call.getNumArgument() < 2
    or
    call.getMethodName() = "slice" and
    call.getNumArgument() < 3
  )
}

from DataFlow::MethodCallNode call
where
  callsArray(call) instanceof DataFlow::ArrayCreationNode and
  not call.getReceiver().asExpr().(ArrayExpr).getSize() = 0
select call, "Result from call to " + call.getMethodName() + " ignored."

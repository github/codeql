/**
 * @name Missing return value gets used
 * @description Calling a function that doesn't return a value, in a context where that
 *              value is not used, indicates a potential error, as the used value will
 *              be undefined.
 * @kind problem
 * @problem.severity warning
 * @id js/use-of-missing-return-value
 * @precision very-high
 * @tag correctness
 */

import javascript
import semmle.javascript.dataflow.Nodes

/*
 * A function with no return value can be called without being problematic under the following
 * conditions on the internal properties of the function:
 *
 * - When the function is completely empty and has no statements in it
 * - When the function is in an error function (TODO)
 */

predicate canBeUsedWithNoReturnValue(Function f) {
  isEmpty(f)
  or
  isErrorFunction(f)
}

predicate isEmpty(Function f) { 0 = f.getNumBodyStmt() }

predicate isErrorFunction(Function f) { none() }


/*
 * We have a problem when we have a function call `call`, which calls `calleeRef`,
 * which refers to the function `callee`, which itself can return nothing, but
 * `call` is neither one of the designated functions that are permitted to return
 * nothing, nor is it in a position that allows it to return nothing.
 */

from CallNode call, Expr calleeRef, Function callee, ConcreteControlFlowNode undefinedReturn
where calleeRef = call.getCalleeNode().asExpr() and
      callee = call.getACallee() and
      not canBeUsedWithNoReturnValue(callee) and
      call.asExpr().inNullSensitiveContext() and
      undefinedReturn = callee.getAnUndefinedReturn()
select call,
  "This function application is used in a context where its value matters, and it calls $@, which is defined as $@, but this can return nothing by executing this last: $@",
  calleeRef, calleeRef.toString(), callee, callee.toString(), undefinedReturn,
  undefinedReturn.toString()

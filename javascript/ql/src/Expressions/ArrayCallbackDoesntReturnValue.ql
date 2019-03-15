/**
 * @name Array Callback Doesn't Return Value
 * @description Array callbacks like `map` and `filter` expect a value to be returned, so code
 *              should never omit a return value in any execution path.
 * @kind problem
 * @problem.severity warning
 * @id js/array-callback-doesnt-return-value
 * @precision very-high
 * @tag correctness
 */

import javascript
import semmle.javascript.dataflow.Nodes

/**
 * An array callback method name is just the name of those array methods which take
 * callbacks that return values (as opposed to ones that don'e return values, i.e.
 * `forEach`).
 */

predicate isArrayCallbackMethodName(string n) {
  n = "from" or
  n = "every" or
  n = "filter" or
  n = "find" or
  n = "findIndex" or
  n = "map" or
  n = "reduce" or
  n = "reduceRight" or
  n = "some" or
  n = "sort"
}

/*
 * We have a problem when there is a method application `application`, which
 * is given a callback argument `callbackRef`, which refers to the callback
 * function `callback` that can return nothing via the control flow node
 * `returnOfNothing`.
 */

from
     CallNode application
   , string methodName
   , Expr callbackRef
   , Function callback
   , ConcreteControlFlowNode undefinedReturn
where
      not application.getTopLevel().isMinified()
  and isArrayCallbackMethodName(methodName)
  and methodName = application.getCalleeNode().asExpr().(PropAccess).getPropertyName()
  and callbackRef = application.getAnArgument().asExpr()
  and exists(DataFlow::SourceNode src | src.flowsToExpr(callbackRef) | callback = src.getAstNode()) //callbackRef refers to callback
  and undefinedReturn = callback.getAnUndefinedReturn()
select
       application
     , "This method application calls the method `" + methodName + "` which expects its callback to return a value, and has the callback argument $@, which is defined as $@, but this definition can return nothing by executing this last: $@"
     , callbackRef, callbackRef.toString()
     , callback, callback.toString()
     , undefinedReturn, undefinedReturn.toString()
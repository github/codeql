/**
 * @name ForEach Callback Returns Value
 * @description The `forEach` method's callback should not return a value because `forEach`
 *              discards them.
 * @kind problem
 * @problem.severity warning
 * @id js/foreach-callback-returns-value
 * @precision very-high
 * @tag correctness
 */

import javascript
import semmle.javascript.dataflow.Nodes

from
     CallNode application
   , Expr callbackRef
   , Function callback
   , Expr returnVal
where
      not application.getTopLevel().isMinified()
  and "forEach" = application.getCalleeNode().asExpr().(PropAccess).getPropertyName()
  and callbackRef = application.getAnArgument().asExpr()
  and exists(DataFlow::SourceNode src | src.flowsToExpr(callbackRef) | callback = src.getAstNode()) //callbackRef refers to callback
  and returnVal = callback.getAReturnedExpr()
select
       application
     , "This method application has the callback argument $@, which is expected to not return any values, but its definitions is $@, which returns the value $@"
     , callbackRef, callbackRef.toString()
     , callback, callback.toString()
     , returnVal, returnVal.toString()
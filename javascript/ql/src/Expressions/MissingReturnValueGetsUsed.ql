/**
 * @name Missing Return Value Gets Used
 * @description A call to a function that doesn't return a value is used in a context where the
 *              value of the call actually matters.
 * @kind problem
 * @problem.severity warning
 * @id js/missing-return-value-gets-used
 * @precision very-high
 * @tag correctness
 */

import javascript
import semmle.javascript.CFG
 
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
 * A function with no return value can be called without being problematic under the following
 * conditions on the external properties of the context of the function call:
 * 
 * - As a statement, b/c the function is used for its side effects only
 * - In an immediately invoked function expression (IIFE)
 * - When the application is immediately returned
 * - When the application is in a void expression
 */

predicate isValidCallOfNoReturnFunction(CallExpr call) {
  isInExprStmt(call)
  or
  isIife(call)
  or
  isInReturnExpr(call)
  or
  isInVoidExpr(call)
}

predicate isInExprStmt(CallExpr call) { call.getParent() instanceof ExprStmt }

predicate isIife(CallExpr call) { call.getCallee().stripParens() instanceof Function }

predicate isInReturnExpr(Expr call) { call.getParent() instanceof ReturnStmt }

predicate isInVoidExpr(Expr call) { call.getParent() instanceof VoidExpr }


/*
 * We have a problem when we have a function call `call`, which calls `calleeRef`,
 * which refers to the function `callee`, which itself can return nothing, but
 * `call` is neither one of the designated functions that are permitted to return
 * nothing, nor is it in a position that allows it to return nothing.
 */

from
     CallExpr call
   , Expr calleeRef
   , Function callee
   , ConcreteControlFlowNode undefinedReturn
where
      not call.getTopLevel().isMinified()
  and call.getCallee() = calleeRef
  and exists(DataFlow::SourceNode src | src.flowsToExpr(calleeRef) | callee = src.getAstNode()) //calleeRef refers to callee
  and not isValidCallOfNoReturnFunction(call)
  and not canBeUsedWithNoReturnValue(callee)
  and callee.getAnUndefinedReturn() = undefinedReturn
select
       call
     , "This function application is used in a context where its value matters, and it calls $@, which is defined as $@, but this can return nothing by executing this last: $@"
     , calleeRef, calleeRef.toString()
     , callee, callee.toString()
     , undefinedReturn, undefinedReturn.toString()

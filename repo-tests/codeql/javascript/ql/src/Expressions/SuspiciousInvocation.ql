/**
 * @name Invocation of non-function
 * @description Trying to invoke a value that is not a function will result
 *              in a runtime exception.
 * @kind problem
 * @problem.severity error
 * @id js/call-to-non-callable
 * @tags correctness
 *       external/cwe/cwe-476
 * @precision high
 */

import javascript
private import semmle.javascript.dataflow.InferredTypes

from InvokeExpr invk, DataFlow::AnalyzedNode callee
where
  callee.asExpr() = invk.getCallee() and
  forex(InferredType tp | tp = callee.getAType() | tp != TTFunction() and tp != TTClass()) and
  not invk.isAmbient() and
  not invk instanceof OptionalUse
select invk, "Callee is not a function: it has type " + callee.ppTypes() + "."

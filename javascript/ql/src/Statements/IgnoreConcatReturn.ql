/**
 * @name Ignoring return from concat
 * @description The concat method does not modify an array, ignoring the result of a call to concat is therefore generally an error.
 * @kind problem
 * @problem.severity warning
 * @id js/ignore-result-from-concat
 * @tags maintainability,
 *       correctness
 * @precision high
 */

import javascript
import Expressions.ExprHasNoEffect

DataFlow::SourceNode array(DataFlow::TypeTracker t) {
  t.start() and
  result instanceof DataFlow::ArrayCreationNode
  or
  exists (DataFlow::TypeTracker t2 |
    result = array(t2).track(t2, t)
  )
}

DataFlow::SourceNode array() { result = array(DataFlow::TypeTracker::end()) }

predicate isArrayMethod(DataFlow::MethodCallNode call) {
  call.getReceiver().getALocalSource() = array()
}

predicate isIncomplete(DataFlow::Node node) {
  any(DataFlow::Incompleteness cause | node.analyze().getAValue().isIndefinite(cause)) != "global"
}

from DataFlow::CallNode call
where 
  isArrayMethod(call) and
  call.getCalleeName() = "concat" and
  call.getNumArgument() = 1 and 
  (call.getArgument(0).getALocalSource() = array() or isIncomplete(call.getArgument(0))) and 
  not call.getArgument(0).asExpr().(ArrayExpr).getSize() = 0 and 
  inVoidContext(call.asExpr())
select call, "Return value from call to concat ignored."

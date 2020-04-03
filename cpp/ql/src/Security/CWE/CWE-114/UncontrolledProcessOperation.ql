/**
 * @name Uncontrolled process operation
 * @description Using externally controlled strings in a process
 *              operation can allow an attacker to execute malicious
 *              commands.
 * @kind path-problem
 * @problem.severity warning
 * @precision medium
 * @id cpp/uncontrolled-process-operation
 * @tags security
 *       external/cwe/cwe-114
 */

import cpp
import semmle.code.cpp.security.Security
import semmle.code.cpp.security.TaintTracking
import TaintedWithPath

predicate isProcessOperationExplanation(Expr arg, string processOperation) {
  exists(int processOperationArg, FunctionCall call |
    isProcessOperationArgument(processOperation, processOperationArg) and
    call.getTarget().getName() = processOperation and
    call.getArgument(processOperationArg) = arg
  )
}

class Configuration extends TaintTrackingConfiguration {
  override predicate isSink(Element arg) { isProcessOperationExplanation(arg, _) }
}

from string processOperation, Expr arg, Expr source, PathNode sourceNode, PathNode sinkNode
where
  isProcessOperationExplanation(arg, processOperation) and
  taintedWithPath(source, arg, sourceNode, sinkNode)
select arg, sourceNode, sinkNode,
  "The value of this argument may come from $@ and is being passed to " + processOperation, source,
  source.toString()

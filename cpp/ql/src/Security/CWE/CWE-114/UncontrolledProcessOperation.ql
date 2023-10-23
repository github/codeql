/**
 * @name Uncontrolled process operation
 * @description Using externally controlled strings in a process
 *              operation can allow an attacker to execute malicious
 *              commands.
 * @kind path-problem
 * @problem.severity warning
 * @security-severity 8.2
 * @precision medium
 * @id cpp/uncontrolled-process-operation
 * @tags security
 *       external/cwe/cwe-114
 */

import cpp
import semmle.code.cpp.security.Security
import semmle.code.cpp.security.FlowSources
import semmle.code.cpp.ir.dataflow.TaintTracking
import semmle.code.cpp.ir.IR
import Flow::PathGraph

predicate isProcessOperationExplanation(DataFlow::Node arg, string processOperation) {
  exists(int processOperationArg, FunctionCall call |
    isProcessOperationArgument(processOperation, processOperationArg) and
    call.getTarget().getName() = processOperation and
    call.getArgument(processOperationArg) = [arg.asExpr(), arg.asIndirectExpr()]
  )
}

module Config implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node node) {
    node instanceof FlowSource and not node instanceof DataFlow::ExprNode
  }

  predicate isSink(DataFlow::Node node) { isProcessOperationExplanation(node, _) }

  predicate isBarrier(DataFlow::Node node) {
    isSink(node) and node.asExpr().getUnspecifiedType() instanceof ArithmeticType
    or
    node.asInstruction().(StoreInstruction).getResultType() instanceof ArithmeticType
  }
}

module Flow = TaintTracking::Global<Config>;

from
  string processOperation, DataFlow::Node source, DataFlow::Node sink, Flow::PathNode sourceNode,
  Flow::PathNode sinkNode
where
  source = sourceNode.getNode() and
  sink = sinkNode.getNode() and
  isProcessOperationExplanation(sink, processOperation) and
  Flow::flowPath(sourceNode, sinkNode)
select sink, sourceNode, sinkNode,
  "The value of this argument may come from $@ and is being passed to " + processOperation + ".",
  source, source.toString()

/**
 * @name Uncontrolled format string
 * @description Using externally-controlled format strings in
 *              printf-style functions can lead to buffer overflows
 *              or data representation problems.
 * @kind path-problem
 * @problem.severity warning
 * @precision high
 * @id cpp/tainted-format-string
 * @tags reliability
 *       security
 *       external/cwe/cwe-134
 */

import cpp
import semmle.code.cpp.ir.dataflow.TaintTracking
import DataFlow::PathGraph
import semmle.code.cpp.security.FunctionWithWrappers
import semmle.code.cpp.security.FlowSources

class UncontrolledFormatStringConfiguration extends TaintTracking::Configuration {
  UncontrolledFormatStringConfiguration() { this = "UncontrolledFormatStringConfiguration" }

  override predicate isSource(DataFlow::Node node) {
    node instanceof RemoteFlowSource
    or
    // Even locally-sourced format strings can cause crashes or information leaks
    node instanceof LocalFlowSource
  }

  override predicate isSink(DataFlow::Node node) {
    exists(PrintfLikeFunction printf |
      printf.outermostWrapperFunctionCall(node.asArgumentIndirection(), _)
      or
      printf.outermostWrapperFunctionCall(node.asConvertedExpr(), _)
    )
  }
}

from
  PrintfLikeFunction printf, DataFlow::PathNode sourceNode, DataFlow::PathNode sinkNode,
  string printfFunction, string cause, UncontrolledFormatStringConfiguration conf
where
  (
    printf.outermostWrapperFunctionCall(sinkNode.getNode().asArgumentIndirection(), printfFunction) or
    printf.outermostWrapperFunctionCall(sinkNode.getNode().asConvertedExpr(), printfFunction)
  ) and
  (
    cause = sourceNode.getNode().(RemoteFlowSource).getSourceType()
    or
    cause = sourceNode.getNode().(LocalFlowSource).getSourceType()
  ) and
  conf.hasFlowPath(sourceNode, sinkNode)
select sinkNode, sourceNode, sinkNode,
  "The value of this argument may come from $@ and is being used as a formatting argument to " +
    printfFunction, sourceNode, cause

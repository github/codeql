/**
 * @name Cleartext storage of sensitive information in buffer
 * @description Storing sensitive information in cleartext can expose it
 *              to an attacker.
 * @kind path-problem
 * @problem.severity warning
 * @security-severity 7.5
 * @precision medium
 * @id cpp/cleartext-storage-buffer
 * @tags security
 *       external/cwe/cwe-312
 */

import cpp
import semmle.code.cpp.security.BufferWrite as BufferWrite
import semmle.code.cpp.security.SensitiveExprs
import semmle.code.cpp.security.Security
import semmle.code.cpp.ir.dataflow.TaintTracking
import DataFlow::PathGraph

Expr exprForNode(DataFlow::Node n) {
  n = DataFlow::exprNode(result)
  or
  // (similar to DefaultTaintTracking's `getNodeForExpr`)
  n = DataFlow::definitionByReferenceNodeFromArgument(result) and
  not argv(result.(VariableAccess).getTarget())
}

/**
 * Taint flow from user input to a buffer write.
 */
class ToBufferConfiguration extends TaintTracking::Configuration {
  ToBufferConfiguration() { this = "ToBufferConfiguration" }

  override predicate isSource(DataFlow::Node source) { isUserInput(exprForNode(source), _) }

  override predicate isSink(DataFlow::Node sink) {
    exists(BufferWrite::BufferWrite w | w.getASource() = sink.asExpr())
  }
}

from
  ToBufferConfiguration config, BufferWrite::BufferWrite w, Expr taintSource,
  DataFlow::PathNode sourceNode, DataFlow::PathNode sinkNode, string taintCause, SensitiveExpr dest
where
  config.hasFlowPath(sourceNode, sinkNode) and
  taintSource = exprForNode(sourceNode.getNode()) and
  w.getASource() = sinkNode.getNode().asExpr() and
  isUserInput(taintSource, taintCause) and
  dest = w.getDest()
select w, sourceNode, sinkNode,
  "This write into buffer '" + dest.toString() + "' may contain unencrypted data from $@",
  taintSource, "user input (" + taintCause + ")"

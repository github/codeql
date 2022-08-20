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
import semmle.code.cpp.security.FlowSources
import semmle.code.cpp.ir.dataflow.TaintTracking
import DataFlow::PathGraph

/**
 * Taint flow from user input to a buffer write.
 */
class ToBufferConfiguration extends TaintTracking::Configuration {
  ToBufferConfiguration() { this = "ToBufferConfiguration" }

  override predicate isSource(DataFlow::Node source) { source instanceof FlowSource }

  override predicate isSink(DataFlow::Node sink) {
    exists(BufferWrite::BufferWrite w | w.getASource() = sink.asExpr())
  }
}

from
  ToBufferConfiguration config, BufferWrite::BufferWrite w, DataFlow::PathNode sourceNode,
  DataFlow::PathNode sinkNode, FlowSource source, SensitiveExpr dest
where
  config.hasFlowPath(sourceNode, sinkNode) and
  sourceNode.getNode() = source and
  w.getASource() = sinkNode.getNode().asExpr() and
  dest = w.getDest()
select w, sourceNode, sinkNode,
  "This write into buffer '" + dest.toString() + "' may contain unencrypted data from $@", source,
  "user input (" + source.getSourceType() + ")"

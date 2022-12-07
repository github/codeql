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
 * A buffer write into a sensitive expression.
 */
class SensitiveBufferWrite extends Expr instanceof BufferWrite::BufferWrite {
  SensitiveBufferWrite() { super.getDest() instanceof SensitiveExpr }

  /**
   * Gets a data source of this operation.
   */
  Expr getASource() { result = super.getASource() }

  /**
   * Gets the destination buffer of this operation.
   */
  Expr getDest() { result = super.getDest() }
}

/**
 * A taint flow configuration for flow from user input to a buffer write
 * into a sensitive expression.
 */
class ToBufferConfiguration extends TaintTracking::Configuration {
  ToBufferConfiguration() { this = "ToBufferConfiguration" }

  override predicate isSource(DataFlow::Node source) { source instanceof FlowSource }

  override predicate isSanitizer(DataFlow::Node node) {
    node.asExpr().getUnspecifiedType() instanceof IntegralType
  }

  override predicate isSink(DataFlow::Node sink) {
    exists(SensitiveBufferWrite w | w.getASource() = sink.asExpr())
  }
}

from
  ToBufferConfiguration config, SensitiveBufferWrite w, DataFlow::PathNode sourceNode,
  DataFlow::PathNode sinkNode, FlowSource source
where
  config.hasFlowPath(sourceNode, sinkNode) and
  sourceNode.getNode() = source and
  w.getASource() = sinkNode.getNode().asExpr()
select w, sourceNode, sinkNode,
  "This write into buffer '" + w.getDest().toString() + "' may contain unencrypted data from $@.",
  source, "user input (" + source.getSourceType() + ")"

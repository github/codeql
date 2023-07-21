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
import ToBufferFlow::PathGraph

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
module ToBufferConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof FlowSource }

  predicate isBarrier(DataFlow::Node node) {
    node.asExpr().getUnspecifiedType() instanceof IntegralType
  }

  predicate isSink(DataFlow::Node sink) { isSinkImpl(sink, _) }
}

module ToBufferFlow = TaintTracking::Global<ToBufferConfig>;

predicate isSinkImpl(DataFlow::Node sink, SensitiveBufferWrite w) {
  w.getASource() = sink.asIndirectExpr()
}

from
  SensitiveBufferWrite w, ToBufferFlow::PathNode sourceNode, ToBufferFlow::PathNode sinkNode,
  FlowSource source
where
  ToBufferFlow::flowPath(sourceNode, sinkNode) and
  sourceNode.getNode() = source and
  isSinkImpl(sinkNode.getNode(), w)
select w, sourceNode, sinkNode,
  "This write into buffer '" + w.getDest().toString() + "' may contain unencrypted data from $@.",
  source, "user input (" + source.getSourceType() + ")"

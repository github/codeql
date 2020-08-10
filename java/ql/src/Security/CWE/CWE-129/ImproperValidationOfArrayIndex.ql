/**
 * @name Improper validation of user-provided array index
 * @description Using external input as an index to an array, without proper validation, can lead to index out of bound exceptions.
 * @kind path-problem
 * @problem.severity warning
 * @precision medium
 * @id java/improper-validation-of-array-index
 * @tags security
 *       external/cwe/cwe-129
 */

import java
import ArraySizing
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.dataflow.TaintTrackingOneConf
import DataFlowOneConf::PathGraph

class Conf extends TaintTrackingOneConf::Configuration {
  override predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node sink) {
    any(CheckableArrayAccess caa).canThrowOutOfBounds(sink.asExpr())
  }

  override predicate isSanitizer(DataFlow::Node node) { node.getType() instanceof BooleanType }
}

from DataFlowOneConf::PathNode source, DataFlowOneConf::PathNode sink, CheckableArrayAccess arrayAccess
where
  arrayAccess.canThrowOutOfBounds(sink.getNode().asExpr()) and
  any(Conf conf).hasFlowPath(source, sink)
select arrayAccess.getIndexExpr(), source, sink,
  "$@ flows to here and is used as an index causing an ArrayIndexOutOfBoundsException.",
  source.getNode(), "User-provided value"

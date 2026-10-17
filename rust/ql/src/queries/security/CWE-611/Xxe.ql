/**
 * @name XML external entity expansion
 * @description Parsing user-controlled XML with external entity expansion
 *              enabled may lead to disclosure of confidential data or
 *              server-side request forgery.
 * @kind path-problem
 * @problem.severity error
 * @security-severity 9.1
 * @precision high
 * @id rust/xxe
 * @tags security
 *       external/cwe/cwe-611
 *       external/cwe/cwe-776
 *       external/cwe/cwe-827
 */

import rust
import codeql.rust.dataflow.DataFlow
import codeql.rust.dataflow.TaintTracking
import codeql.rust.security.XxeExtensions

/**
 * A taint configuration for user-controlled data reaching an XML parser with
 * external entity expansion enabled.
 */
module XxeConfig implements DataFlow::ConfigSig {
  import Xxe

  predicate isSource(DataFlow::Node node) { node instanceof Source }

  predicate isSink(DataFlow::Node node) { node instanceof Sink }

  predicate isBarrier(DataFlow::Node barrier) { barrier instanceof Barrier }

  predicate isAdditionalFlowStep(DataFlow::Node pred, DataFlow::Node succ) {
    // we need flow through casts as a *value* step, not just the default taint step,
    // to get flow on reference content when the pointer itself is cast.
    pred.asExpr() = succ.asExpr().(CastExpr).getExpr()
  }

  predicate observeDiffInformedIncrementalMode() { any() }
}

module XxeFlow = TaintTracking::Global<XxeConfig>;

import XxeFlow::PathGraph

from XxeFlow::PathNode sourceNode, XxeFlow::PathNode sinkNode
where XxeFlow::flowPath(sourceNode, sinkNode)
select sinkNode.getNode(), sourceNode, sinkNode,
  "XML parsing depends on a $@ without guarding against external entity expansion.",
  sourceNode.getNode(), "user-provided value"

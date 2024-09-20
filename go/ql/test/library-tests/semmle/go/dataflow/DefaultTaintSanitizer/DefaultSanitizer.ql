/**
 * @description Check that DefaultTaintSanitizer instances prevent taint flow.
 * @kind path-problem
 */

import go
import codeql.dataflow.test.ProvenancePathGraph
import semmle.go.dataflow.ExternalFlow

module Config implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node n) { n instanceof RemoteFlowSource }

  predicate isSink(DataFlow::Node n) { any(ReturnStmt s).getAnExpr() = n.asExpr() }
}

module Flow = TaintTracking::Global<Config>;

import ShowProvenance<interpretModelForTest/2, Flow::PathNode, Flow::PathGraph>

from Flow::PathNode source, Flow::PathNode sink
where Flow::flowPath(source, sink)
select sink.getNode(), source, sink, "Found taint flow"

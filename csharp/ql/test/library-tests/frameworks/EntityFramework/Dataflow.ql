/**
 * @kind path-problem
 */

import csharp
import utils.test.ProvenancePathGraph::ShowProvenance<Taint::PathNode, Taint::PathGraph>

module TaintConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node node) { node.asExpr().getValue() = "tainted" }

  predicate isSink(DataFlow::Node node) {
    node.asExpr() = any(MethodCall c | c.getTarget().hasName("Sink")).getAnArgument()
  }
}

module Taint = TaintTracking::Global<TaintConfig>;

from Taint::PathNode source, Taint::PathNode sink
where Taint::flowPath(source, sink)
select sink, source, sink, "$@", source, source.toString()

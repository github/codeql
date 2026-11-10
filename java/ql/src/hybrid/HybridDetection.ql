/**
 * @name Query for Hybrid detection.
 * @description Detects vulnerabilities based on AI generated sources and sinks.
 * @kind path-problem
 * @problem.severity error
 * @precision low
 * @id java/hybrid-detection
 */

import java
import semmle.code.java.dataflow.TaintTracking
import semmle.code.java.dataflow.ExternalFlow
import TaintFlow::PathGraph

module FlowConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node n) { sourceNode(n, "ai-candidate") }

  predicate isSink(DataFlow::Node n) {
    exists(string kind | sinkNode(n, kind) and kind.matches("ai-candidate%"))
  }
}

module TaintFlow = TaintTracking::Global<FlowConfig>;

from TaintFlow::PathNode source, TaintFlow::PathNode sink
where TaintFlow::flowPath(source, sink)
select sink.getNode(), source, sink, "Flow from AI-generated $@ to AI-generated sink.",
  source.getNode(), "source"

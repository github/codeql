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
import semmle.code.java.security.Sanitizers
import TaintFlow::PathGraph

string getCwe(DataFlow::Node n) {
  exists(string s | sinkNode(n, s) and result = s.regexpCapture("ai-candidate-cwe-(.*)", 1))
}

module FlowConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node n) { sourceNode(n, "ai-candidate") }

  predicate isBarrier(DataFlow::Node n) { n instanceof SimpleTypeSanitizer }

  predicate isSink(DataFlow::Node n) {
    exists(string kind | sinkNode(n, kind) and kind.matches("ai-candidate%"))
  }
}

module TaintFlow = TaintTracking::Global<FlowConfig>;

from TaintFlow::PathNode source, TaintFlow::PathNode sink
where TaintFlow::flowPath(source, sink)
select sink.getNode(), source, sink,
  "Hybrid detection for CWE " + getCwe(sink.getNode()) + " from $@.", source.getNode(), "source"

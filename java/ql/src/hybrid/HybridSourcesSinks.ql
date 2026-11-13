import java
import semmle.code.java.dataflow.TaintTracking
import semmle.code.java.dataflow.ExternalFlow
import semmle.code.java.dataflow.ApiSinks
import semmle.code.java.dataflow.FlowSources

/**
 * This query identifies sink nodes that has CodeQL sinks but wasn't identified
 * as sinks using the AI-generated sink detection.
 */
query predicate missingSinks(SinkNode n) {
  not exists(string s | sinkNode(n, s) and s.matches("ai-candidate%"))
}

query predicate missingSources(ActiveThreatModelSource n) {
  not exists(string s | sourceNode(n, s) and s.matches("ai-candidate%"))
}

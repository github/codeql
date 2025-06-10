/**
 * Taint reach computation. Taint reach is the proportion of all dataflow nodes that can be reached
 * via taint flow from any active thread model source. It's usually expressed per million nodes.
 */

import rust
private import codeql.rust.Concepts
private import codeql.rust.dataflow.DataFlow
private import codeql.rust.dataflow.TaintTracking
private import codeql.rust.dataflow.internal.Node

/**
 * A taint configuration for taint reach (flow to any node from any modeled source).
 */
private module TaintReachConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node node) { node instanceof ActiveThreatModelSource }

  predicate isSink(DataFlow::Node node) { any() }
}

private module TaintReachFlow = TaintTracking::Global<TaintReachConfig>;

/**
 * Gets the total number of data flow nodes that taint reaches (from any source).
 *
 * We don't include flow summary nodes, as their number is unstable (varies when models
 * are added).
 */
int getTaintedNodesCount() { result = count(DataFlow::Node n | TaintReachFlow::flowTo(n) and not n instanceof FlowSummaryNode) }

/**
 * Gets the proportion of data flow nodes that taint reaches (from any source),
 * expressed as a count per million nodes.
 *
 * We don't include flow summary nodes, as their number is unstable (varies when models
 * are added).
 */
float getTaintReach() { result = (getTaintedNodesCount() * 1000000.0) / count(DataFlow::Node n |  not n instanceof FlowSummaryNode) }

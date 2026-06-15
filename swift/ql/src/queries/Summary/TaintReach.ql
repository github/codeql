/**
 * @name Taint Reach
 * @description Calculates 'taint reach', a measure of how much of a database
 *              is reached from flow sources, via taint flow. This can be
 *              expensive to compute on large databases.
 * @kind table
 * @id swift/summary/taint-reach
 * @tags summary
 */

import swift
import codeql.swift.dataflow.FlowSources
import codeql.swift.dataflow.DataFlow
import codeql.swift.dataflow.TaintTracking

/**
 * A taint configuration for tainted data reaching any node.
 */
module TaintReachConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node node) { node instanceof FlowSource }

  predicate isSink(DataFlow::Node node) { any() }
}

module TaintReachFlow = TaintTracking::Global<TaintReachConfig>;

/**
 * Gets the total number of dataflow nodes that taint reaches (from any source).
 */
int taintedNodesCount() { result = count(DataFlow::Node n | TaintReachFlow::flowTo(n)) }

/**
 * Gets the proportion of dataflow nodes that taint reaches (from any source),
 * expressed as a count per million nodes.
 */
float taintReach() { result = (taintedNodesCount() * 1000000.0) / count(DataFlow::Node n) }

predicate statistic(string what, string value) {
  what = "Dataflow nodes (total)" and value = count(DataFlow::Node n).toString()
  or
  what = "Dataflow nodes (tainted)" and value = taintedNodesCount().toString()
  or
  what = "Taint reach (per million nodes)" and value = taintReach().toString()
}

from string what, string value
where statistic(what, value)
select what, value

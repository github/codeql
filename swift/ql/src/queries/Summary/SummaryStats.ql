/**
 * @name Summary statistics
 * @description A table of summary statistics about a database.
 * @kind table
 * @id swift/summary/summary-statistics
 * @tags summary
 */

import swift
import codeql.swift.dataflow.FlowSources
import codeql.swift.security.SensitiveExprs
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
  what = "Files" and value = count(File f).toString()
  or
  what = "Expressions" and value = count(Expr e | not e.getFile() instanceof UnknownFile).toString()
  or
  what = "Local flow sources" and value = count(LocalFlowSource s).toString()
  or
  what = "Remote flow sources" and value = count(RemoteFlowSource s).toString()
  or
  what = "Sensitive expressions" and value = count(SensitiveExpr e).toString()
  or
  what = "Dataflow nodes (total)" and value = count(DataFlow::Node n).toString()
  or
  what = "Dataflow nodes (tainted)" and value = taintedNodesCount().toString()
  or
  what = "Taint reach (per million nodes)" and value = taintReach().toString()
}

from string what, string value
where statistic(what, value)
select what, value

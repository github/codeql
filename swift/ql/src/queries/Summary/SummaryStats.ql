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
class TaintReachConfig extends TaintTracking::Configuration {
  TaintReachConfig() { this = "TaintReachConfig" }

  override predicate isSource(DataFlow::Node node) { node instanceof FlowSource }

  override predicate isSink(DataFlow::Node node) { any() }
}

float taintReach() {
  exists(TaintReachConfig config, int tainted, int total |
    tainted = count(DataFlow::Node n | config.hasFlowTo(n)) and
    total = count(DataFlow::Node n) and
    result = (tainted * 1000000.0) / total
  )
}

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
  what = "Taint reach (per million nodes)" and value = taintReach().toString()
}

from string what, string value
where statistic(what, value)
select what, value

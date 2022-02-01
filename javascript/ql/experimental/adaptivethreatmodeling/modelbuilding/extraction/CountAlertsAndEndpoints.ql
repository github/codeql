/*
 * For internal use only.
 *
 * [DEPRECATED] Counts alerts and sinks for JavaScript security queries.
 *
 * This query is deprecated due to the performance implications of bringing in data flow
 * configurations from multiple queries. Instead use `CountSourcesAndSinks.ql` to count sinks for
 * JavaScript security queries, and count alerts by running the standard or evaluation queries for
 * each security vulnerability.
 */

import semmle.javascript.security.dataflow.NosqlInjection
import semmle.javascript.security.dataflow.SqlInjection
import semmle.javascript.security.dataflow.TaintedPath
import semmle.javascript.security.dataflow.DomBasedXss

int numAlerts(DataFlow::Configuration cfg) {
  result = count(DataFlow::Node source, DataFlow::Node sink | cfg.hasFlow(source, sink))
}

select numAlerts(any(NosqlInjection::Configuration cfg)) as numNosqlAlerts,
  numAlerts(any(SqlInjection::Configuration cfg)) as numSqlAlerts,
  numAlerts(any(TaintedPath::Configuration cfg)) as numTaintedPathAlerts,
  numAlerts(any(DomBasedXss::Configuration cfg)) as numXssAlerts,
  count(NosqlInjection::Sink sink) as numNosqlSinks, count(SqlInjection::Sink sink) as numSqlSinks,
  count(TaintedPath::Sink sink) as numTaintedPathSinks, count(DomBasedXss::Sink sink) as numXssSinks

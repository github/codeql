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
import semmle.javascript.security.dataflow.StoredXss
import semmle.javascript.security.dataflow.XssThroughDom
import evaluation.EndToEndEvaluation

int numAlerts(DataFlow::Configuration cfg) {
  result =
    count(DataFlow::Node source, DataFlow::Node sink |
      cfg.hasFlow(source, sink) and not isFlowExcluded(source, sink)
    )
}

select numAlerts(any(NosqlInjection::Configuration cfg)) as numNosqlAlerts,
  numAlerts(any(SqlInjection::Configuration cfg)) as numSqlAlerts,
  numAlerts(any(TaintedPath::Configuration cfg)) as numTaintedPathAlerts,
  numAlerts(any(DomBasedXss::Configuration cfg)) as numXssAlerts,
  numAlerts(any(StoredXss::Configuration cfg)) as numStoredXssAlerts,
  numAlerts(any(XssThroughDom::Configuration cfg)) as numXssThroughDomAlerts,
  count(DataFlow::Node sink |
    exists(NosqlInjection::Configuration cfg | cfg.isSink(sink) or cfg.isSink(sink, _))
  ) as numNosqlSinks,
  count(DataFlow::Node sink |
    exists(SqlInjection::Configuration cfg | cfg.isSink(sink) or cfg.isSink(sink, _))
  ) as numSqlSinks,
  count(DataFlow::Node sink |
    exists(TaintedPath::Configuration cfg | cfg.isSink(sink) or cfg.isSink(sink, _))
  ) as numTaintedPathSinks,
  count(DataFlow::Node sink |
    exists(DomBasedXss::Configuration cfg | cfg.isSink(sink) or cfg.isSink(sink, _))
  ) as numXssSinks,
  count(DataFlow::Node sink |
    exists(StoredXss::Configuration cfg | cfg.isSink(sink) or cfg.isSink(sink, _))
  ) as numStoredXssSinks,
  count(DataFlow::Node sink |
    exists(XssThroughDom::Configuration cfg | cfg.isSink(sink) or cfg.isSink(sink, _))
  ) as numXssThroughDomSinks

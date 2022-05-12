/*
 * For internal use only.
 *
 *
 * Count the number of sinks and alerts for the `SqlInection` security query.
 */

import javascript
import semmle.javascript.security.dataflow.SqlInjectionQuery as SqlInjection
import evaluation.EndToEndEvaluation

int numAlerts(DataFlow::Configuration cfg) {
  result =
    count(DataFlow::Node source, DataFlow::Node sink |
      cfg.hasFlow(source, sink) and not isFlowExcluded(source, sink)
    )
}

select numAlerts(any(SqlInjection::Configuration cfg)) as numAlerts,
  count(DataFlow::Node sink |
    exists(SqlInjection::Configuration cfg | cfg.isSink(sink) or cfg.isSink(sink, _))
  ) as numSinks

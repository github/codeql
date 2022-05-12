/*
 * For internal use only.
 *
 *
 * Count the number of sinks and alerts for the `DomBasedXss` security query.
 */

import javascript
import semmle.javascript.security.dataflow.DomBasedXssQuery as DomBasedXss
import evaluation.EndToEndEvaluation

int numAlerts(DataFlow::Configuration cfg) {
  result =
    count(DataFlow::Node source, DataFlow::Node sink |
      cfg.hasFlow(source, sink) and not isFlowExcluded(source, sink)
    )
}

select numAlerts(any(DomBasedXss::Configuration cfg)) as numAlerts,
  count(DataFlow::Node sink |
    exists(DomBasedXss::Configuration cfg | cfg.isSink(sink) or cfg.isSink(sink, _))
  ) as numSinks

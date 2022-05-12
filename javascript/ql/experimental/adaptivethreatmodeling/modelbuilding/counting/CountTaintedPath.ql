/*
 * For internal use only.
 *
 *
 * Count the number of sinks and alerts for the `TaintedPath` security query.
 */

import javascript
import semmle.javascript.security.dataflow.TaintedPathQuery as TaintedPath
import evaluation.EndToEndEvaluation

int numAlerts(DataFlow::Configuration cfg) {
  result =
    count(DataFlow::Node source, DataFlow::Node sink |
      cfg.hasFlow(source, sink) and not isFlowExcluded(source, sink)
    )
}

select numAlerts(any(TaintedPath::Configuration cfg)) as numAlerts,
  count(DataFlow::Node sink |
    exists(TaintedPath::Configuration cfg | cfg.isSink(sink) or cfg.isSink(sink, _))
  ) as numSinks

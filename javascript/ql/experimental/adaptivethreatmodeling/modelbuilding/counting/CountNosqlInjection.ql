/*
 * For internal use only.
 *
 *
 * Count the number of sinks and alerts for the `NosqlInection` security query.
 */

import javascript
import semmle.javascript.security.dataflow.NosqlInjectionQuery as NosqlInjection
import evaluation.EndToEndEvaluation

int numAlerts(DataFlow::Configuration cfg) {
  result =
    count(DataFlow::Node source, DataFlow::Node sink |
      cfg.hasFlow(source, sink) and not isFlowExcluded(source, sink)
    )
}

select numAlerts(any(NosqlInjection::Configuration cfg)) as numAlerts,
  count(DataFlow::Node sink |
    exists(NosqlInjection::Configuration cfg | cfg.isSink(sink) or cfg.isSink(sink, _))
  ) as numSinks

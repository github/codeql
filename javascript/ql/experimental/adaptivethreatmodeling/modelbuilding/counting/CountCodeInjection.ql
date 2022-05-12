/*
 * For internal use only.
 *
 *
 * Count the number of sinks and alerts for the `CodeInjection` security query.
 */

import javascript
import semmle.javascript.security.dataflow.CodeInjectionQuery as CodeInjection
import evaluation.EndToEndEvaluation

int numAlerts(DataFlow::Configuration cfg) {
  result =
    count(DataFlow::Node source, DataFlow::Node sink |
      cfg.hasFlow(source, sink) and not isFlowExcluded(source, sink)
    )
}

select numAlerts(any(CodeInjection::Configuration cfg)) as numAlerts,
  count(DataFlow::Node sink |
    exists(CodeInjection::Configuration cfg | cfg.isSink(sink) or cfg.isSink(sink, _))
  ) as numSinks

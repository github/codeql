/**
 * For internal use only.
 *
 *
 * Count the number of sinks and alerts for a particular dataflow config.
 */

import javascript
import evaluation.EndToEndEvaluation

query predicate countAlertsAndSinks(int numAlerts, int numSinks) {
  numAlerts =
    count(DataFlow::Configuration cfg, DataFlow::Node source, DataFlow::Node sink |
      cfg.hasFlow(source, sink) and not isFlowExcluded(source, sink)
    ) and
  numSinks =
    count(DataFlow::Node sink |
      exists(DataFlow::Configuration cfg | cfg.isSink(sink) or cfg.isSink(sink, _))
    )
}

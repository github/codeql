/**
 * @name Capture sink models.
 * @description Finds public methods that act as sinks as they flow into a known sink.
 * @kind diagnostic
 * @id cs/utils/modelgenerator/sink-models
 * @tags modelgenerator
 */

import internal.CaptureModels

class Activate extends ActiveConfiguration {
  override predicate activateToSinkConfig() { any() }
}

from DataFlowTargetApi api, string sink
where sink = captureSink(api)
select sink order by sink

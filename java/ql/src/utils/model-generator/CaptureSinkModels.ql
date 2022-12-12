/**
 * @name Capture sink models.
 * @description Finds public methods that act as sinks as they flow into a known sink.
 * @kind diagnostic
 * @id java/utils/model-generator/sink-models
 * @tags model-generator
 */

import utils.modelgenerator.internal.CaptureModels
import semmle.code.java.dataflow.ExternalFlow
import excludes.Sinks

class Activate extends ActiveConfiguration {
  override predicate activateToSinkConfig() { any() }
}

from DataFlowTargetApi api, string kind, string sink
where sink = captureSink(api, kind) and not hasSink(api, kind, false) and not isExcludedSink(sink)
select sink order by sink

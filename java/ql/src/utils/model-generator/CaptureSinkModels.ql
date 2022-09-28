/**
 * @name Capture sink models.
 * @description Finds public methods that act as sinks as they flow into a known sink.
 * @kind diagnostic
 * @id java/utils/model-generator/sink-models
 * @tags model-generator
 */

import internal.CaptureModels

from DataFlowTargetApi api, string sink
where sink = captureSink(api)
select sink order by sink

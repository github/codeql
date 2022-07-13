/**
 * @name Capture sink models.
 * @description Finds public methods that act as sinks as they flow into a known sink.
 * @kind diagnostic
 * @id java/utils/model-generator/sink-models
 * @tags model-generator
 */

private import internal.CaptureModels

from TargetApi api, string sink
where sink = captureSink(api)
select sink order by sink

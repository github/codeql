/**
 * @name Capture sink models.
 * @description Finds public methods that act as sinks as they flow into a a known sink.
 * @id java/utils/model-generator/sink-models
 */

private import internal.CaptureModels

from TargetApi api, string sink
where sink = captureSink(api)
select sink order by sink

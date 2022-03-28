/**
 * @name Capture source models.
 * @description Finds APIs that act as sources as they expose already known sources.
 * @id java/utils/model-generator/sink-models
 */

private import internal.CaptureModels

from TargetApi api, string source
where source = captureSource(api)
select source order by source

/**
 * @name Capture source models.
 * @description Finds APIs that act as sources as they expose already known sources.
 * @id cs/utils/model-generator/source-models
 */

private import internal.CaptureModels

from TargetApi api, string source
where source = captureSource(api)
select source order by source

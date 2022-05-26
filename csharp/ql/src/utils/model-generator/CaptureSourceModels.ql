/**
 * @name Capture source models.
 * @description Finds APIs that act as sources as they expose already known sources.
 * @kind diagnostic
 * @id cs/utils/model-generator/source-models
 * @tags model-generator
 */

private import internal.CaptureModels

from TargetApi api, string source
where source = captureSource(api)
select source order by source

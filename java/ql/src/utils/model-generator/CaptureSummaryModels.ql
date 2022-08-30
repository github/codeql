/**
 * @name Capture summary models.
 * @description Finds applicable summary models to be used by other queries.
 * @kind diagnostic
 * @id java/utils/model-generator/summary-models
 * @tags model-generator
 */

private import internal.CaptureModels

from TargetApi api, string flow
where flow = captureThroughFlow(api)
select flow order by flow

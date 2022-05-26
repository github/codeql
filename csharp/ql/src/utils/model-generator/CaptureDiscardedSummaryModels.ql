/**
 * @name Capture discarded summary models.
 * @description Finds summary models that are discarded as handwritten counterparts exist.
 * @id csharp/utils/model-generator/discarded-summary-models
 */

private import semmle.code.csharp.dataflow.ExternalFlow
private import internal.CaptureModels
private import internal.CaptureFlow

from TargetApi api, string flow
where flow = captureFlow(api) and hasSummary(api, false)
select flow order by flow

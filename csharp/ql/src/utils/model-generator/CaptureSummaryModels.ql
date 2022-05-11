/**
 * @name Capture summary models.
 * @description Finds applicable summary models to be used by other queries.
 * @kind diagnostic
 * @id cs/utils/model-generator/summary-models
 * @tags model-generator
 */

private import semmle.code.csharp.dataflow.ExternalFlow
private import internal.CaptureModels
private import internal.CaptureFlow

from TargetApi api, string flow
where flow = captureFlow(api) and not hasSummary(api, false)
select flow order by flow

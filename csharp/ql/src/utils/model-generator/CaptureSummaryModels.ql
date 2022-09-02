/**
 * @name Capture summary models.
 * @description Finds applicable summary models to be used by other queries.
 * @kind diagnostic
 * @id cs/utils/model-generator/summary-models
 * @tags model-generator
 */

private import semmle.code.csharp.dataflow.ExternalFlow
private import internal.CaptureModels
private import internal.CaptureSummaryFlow

from TargetApi api, string flow
where flow = captureFlow(api)
select flow order by flow

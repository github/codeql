/**
 * @name Capture negative summary models.
 * @description Finds negative summary models to be used by other queries.
 * @kind diagnostic
 * @id cs/utils/model-generator/negative-summary-models
 * @tags model-generator
 */

private import semmle.code.csharp.dataflow.ExternalFlow
private import internal.CaptureModels
private import internal.CaptureSummaryFlow

from TargetApi api, string noflow
where noflow = captureNoFlow(api) and not hasSummary(api, false)
select noflow order by noflow

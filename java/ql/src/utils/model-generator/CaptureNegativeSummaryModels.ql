/**
 * @name Capture negative summary models.
 * @description Finds negative summary models to be used by other queries.
 * @kind diagnostic
 * @id java/utils/model-generator/negative-summary-models
 * @tags model-generator
 */

private import internal.CaptureModels
private import internal.CaptureSummaryFlow

from TargetApi api, string noflow
where noflow = captureNoFlow(api)
select noflow order by noflow

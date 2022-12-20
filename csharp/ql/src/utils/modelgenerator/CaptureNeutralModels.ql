/**
 * @name Capture neutral models.
 * @description Finds neutral models to be used by other queries.
 * @kind diagnostic
 * @id cs/utils/modelgenerator/neutral-models
 * @tags modelgenerator
 */

import semmle.code.csharp.dataflow.ExternalFlow
import internal.CaptureModels
import internal.CaptureSummaryFlow

from DataFlowTargetApi api, string noflow
where
  noflow = captureNoFlow(api) and
  not hasSummary(api, false)
select noflow order by noflow

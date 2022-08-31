/**
 * @name Capture Theorems for Free summary models.
 * @description Finds applicable summary models to be used by other queries.
 * @kind diagnostic
 * @id cs/utils/model-generator/summary-models-theorems-for-free
 * @tags model-generator
 */

import semmle.code.csharp.dataflow.ExternalFlow
import internal.CaptureTheoremsForFreeSummaryModels

from TheoremTargetApi api, string flow
where flow = captureFlow(api)
select flow order by flow

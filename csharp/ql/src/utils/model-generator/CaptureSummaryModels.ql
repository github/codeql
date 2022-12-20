/**
 * @name Capture summary models.
 * @description Finds applicable summary models to be used by other queries.
 * @kind diagnostic
 * @id cs/utils/modelgenerator/summary-models
 * @tags modelgenerator
 */

import semmle.code.csharp.dataflow.ExternalFlow
import utils.modelgenerator.internal.CaptureModels
import utils.modelgenerator.internal.CaptureSummaryFlow

from DataFlowTargetApi api, string flow
where flow = captureFlow(api) and not hasSummary(api, false)
select flow order by flow

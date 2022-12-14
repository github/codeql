/**
 * @name Capture discarded summary models.
 * @description Finds summary models that are discarded as handwritten counterparts exist.
 * @id csharp/utils/model-generator/discarded-summary-models
 */

import semmle.code.csharp.dataflow.ExternalFlow
import utils.modelgenerator.internal.CaptureModels
import utils.modelgenerator.internal.CaptureSummaryFlow

from DataFlowTargetApi api, string flow
where flow = captureFlow(api) and hasSummary(api, false)
select flow order by flow

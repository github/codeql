/**
 * @name Capture typed based summary models.
 * @description Finds applicable summary models to be used by other queries.
 * @kind diagnostic
 * @id cs/utils/model-generator/summary-models-typed-based
 * @tags model-generator
 */

import utils.modelgenerator.internal.CaptureTypeBasedSummaryModels

from TypeBasedFlowTargetApi api, string flow
where flow = captureFlow(api)
select flow order by flow

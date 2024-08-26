/**
 * @name Capture field based summary models.
 * @description Finds applicable field based summary models to be used by other queries.
 * @kind diagnostic
 * @id java/utils/modelgenerator/fieldbased-summary-models
 * @tags modelgenerator
 */

import internal.CaptureModels

from DataFlowSummaryTargetApi api, string flow
where flow = captureContentFlow(api)
select flow order by flow

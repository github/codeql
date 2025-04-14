/**
 * @name Capture summary models.
 * @description Finds applicable summary models to be used by other queries.
 * @kind diagnostic
 * @id java/utils/modelgenerator/summary-models
 * @tags modelgenerator
 */

import internal.CaptureModels

from DataFlowSummaryTargetApi api, string flow
where flow = captureFlow(api)
select flow order by flow

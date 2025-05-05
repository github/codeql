/**
 * @name Capture summary models.
 * @description Finds applicable summary models to be used by other queries.
 * @kind diagnostic
 * @id rust/utils/modelgenerator/summary-models
 * @tags modelgenerator
 */

import internal.CaptureModels
import SummaryModels

from DataFlowSummaryTargetApi api, string flow
where flow = captureFlow(api, _)
select flow order by flow

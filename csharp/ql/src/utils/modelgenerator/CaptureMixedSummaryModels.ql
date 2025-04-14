/**
 * @name Capture mixed summary models.
 * @description Finds applicable summary models to be used by other queries.
 * @kind diagnostic
 * @id cs/utils/modelgenerator/mixed-summary-models
 * @tags modelgenerator
 */

import internal.CaptureModels

from DataFlowSummaryTargetApi api, string flow
where flow = captureMixedFlow(api, _)
select flow order by flow

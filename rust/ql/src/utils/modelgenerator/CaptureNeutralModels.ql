/**
 * @name Capture neutral models.
 * @description Finds neutral models to be used by other queries.
 * @kind diagnostic
 * @id rust/utils/modelgenerator/neutral-models
 * @tags modelgenerator
 */

import internal.CaptureModels
import SummaryModels

from DataFlowSummaryTargetApi api, string noflow
where noflow = Heuristic::captureNoFlow(api)
select noflow order by noflow

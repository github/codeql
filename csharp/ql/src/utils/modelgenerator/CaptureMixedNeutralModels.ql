/**
 * @name Capture mixed neutral models.
 * @description Finds neutral models to be used by other queries.
 * @kind diagnostic
 * @id cs/utils/modelgenerator/mixed-neutral-models
 * @tags modelgenerator
 */

import internal.CaptureModels

from DataFlowSummaryTargetApi api, string noflow
where noflow = captureMixedNeutral(api)
select noflow order by noflow

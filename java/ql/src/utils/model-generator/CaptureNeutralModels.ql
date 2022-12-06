/**
 * @name Capture neutral models.
 * @description Finds neutral models to be used by other queries.
 * @kind diagnostic
 * @id java/utils/model-generator/neutral-models
 * @tags model-generator
 */

import utils.modelgenerator.internal.CaptureModels
import utils.modelgenerator.internal.CaptureSummaryFlow

from DataFlowTargetApi api, string noflow
where noflow = captureNoFlow(api)
select noflow order by noflow

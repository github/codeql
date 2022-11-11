/**
 * @name Capture negative summary models.
 * @description Finds negative summary models to be used by other queries.
 * @kind diagnostic
 * @id java/utils/model-generator/negative-summary-models
 * @tags model-generator
 */

import utils.modelgenerator.internal.CaptureModels
import utils.modelgenerator.internal.CaptureSummaryFlow

from DataFlowTargetApi api, string noflow
where noflow = captureNoFlow(api)
select noflow order by noflow

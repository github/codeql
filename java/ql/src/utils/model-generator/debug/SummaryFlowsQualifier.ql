/**
 * @name Capture summary model qualifier flows
 * @description Debug query to find summary models to be used by other queries.
 * @kind problem
 * @id java/utils/model-generator/summary-models-qualifier-flow
 * @severity info
 * @tags model-generator
 *       debug
 */

import utils.modelgenerator.internal.CaptureModels as CaptureModels
import java

from Callable api, string s
where s = CaptureModels::captureQualifierFlow(api)
select api, s

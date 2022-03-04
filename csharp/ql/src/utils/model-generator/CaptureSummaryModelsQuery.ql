/**
 * @name Capture summary models.
 * @description Finds applicable summary models to be used by other queries.
 * @id csharp/utils/model-generator/summary-models
 */

import CaptureSummaryModels

private string captureFlow(TargetAPI api) {
  result = captureQualifierFlow(api) or
  result = captureThroughFlow(api)
}

from TargetAPI api, string flow
where flow = captureFlow(api)
select flow order by flow

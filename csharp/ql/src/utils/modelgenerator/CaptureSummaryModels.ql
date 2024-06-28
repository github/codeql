/**
 * @name Capture summary models.
 * @description Finds applicable summary models to be used by other queries.
 * @kind diagnostic
 * @id cs/utils/modelgenerator/summary-models
 * @tags modelgenerator
 */

import semmle.code.csharp.dataflow.internal.FlowSummaryImpl as FlowSummaryImpl
import internal.CaptureModels
import internal.CaptureSummaryFlowQuery

from DataFlowSummaryTargetApi api, string flow
where flow = captureFlow(api)
select flow order by flow

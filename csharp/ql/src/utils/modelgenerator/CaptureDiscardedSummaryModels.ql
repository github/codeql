/**
 * @name Capture discarded summary models.
 * @description Finds summary models that are discarded as handwritten counterparts exist.
 * @id cs/utils/modelgenerator/discarded-summary-models
 */

import semmle.code.csharp.dataflow.internal.FlowSummaryImpl as FlowSummaryImpl
import internal.CaptureModels
import internal.CaptureSummaryFlowQuery

from DataFlowTargetApi api, string flow
where
  flow = captureFlow(api) and
  api.(FlowSummaryImpl::Public::SummarizedCallable).isManual()
select flow order by flow

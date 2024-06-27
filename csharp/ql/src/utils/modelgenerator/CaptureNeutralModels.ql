/**
 * @name Capture neutral models.
 * @description Finds neutral models to be used by other queries.
 * @kind diagnostic
 * @id cs/utils/modelgenerator/neutral-models
 * @tags modelgenerator
 */

import semmle.code.csharp.dataflow.internal.FlowSummaryImpl as FlowSummaryImpl
import internal.CaptureModels
import internal.CaptureSummaryFlowQuery

from DataFlowSummaryTargetApi api, string noflow
where noflow = captureNoFlow(api)
select noflow order by noflow

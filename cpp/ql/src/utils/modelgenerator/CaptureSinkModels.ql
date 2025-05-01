/**
 * @name Capture sink models.
 * @description Finds public methods that act as sinks as they flow into a known sink.
 * @kind diagnostic
 * @id cpp/utils/modelgenerator/sink-models
 * @tags modelgenerator
 */

import internal.CaptureModels
import Heuristic

from DataFlowSinkTargetApi api, string sink
where sink = captureSink(api)
select sink order by sink

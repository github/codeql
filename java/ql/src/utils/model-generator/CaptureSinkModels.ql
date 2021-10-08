/**
 * @name Capture sink models.
 * @description Finds public methods that act as sinks as they flow into a a known sink.
 * @id java/utils/model-generator/sink-models
 */

import java
import Telemetry.ExternalAPI
import semmle.code.java.dataflow.DataFlow
import semmle.code.java.dataflow.TaintTracking
import semmle.code.java.dataflow.ExternalFlow
import ModelGeneratorUtils

class PropagateToSinkConfiguration extends TaintTracking::Configuration {
  PropagateToSinkConfiguration() { this = "parameters on public api flowing into sinks" }

  override predicate isSource(DataFlow::Node source) {
    source instanceof DataFlow::ParameterNode and
    source.asParameter().getCallable().isPublic() and
    source.asParameter().getCallable().getDeclaringType().isPublic() and
    isRelevantForModels(source.getEnclosingCallable())
  }

  override predicate isSink(DataFlow::Node sink) { sinkNode(sink, _)}
}

string asInputArgument(DataFlow::Node source) {
  result = "Argument[" + source.asParameter().getPosition() + "]"
}

string captureSink(Callable api) {
  exists(DataFlow::Node src, DataFlow::Node sink, PropagateToSinkConfiguration config, string kind |
    config.hasFlow(src, sink) and
    sinkNode(sink, kind) and
    api = src.getEnclosingCallable() and
    result = asSinkModel(api, asInputArgument(src), kind)
  )
}

from TargetAPI api, string sink
where
  sink = captureSink(api)
select sink order by sink

/**
 * @name Capture sink models.
 * @description Finds public methods that act as sinks as they flow into a a known sink.
 * @id java/utils/model-generator/sink-models
 */

import java
private import Telemetry.ExternalAPI
private import semmle.code.java.dataflow.DataFlow
private import semmle.code.java.dataflow.TaintTracking
private import semmle.code.java.dataflow.ExternalFlow
private import ModelGeneratorUtils
private import semmle.code.java.dataflow.internal.DataFlowNodes::Private

class PropagateToSinkConfiguration extends TaintTracking::Configuration {
  PropagateToSinkConfiguration() { this = "parameters or  flowing into sinks" }

  override predicate isSource(DataFlow::Node source) {
    (source.asExpr().(FieldAccess).isOwnFieldAccess() or source instanceof DataFlow::ParameterNode) and
    source.getEnclosingCallable().isPublic() and
    exists(RefType t |
      t = source.getEnclosingCallable().getDeclaringType().getAnAncestor() and
      not t instanceof TypeObject and
      t.isPublic()
    ) and
    isRelevantForModels(source.getEnclosingCallable())
  }

  override predicate isSink(DataFlow::Node sink) { sinkNode(sink, _) }

  override DataFlow::FlowFeature getAFeature() {
    result instanceof DataFlow::FeatureHasSourceCallContext
  }
}

string asInputArgument(DataFlow::Node source) {
  exists(int pos |
    source.(DataFlow::ParameterNode).isParameterOf(_, pos) and
    result = "Argument[" + pos + "]"
  )
  or
  source.asExpr() instanceof FieldAccess and
  result = "Argument[-1]"
}

string captureSink(TargetAPI api) {
  exists(DataFlow::Node src, DataFlow::Node sink, PropagateToSinkConfiguration config, string kind |
    config.hasFlow(src, sink) and
    sinkNode(sink, kind) and
    api = src.getEnclosingCallable() and
    result = asSinkModel(api, asInputArgument(src), kind)
  )
}

from TargetAPI api, string sink
where sink = captureSink(api)
select sink order by sink

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
  PropagateToSinkConfiguration() { this = "public methods calling sinks" }

  override predicate isSource(DataFlow::Node source) {
    exists(MethodAccess ma |
      ma.getAChildExpr() = source.asExpr() and
      ma.getAnEnclosingStmt().getEnclosingCallable().isPublic() and
      ma.getAnEnclosingStmt().getEnclosingCallable().fromSource()
    )
  }

  override predicate isSink(DataFlow::Node sink) { sinkNode(sink, _) }
}

string asInputArgument(Expr source) {
  result = "Argument[" + source.(Argument).getPosition() + "]"
  or
  result = source.(VarAccess).getVariable().toString()
}

string captureSink(Callable api) {
  exists(DataFlow::Node src, DataFlow::Node sink, PropagateToSinkConfiguration config, string kind |
    config.hasFlow(src, sink) and
    sinkNode(sink, kind) and
    api = src.asExpr().getEnclosingCallable() and
    result = asSinkModel(api, asInputArgument(src.asExpr()), kind)
  )
}

from Callable api, string sink
where
  sink = captureSink(api) and
  not isInTestFile(api)
select sink order by sink

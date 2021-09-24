import java
import Telemetry.ExternalAPI
import semmle.code.java.dataflow.DataFlow
import semmle.code.java.dataflow.TaintTracking
import semmle.code.java.dataflow.ExternalFlow
import ModelGeneratorUtils

class Configuration extends TaintTracking::Configuration {
  Configuration() { this = "public methods calling sinks" }

  override predicate isSource(DataFlow::Node source) {
    exists(MethodAccess ma |
      ma = source.asExpr() and
      ma.getAnEnclosingStmt().getEnclosingCallable().isPublic() and
      ma.getAnEnclosingStmt().getEnclosingCallable().fromSource()
    )
  }

  override predicate isSink(DataFlow::Node sink) { sinkNode(sink, _) }
}

string asInputArgument(Expr source) { result = "Argument[" + source.(Argument).getPosition() + "]" }

string captureSink(Callable api) {
  exists(DataFlow::Node src, DataFlow::Node sink, Configuration config, string kind |
    config.hasFlow(src, sink) and
    sinkNode(sink, kind) and
    api = src.asExpr().getEnclosingCallable() and
    result = asSinkModel(api, asInputArgument(src.asExpr()), kind)
  )
}

from Callable api, string sink
where
  sink = captureSink(api) and
  not api.getCompilationUnit().getFile().getAbsolutePath().matches("%src/test/%")
select sink order by sink

import java
import Telemetry.ExternalAPI
import semmle.code.java.dataflow.DataFlow
import semmle.code.java.dataflow.TaintTracking
import semmle.code.java.dataflow.ExternalFlow
import ModelGeneratorUtils
private import semmle.code.java.dataflow.internal.FlowSummaryImplSpecific
private import semmle.code.java.dataflow.internal.FlowSummaryImpl

class Configuration extends TaintTracking::Configuration {
  Configuration() { this = "Configuration" }

  override predicate isSource(DataFlow::Node source) { sourceNode(source, _) }

  override predicate isSink(DataFlow::Node sink) {
    exists(Callable c |
      sink.asExpr().getEnclosingCallable() = c and
      c.isPublic() and
      c.fromSource()
    )
  }
}

// TODO: internals
cached
predicate specificSourceNode(DataFlow::Node node, string output, string kind) {
  exists(InterpretNode n | Private::External::isSourceNode(n, output, kind) and n.asNode() = node)
}

string captureSink(Callable api) {
  exists(DataFlow::Node src, DataFlow::Node sink, Configuration config, string kind, string output |
    config.hasFlow(src, sink) and
    specificSourceNode(sink, output, kind) and
    api = src.asExpr().getEnclosingCallable() and
    result = asSourceModel(api, output, kind)
  )
}

from Callable api, string sink
where
  sink = captureSink(api) and
  not isInTestFile(api)
select sink order by sink

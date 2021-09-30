/**
 * @name Capture source models.
 * @description Finds APIs that act as sources as they expose already known sources.
 * @id java/utils/model-generator/sink-models
 */

import java
private import Telemetry.ExternalAPI
private import semmle.code.java.dataflow.DataFlow
private import semmle.code.java.dataflow.TaintTracking
private import semmle.code.java.dataflow.ExternalFlow
private import ModelGeneratorUtils
private import semmle.code.java.dataflow.internal.FlowSummaryImplSpecific
private import semmle.code.java.dataflow.internal.FlowSummaryImpl

class FromSourceConfiguration extends TaintTracking::Configuration {
  FromSourceConfiguration() { this = "FromSourceConfiguration" }

  override predicate isSource(DataFlow::Node source) { sourceNode(source, _) }

  override predicate isSink(DataFlow::Node sink) {
    exists(Callable c |
      sink.asExpr().getEnclosingCallable() = c and
      c.isPublic() and
      c.fromSource()
    )
  }
}

// TODO: better way than rely on internals?
cached
predicate specificSourceNode(DataFlow::Node node, string output, string kind) {
  exists(InterpretNode n | Private::External::isSourceNode(n, output, kind) and n.asNode() = node)
}

string captureSink(Callable api) {
  exists(
    DataFlow::Node src, DataFlow::Node sink, FromSourceConfiguration config, string kind,
    string output
  |
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

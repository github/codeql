import python
private import semmle.python.frameworks.data.internal.ApiGraphModels as ApiGraphModels
import semmle.python.frameworks.data.ModelsAsData
import semmle.python.dataflow.new.TaintTracking
import semmle.python.dataflow.new.DataFlow
private import semmle.python.ApiGraphs

module BasicTaintTrackingConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    source = ModelOutput::getASourceNode("test-source").asSource()
  }

  predicate isSink(DataFlow::Node sink) { sink = ModelOutput::getASinkNode("test-sink").asSink() }
}

module TestTaintTrackingFlow = TaintTracking::Global<BasicTaintTrackingConfig>;

query predicate taintFlow(DataFlow::Node source, DataFlow::Node sink) {
  TestTaintTrackingFlow::flow(source, sink)
}

query predicate isSink(DataFlow::Node node, string kind) {
  node = ModelOutput::getASinkNode(kind).asSink()
}

query predicate isSource(DataFlow::Node node, string kind) {
  node = ModelOutput::getASourceNode(kind).asSource()
}

query predicate syntaxErrors(ApiGraphModels::AccessPath path) { path.hasSyntaxError() }

query predicate warning = ModelOutput::getAWarning/0;

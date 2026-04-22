import python
private import semmle.python.frameworks.data.internal.ApiGraphModels as ApiGraphModels
import semmle.python.frameworks.data.ModelsAsData
import semmle.python.dataflow.new.TaintTracking
import semmle.python.dataflow.new.DataFlow
private import semmle.python.ApiGraphs

module BasicTaintTrackingConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { ModelOutput::sourceNode(source, "test-source") }

  predicate isSink(DataFlow::Node sink) { ModelOutput::sinkNode(sink, "test-sink") }
}

module TestTaintTrackingFlow = TaintTracking::Global<BasicTaintTrackingConfig>;

query predicate taintFlow(DataFlow::Node source, DataFlow::Node sink) {
  TestTaintTrackingFlow::flow(source, sink)
}

query predicate isSink(DataFlow::Node node, string kind) { ModelOutput::sinkNode(node, kind) }

query predicate isSource(DataFlow::Node node, string kind) { ModelOutput::sourceNode(node, kind) }

query predicate syntaxErrors(ApiGraphModels::AccessPath path) { path.hasSyntaxError() }

query predicate warning = ModelOutput::getAWarning/0;

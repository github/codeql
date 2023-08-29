import python
import semmle.python.dataflow.new.internal.AccessPathSyntax as AccessPathSyntax
import semmle.python.frameworks.data.ModelsAsData
import semmle.python.dataflow.new.TaintTracking
import semmle.python.dataflow.new.DataFlow
private import semmle.python.ApiGraphs

class BasicTaintTracking extends TaintTracking::Configuration {
  BasicTaintTracking() { this = "BasicTaintTracking" }

  override predicate isSource(DataFlow::Node source) {
    source = ModelOutput::getASourceNode("test-source").asSource()
  }

  override predicate isSink(DataFlow::Node sink) {
    sink = ModelOutput::getASinkNode("test-sink").asSink()
  }
}

query predicate taintFlow(DataFlow::Node source, DataFlow::Node sink) {
  any(BasicTaintTracking tr).hasFlow(source, sink)
}

query predicate isSink(DataFlow::Node node, string kind) {
  node = ModelOutput::getASinkNode(kind).asSink()
}

query predicate isSource(DataFlow::Node node, string kind) {
  node = ModelOutput::getASourceNode(kind).asSource()
}

query predicate syntaxErrors(AccessPathSyntax::AccessPath path) { path.hasSyntaxError() }

query predicate warning = ModelOutput::getAWarning/0;

import javascript
import testUtilities.ConsistencyChecking
import semmle.javascript.frameworks.data.internal.ApiGraphModels as ApiGraphModels

class TypeModelFromCodeQL extends ModelInput::TypeModel {
  override predicate isTypeUsed(string type) { type = "danger-constant" }

  override DataFlow::Node getASource(string type) {
    type = "danger-constant" and
    result.getStringValue() = "danger-constant"
  }
}

class BasicTaintTracking extends TaintTracking::Configuration {
  BasicTaintTracking() { this = "BasicTaintTracking" }

  override predicate isSource(DataFlow::Node source) {
    source.(DataFlow::CallNode).getCalleeName() = "source"
    or
    source = ModelOutput::getASourceNode("test-source").asSource()
  }

  override predicate isSink(DataFlow::Node sink) {
    sink = any(DataFlow::CallNode call | call.getCalleeName() = "sink").getAnArgument()
    or
    sink = ModelOutput::getASinkNode("test-sink").asSink()
  }
}

query predicate taintFlow(DataFlow::Node source, DataFlow::Node sink) {
  any(BasicTaintTracking tr).hasFlow(source, sink)
}

query predicate isSink(DataFlow::Node node, string kind) {
  node = ModelOutput::getASinkNode(kind).asSink()
}

query predicate syntaxErrors(ApiGraphModels::AccessPath path) { path.hasSyntaxError() }

query predicate warning = ModelOutput::getAWarning/0;

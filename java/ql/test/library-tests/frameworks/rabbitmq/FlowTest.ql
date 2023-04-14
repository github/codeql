import java
import semmle.code.java.dataflow.TaintTracking
import semmle.code.java.dataflow.FlowSources
import TestUtilities.InlineFlowTest

module Config implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node node) { node instanceof RemoteFlowSource }

  predicate isSink(DataFlow::Node node) {
    exists(MethodAccess ma | ma.getMethod().hasName("sink") | node.asExpr() = ma.getAnArgument())
  }
}

module Flow = TaintTracking::Global<Config>;

class HasFlowTest extends InlineFlowTest {
  override predicate hasValueFlow(DataFlow::Node src, DataFlow::Node sink) { none() }

  override predicate hasTaintFlow(DataFlow::Node src, DataFlow::Node sink) { Flow::flow(src, sink) }
}

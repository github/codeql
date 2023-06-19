import java
import semmle.code.java.dataflow.DataFlow
import TestUtilities.InlineFlowTest

module FlowConfig implements DataFlow::ConfigSig {
  predicate isSource = DefaultFlowConfig::isSource/1;

  predicate isSink(DataFlow::Node n) {
    DefaultFlowConfig::isSink(n) or sinkNode(n, "request-forgery")
  }
}

module Flow = DataFlow::Global<FlowConfig>;

class RetrofitFlowTest extends InlineFlowTest {
  override predicate hasValueFlow(DataFlow::Node src, DataFlow::Node sink) { Flow::flow(src, sink) }
}

import java
import semmle.code.java.dataflow.DataFlow
import TestUtilities.InlineFlowTest

module OkHttpFlowConfig implements DataFlow::ConfigSig {
  predicate isSource = DefaultFlowConfig::isSource/1;

  predicate isSink(DataFlow::Node n) {
    DefaultFlowConfig::isSink(n) or sinkNode(n, "request-forgery")
  }
}

module OkHttpFlow = DataFlow::Global<OkHttpFlowConfig>;

class OkHttpTest extends InlineFlowTest {
  override predicate hasValueFlow(DataFlow::Node src, DataFlow::Node sink) {
    OkHttpFlow::flow(src, sink)
  }
}

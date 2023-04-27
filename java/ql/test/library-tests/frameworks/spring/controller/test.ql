import java
import semmle.code.java.dataflow.FlowSources
import TestUtilities.InlineFlowTest

module ValueFlowConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  predicate isSink(DataFlow::Node sink) {
    sink.asExpr().(Argument).getCall().getCallee().hasName("sink")
  }
}

module ValueFlow = DataFlow::Global<ValueFlowConfig>;

class Test extends InlineFlowTest {
  override predicate hasValueFlow(DataFlow::Node src, DataFlow::Node sink) {
    ValueFlow::flow(src, sink)
  }
}

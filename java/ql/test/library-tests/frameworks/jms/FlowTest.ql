import java
import semmle.code.java.dataflow.FlowSources
import TestUtilities.InlineExpectationsTest

module TestConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  predicate isSink(DataFlow::Node sink) {
    exists(MethodAccess call |
      call.getMethod().hasName("sink") and call.getArgument(0) = sink.asExpr()
    )
  }
}

module TestFlow = TaintTracking::Global<TestConfig>;

class JmsFlowTest extends InlineExpectationsTest {
  JmsFlowTest() { this = "JmsFlowTest" }

  override string getARelevantTag() { result = "tainted" }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "tainted" and
    exists(TestFlow::PathNode sink | TestFlow::flowPath(_, sink) |
      location = sink.getNode().getLocation() and element = sink.getNode().toString() and value = ""
    )
  }
}

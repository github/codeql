import java
import semmle.code.java.dataflow.FlowSources
import TestUtilities.InlineExpectationsTest

class TestConfig extends TaintTracking::Configuration {
  TestConfig() { this = "TestConfig" }

  override predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node sink) {
    exists(MethodAccess call |
      call.getMethod().hasName("sink") and call.getArgument(0) = sink.asExpr()
    )
  }
}

class JmsFlowTest extends InlineExpectationsTest {
  JmsFlowTest() { this = "JmsFlowTest" }

  override string getARelevantTag() { result = "tainted" }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "tainted" and
    exists(DataFlow::PathNode sink, TestConfig conf | conf.hasFlowPath(_, sink) |
      location = sink.getNode().getLocation() and element = sink.getNode().toString() and value = ""
    )
  }
}

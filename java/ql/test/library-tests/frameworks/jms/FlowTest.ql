import java
import semmle.code.java.dataflow.FlowSources
import utils.test.InlineExpectationsTest

module TestConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof ActiveThreatModelSource }

  predicate isSink(DataFlow::Node sink) {
    exists(MethodCall call |
      call.getMethod().hasName("sink") and call.getArgument(0) = sink.asExpr()
    )
  }
}

module TestFlow = TaintTracking::Global<TestConfig>;

module JmsFlowTest implements TestSig {
  string getARelevantTag() { result = "tainted" }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "tainted" and
    exists(TestFlow::PathNode sink | TestFlow::flowPath(_, sink) |
      location = sink.getNode().getLocation() and element = sink.getNode().toString() and value = ""
    )
  }
}

import MakeTest<JmsFlowTest>

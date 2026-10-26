import javascript
import utils.test.InlineExpectationsTest
import semmle.javascript.security.TaintedUrlSuffix

module TestConfig implements DataFlow::StateConfigSig {
  import semmle.javascript.security.CommonFlowState

  predicate isSource(DataFlow::Node node, FlowState state) {
    node = TaintedUrlSuffix::source() and state.isTaintedUrlSuffix()
    or
    node instanceof RemoteFlowSource and
    not node = TaintedUrlSuffix::source() and
    state.isTaint()
  }

  predicate isSink(DataFlow::Node node, FlowState state) { none() }

  predicate isSink(DataFlow::Node node) {
    exists(DataFlow::CallNode call |
      call.getCalleeName() = "sink" and
      node = call.getArgument(0)
    )
  }

  predicate isAdditionalFlowStep(
    DataFlow::Node node1, FlowState state1, DataFlow::Node node2, FlowState state2
  ) {
    TaintedUrlSuffix::isAdditionalFlowStep(node1, state1, node2, state2)
  }

  predicate isBarrier(DataFlow::Node node, FlowState state) {
    TaintedUrlSuffix::isStateBarrier(node, state)
  }
}

module TestFlow = TaintTracking::GlobalWithState<TestConfig>;

module InlineTest implements TestSig {
  string getARelevantTag() { result = "flow" }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "flow" and
    exists(TestFlow::PathNode src, TestFlow::PathNode sink | TestFlow::flowPath(src, sink) |
      sink.getLocation() = location and
      element = "" and
      value = sink.getState().toString()
    )
  }
}

import MakeTest<InlineTest>

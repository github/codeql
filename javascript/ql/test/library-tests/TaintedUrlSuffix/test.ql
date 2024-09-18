import javascript
import testUtilities.InlineExpectationsTest
import semmle.javascript.security.TaintedUrlSuffix

module TestConfig implements DataFlow::StateConfigSig {
  class FlowState = DataFlow::FlowLabel;

  predicate isSource(DataFlow::Node node, DataFlow::FlowLabel state) {
    node = TaintedUrlSuffix::source() and state = TaintedUrlSuffix::label()
    or
    node instanceof RemoteFlowSource and
    not node = TaintedUrlSuffix::source() and
    state.isTaint()
  }

  predicate isSink(DataFlow::Node node, DataFlow::FlowLabel state) { none() }

  predicate isSink(DataFlow::Node node) {
    exists(DataFlow::CallNode call |
      call.getCalleeName() = "sink" and
      node = call.getArgument(0)
    )
  }

  predicate isAdditionalFlowStep(
    DataFlow::Node node1, DataFlow::FlowLabel state1, DataFlow::Node node2,
    DataFlow::FlowLabel state2
  ) {
    TaintedUrlSuffix::step(node1, node2, state1, state2)
  }

  predicate isBarrier(DataFlow::Node node, DataFlow::FlowLabel label) {
    TaintedUrlSuffix::isBarrier(node, label)
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
      value = sink.getState()
    )
  }
}

import MakeTest<InlineTest>

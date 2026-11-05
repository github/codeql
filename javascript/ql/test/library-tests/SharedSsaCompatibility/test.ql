import javascript
import utils.test.InlineExpectationsTest

module TestConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    exists(SsaPhiNode phi |
      phi.getSourceVariable().getName() = "compatibilityPhiSource" and
      source = DataFlow::ssaDefinitionNode(phi)
    )
  }

  predicate isSink(DataFlow::Node sink) {
    exists(DataFlow::InvokeNode call |
      call.getCalleeName() = "SINK" and
      sink = call.getArgument(0)
    )
  }
}

module TestFlow = DataFlow::Global<TestConfig>;

module InlineTest implements TestSig {
  string getARelevantTag() { result = ["source", "flow"] }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = ["source", "flow"] and
    element = "" and
    value = "compatibility-phi" and
    exists(DataFlow::Node source, DataFlow::InvokeNode sink, VarRef sinkArgument |
      TestConfig::isSource(source) and
      sink.getCalleeName() = "SINK" and
      sink.getArgument(0) = DataFlow::valueNode(sinkArgument) and
      sinkArgument.getVariable().getName() = "compatibilityPhiSource" and
      location = sink.getLocation() and
      (
        tag = "source"
        or
        tag = "flow" and TestFlow::flow(source, sink.getArgument(0))
      )
    )
  }
}

import MakeTest<InlineTest>

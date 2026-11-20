import javascript
import utils.test.InlineExpectationsTest

module TestConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    source.(DataFlow::InvokeNode).getCalleeName() = "SOURCE"
  }

  predicate isSink(DataFlow::Node sink) {
    exists(DataFlow::InvokeNode call |
      call.getCalleeName() = "SINK" and
      sink = call.getArgument(0)
    )
  }

  predicate isBarrier(DataFlow::Node node) {
    node = DataFlow::MakeBarrierGuard<SimpleBarrierGuard>::getABarrierNode()
  }
}

module TestFlow = DataFlow::Global<TestConfig>;

class SimpleBarrierGuard extends DataFlow::InvokeNode {
  SimpleBarrierGuard() { this.getCalleeName() = "BARRIER" }

  predicate blocksExpr(boolean outcome, Expr expr) {
    outcome = true and
    expr = this.getArgument(0).asExpr()
  }
}

module InlineTest implements TestSig {
  string getARelevantTag() { result = "flow" }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "flow" and
    element = "" and
    exists(DataFlow::InvokeNode source, DataFlow::Node sink |
      TestFlow::flow(source, sink) and
      source.getCalleeName() = "SOURCE" and
      value = source.getArgument(0).getStringValue() and
      location = sink.getLocation()
    )
  }
}

import MakeTest<InlineTest>

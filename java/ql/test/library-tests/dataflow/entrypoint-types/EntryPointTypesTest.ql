import java
import semmle.code.java.dataflow.FlowSources
import utils.test.InlineExpectationsTest

class TestRemoteFlowSource extends RemoteFlowSource {
  TestRemoteFlowSource() { this.asParameter().hasName("source") }

  override string getSourceType() { result = "test" }
}

module TaintFlowConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node n) { n instanceof ActiveThreatModelSource }

  predicate isSink(DataFlow::Node n) {
    exists(MethodCall ma | ma.getMethod().hasName("sink") | n.asExpr() = ma.getAnArgument())
  }
}

module TaintFlow = TaintTracking::Global<TaintFlowConfig>;

module HasFlowTest implements TestSig {
  string getARelevantTag() { result = "hasTaintFlow" }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "hasTaintFlow" and
    exists(DataFlow::Node sink | TaintFlow::flowTo(sink) |
      sink.getLocation() = location and
      element = sink.toString() and
      value = ""
    )
  }
}

import MakeTest<HasFlowTest>

import java
import semmle.code.java.dataflow.FlowSources
import TestUtilities.InlineExpectationsTest

class TestRemoteFlowSource extends RemoteFlowSource {
  TestRemoteFlowSource() { this.asParameter().hasName("source") }

  override string getSourceType() { result = "test" }
}

class TaintFlowConf extends TaintTracking::Configuration {
  TaintFlowConf() { this = "qltest:dataflow:entrypoint-types-taint" }

  override predicate isSource(DataFlow::Node n) { n instanceof RemoteFlowSource }

  override predicate isSink(DataFlow::Node n) {
    exists(MethodAccess ma | ma.getMethod().hasName("sink") | n.asExpr() = ma.getAnArgument())
  }
}

class HasFlowTest extends InlineExpectationsTest {
  HasFlowTest() { this = "HasFlowTest" }

  override string getARelevantTag() { result = ["hasTaintFlow"] }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "hasTaintFlow" and
    exists(DataFlow::Node src, DataFlow::Node sink, TaintFlowConf conf | conf.hasFlow(src, sink) |
      sink.getLocation() = location and
      element = sink.toString() and
      value = ""
    )
  }
}

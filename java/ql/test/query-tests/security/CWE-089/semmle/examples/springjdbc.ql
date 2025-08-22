import java
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.security.SqlInjectionQuery
import utils.test.InlineExpectationsTest

private class SourceMethodSource extends RemoteFlowSource {
  SourceMethodSource() { this.asExpr().(MethodCall).getMethod().hasName("source") }

  override string getSourceType() { result = "source" }
}

module HasFlowTest implements TestSig {
  string getARelevantTag() { result = "sqlInjection" }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "sqlInjection" and
    exists(DataFlow::Node sink | QueryInjectionFlow::flowTo(sink) |
      sink.getLocation() = location and
      element = sink.toString() and
      value = ""
    )
  }
}

import MakeTest<HasFlowTest>

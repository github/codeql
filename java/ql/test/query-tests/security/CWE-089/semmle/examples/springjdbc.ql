import java
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.security.SqlInjectionQuery
import TestUtilities.InlineExpectationsTest

private class SourceMethodSource extends RemoteFlowSource {
  SourceMethodSource() { this.asExpr().(MethodAccess).getMethod().hasName("source") }

  override string getSourceType() { result = "source" }
}

class HasFlowTest extends InlineExpectationsTest {
  HasFlowTest() { this = "HasFlowTest" }

  override string getARelevantTag() { result = "sqlInjection" }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "sqlInjection" and
    exists(DataFlow::Node sink | QueryInjectionFlow::flowTo(sink) |
      sink.getLocation() = location and
      element = sink.toString() and
      value = ""
    )
  }
}

import java
import TestUtilities.InlineExpectationsTest
import semmle.code.java.security.SensitiveResultReceiverQuery

class TestSource extends RemoteFlowSource {
  TestSource() { this.asExpr().(MethodAccess).getMethod().hasName("source") }

  override string getSourceType() { result = "test" }
}

class ResultReceiverTest extends InlineExpectationsTest {
  ResultReceiverTest() { this = "ResultReceiverTest" }

  override string getARelevantTag() { result = "hasSensitiveResultReceiver" }

  override predicate hasActualResult(Location loc, string element, string tag, string value) {
    exists(DataFlow::PathNode sink |
      sensitiveResultReceiver(_, sink, _) and
      element = sink.toString() and
      loc = sink.getNode().getLocation() and
      tag = "hasSensitiveResultReceiver" and
      value = ""
    )
  }
}

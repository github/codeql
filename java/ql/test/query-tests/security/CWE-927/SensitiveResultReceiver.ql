import java
import utils.test.InlineExpectationsTest
import semmle.code.java.security.SensitiveResultReceiverQuery

class TestSource extends RemoteFlowSource {
  TestSource() { this.asExpr().(MethodCall).getMethod().hasName("source") }

  override string getSourceType() { result = "test" }
}

module ResultReceiverTest implements TestSig {
  string getARelevantTag() { result = "hasSensitiveResultReceiver" }

  predicate hasActualResult(Location loc, string element, string tag, string value) {
    exists(SensitiveResultReceiverFlow::PathNode sink |
      isSensitiveResultReceiver(_, sink, _) and
      element = sink.toString() and
      loc = sink.getNode().getLocation() and
      tag = "hasSensitiveResultReceiver" and
      value = ""
    )
  }
}

import MakeTest<ResultReceiverTest>

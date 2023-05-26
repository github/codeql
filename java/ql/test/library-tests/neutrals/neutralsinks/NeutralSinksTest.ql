import java
import TestUtilities.InlineExpectationsTest
import semmle.code.java.dataflow.DataFlow
import semmle.code.java.dataflow.ExternalFlow

class NeutralSinksTest extends InlineExpectationsTest {
  NeutralSinksTest() { this = "NeutralSinksTest" }

  override string getARelevantTag() { result = "isSink" }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "isSink" and
    exists(DataFlow::Node sink |
      sinkNode(sink, _) and
      sink.getLocation() = location and
      element = sink.toString() and
      value = ""
    )
  }
}

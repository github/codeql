import java
import TestUtilities.InlineExpectationsTest
import semmle.code.java.security.InsufficientKeySizeQuery

class InsufficientKeySizeTest extends InlineExpectationsTest {
  InsufficientKeySizeTest() { this = "InsufficientKeySize" }

  override string getARelevantTag() { result = "hasInsufficientKeySize" }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "hasInsufficientKeySize" and
    exists(DataFlow::PathNode sink | exists(KeySizeConfiguration cfg | cfg.hasFlowPath(_, sink)) |
      sink.getNode().getLocation() = location and
      element = sink.getNode().toString() and
      value = ""
    )
  }
}

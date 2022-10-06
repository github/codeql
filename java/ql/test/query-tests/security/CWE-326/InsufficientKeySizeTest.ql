import java
import TestUtilities.InlineExpectationsTest
import semmle.code.java.security.InsufficientKeySizeQuery

class InsufficientKeySizeTest extends InlineExpectationsTest {
  InsufficientKeySizeTest() { this = "InsufficientKeySize" }

  override string getARelevantTag() { result = "hasInsufficientKeySize" }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "hasInsufficientKeySize" and
    exists(DataFlow::PathNode source, DataFlow::PathNode sink |
      exists(AsymmetricKeyTrackingConfiguration config1 | config1.hasFlowPath(source, sink)) or
      exists(AsymmetricECCKeyTrackingConfiguration config2 | config2.hasFlowPath(source, sink)) or
      exists(SymmetricKeyTrackingConfiguration config2 | config2.hasFlowPath(source, sink))
    |
      sink.getNode().getLocation() = location and
      element = sink.getNode().toString() and
      value = ""
    )
  }
}

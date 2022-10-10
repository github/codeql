import java
import TestUtilities.InlineExpectationsTest
import semmle.code.java.security.InsufficientKeySizeQuery

class InsufficientKeySizeTest extends InlineExpectationsTest {
  InsufficientKeySizeTest() { this = "InsufficientKeySize" }

  override string getARelevantTag() { result = "hasInsufficientKeySize" }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "hasInsufficientKeySize" and
    exists(DataFlow::Node source, DataFlow::Node sink |
      exists(AsymmetricNonECKeyTrackingConfiguration config1 | config1.hasFlow(source, sink)) or
      exists(AsymmetricECKeyTrackingConfiguration config2 | config2.hasFlow(source, sink)) or
      exists(SymmetricKeyTrackingConfiguration config3 | config3.hasFlow(source, sink))
    |
      sink.getLocation() = location and
      element = sink.toString() and
      value = ""
    )
  }
}

import java
import TestUtilities.InlineExpectationsTest
import semmle.code.java.security.InsufficientKeySizeQuery

class InsufficientKeySizeTest extends InlineExpectationsTest {
  InsufficientKeySizeTest() { this = "InsufficientKeySize" }

  override string getARelevantTag() { result = "hasInsufficientKeySize" }

  // * Path-problem
  // override predicate hasActualResult(Location location, string element, string tag, string value) {
  //   tag = "hasInsufficientKeySize" and
  //   exists(DataFlow::PathNode source, DataFlow::PathNode sink |
  //     exists(AsymmetricKeyTrackingConfiguration config1 | config1.hasFlowPath(source, sink)) or
  //     exists(AsymmetricECCKeyTrackingConfiguration config2 | config2.hasFlowPath(source, sink)) or
  //     exists(SymmetricKeyTrackingConfiguration config2 | config2.hasFlowPath(source, sink))
  //   |
  //     sink.getNode().getLocation() = location and
  //     element = sink.getNode().toString() and
  //     value = ""
  //   )
  // }
  // * Not path-problem
  override predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "hasInsufficientKeySize" and
    exists(DataFlow::Node source, DataFlow::Node sink |
      exists(AsymmetricKeyTrackingConfiguration config1 | config1.hasFlow(source, sink)) or
      exists(AsymmetricECCKeyTrackingConfiguration config2 | config2.hasFlow(source, sink)) or
      exists(SymmetricKeyTrackingConfiguration config3 | config3.hasFlow(source, sink))
    |
      sink.getLocation() = location and
      element = sink.toString() and
      value = ""
    )
  }
}

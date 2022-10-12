import java
import TestUtilities.InlineExpectationsTest
import semmle.code.java.security.InsufficientKeySizeQuery

//import DataFlow::PathGraph // Note: importing this messes up tests - adds edges and nodes to actual file...
class InsufficientKeySizeTest extends InlineExpectationsTest {
  InsufficientKeySizeTest() { this = "InsufficientKeySize" }

  override string getARelevantTag() { result = "hasInsufficientKeySize" }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "hasInsufficientKeySize" and
    exists(DataFlow::PathNode source, DataFlow::PathNode sink |
      //exists(KeyTrackingConfiguration config1 | config1.hasFlowPath(source, sink))
      //or
      exists(AsymmetricNonECKeyTrackingConfiguration cfg | cfg.hasFlowPath(source, sink)) or
      exists(AsymmetricECKeyTrackingConfiguration cfg | cfg.hasFlowPath(source, sink)) or
      exists(SymmetricKeyTrackingConfiguration cfg | cfg.hasFlowPath(source, sink))
    |
      sink.getNode().getLocation() = location and
      element = sink.getNode().toString() and
      value = ""
    )
  }
}

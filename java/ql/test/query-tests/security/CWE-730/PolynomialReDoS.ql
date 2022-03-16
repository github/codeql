import java
import TestUtilities.InlineExpectationsTest
import semmle.code.java.security.performance.PolynomialReDosQuery

class HasPolyRedos extends InlineExpectationsTest {
  HasPolyRedos() { this = "HasPolyRedos" }

  override string getARelevantTag() { result = ["hasPolyRedos"] }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "hasPolyRedos" and
    exists(DataFlow::PathNode source, DataFlow::PathNode sink, PolynomialBackTrackingTerm regexp |
      hasPolynomialReDosResult(source, sink, regexp) and
      location = sink.getNode().getLocation() and
      element = sink.getNode().toString() and
      value = ""
    )
  }
}

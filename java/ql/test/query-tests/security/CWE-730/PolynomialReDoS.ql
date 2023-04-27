import TestUtilities.InlineExpectationsTest
import semmle.code.java.security.regexp.PolynomialReDoSQuery

class HasPolyRedos extends InlineExpectationsTest {
  HasPolyRedos() { this = "HasPolyRedos" }

  override string getARelevantTag() { result = "hasPolyRedos" }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "hasPolyRedos" and
    exists(DataFlow::Node sink |
      PolynomialRedosFlow::flowTo(sink) and
      location = sink.getLocation() and
      element = sink.toString() and
      value = ""
    )
  }
}

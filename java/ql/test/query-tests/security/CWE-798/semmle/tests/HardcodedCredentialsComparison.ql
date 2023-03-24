import java
import semmle.code.java.security.HardcodedCredentialsComparison
import TestUtilities.InlineExpectationsTest

class HardcodedCredentialsComparisonTest extends InlineExpectationsTest {
  HardcodedCredentialsComparisonTest() { this = "HardcodedCredentialsComparisonTest" }

  override string getARelevantTag() { result = "HardcodedCredentialsComparison" }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "HardcodedCredentialsComparison" and
    exists(Expr sink | isHardcodedCredentialsComparison(sink, _, _) |
      sink.getLocation() = location and
      element = sink.toString() and
      value = ""
    )
  }
}

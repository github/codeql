import java
import semmle.code.java.security.HardcodedCredentialsComparison
import utils.test.InlineExpectationsTest

module HardcodedCredentialsComparisonTest implements TestSig {
  string getARelevantTag() { result = "HardcodedCredentialsComparison" }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "HardcodedCredentialsComparison" and
    exists(Expr sink | isHardcodedCredentialsComparison(sink, _, _) |
      sink.getLocation() = location and
      element = sink.toString() and
      value = ""
    )
  }
}

import MakeTest<HardcodedCredentialsComparisonTest>

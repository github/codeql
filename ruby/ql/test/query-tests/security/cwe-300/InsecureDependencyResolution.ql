import ruby
import TestUtilities.InlineExpectationsTest
import codeql.ruby.security.InsecureDependencyQuery

class InsecureDependencyResolutionTest extends InlineExpectationsTest {
  InsecureDependencyResolutionTest() { this = "InsecureDependencyResolutionTest" }

  override string getARelevantTag() { result = "BAD" }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "result" and
    value = "BAD" and
    exists(Expr e |
      insecureDependencyUrl(e, _) and
      location = e.getLocation() and
      element = e.toString()
    )
  }
}

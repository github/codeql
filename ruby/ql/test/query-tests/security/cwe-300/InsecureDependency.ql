import ruby
import TestUtilities.InlineExpectationsTest
import codeql.ruby.security.InsecureDependencyQuery

class InsecureDependencyTest extends InlineExpectationsTest {
  InsecureDependencyTest() { this = "InsecureDependencyTest" }

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

from Expr url, string msg
where insecureDependencyUrl(url, msg)
select url, msg

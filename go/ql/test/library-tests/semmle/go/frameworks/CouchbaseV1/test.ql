import go
import TestUtilities.InlineExpectationsTest
import semmle.go.security.SqlInjection

class SqlInjectionTest extends InlineExpectationsTest {
  SqlInjectionTest() { this = "SqlInjectionTest" }

  override string getARelevantTag() { result = "sqlinjection" }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "sqlinjection" and
    exists(DataFlow::Node sink | any(SqlInjection::Configuration c).hasFlow(_, sink) |
      element = sink.toString() and
      value = sink.toString() and
      sink.hasLocationInfo(location.getFile().getAbsolutePath(), location.getStartLine(),
        location.getStartColumn(), location.getEndLine(), location.getEndColumn())
    )
  }
}

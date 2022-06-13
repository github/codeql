import go
import TestUtilities.InlineExpectationsTest

class NoSQLQueryTest extends InlineExpectationsTest {
  NoSQLQueryTest() { this = "NoSQLQueryTest" }

  override string getARelevantTag() { result = "nosqlquery" }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(NoSQL::Query q |
      q.hasLocationInfo(location.getFile().getAbsolutePath(), location.getStartLine(),
        location.getStartColumn(), location.getEndLine(), location.getEndColumn()) and
      element = q.toString() and
      value = q.toString() and
      tag = "nosqlquery"
    )
  }
}

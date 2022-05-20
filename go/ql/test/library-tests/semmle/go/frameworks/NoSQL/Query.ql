import go
import TestUtilities.InlineExpectationsTest

class NoSQLQueryTest extends InlineExpectationsTest {
  NoSQLQueryTest() { this = "NoSQLQueryTest" }

  override string getARelevantTag() { result = "nosqlquery" }

  override predicate hasActualResult(string file, int line, string element, string tag, string value) {
    exists(NoSQL::Query q |
      q.hasLocationInfo(file, line, _, _, _) and
      element = q.toString() and
      value = q.toString() and
      tag = "nosqlquery"
    )
  }
}

import go
import TestUtilities.InlineExpectationsTest

class SQLTest extends InlineExpectationsTest {
  SQLTest() { this = "SQLTest" }

  override string getARelevantTag() { result = "query" }

  override predicate hasActualResult(string file, int line, string element, string tag, string value) {
    tag = "query" and
    exists(SQL::Query q, SQL::QueryString qs, string qsFile, int qsLine | qs = q.getAQueryString() |
      q.hasLocationInfo(file, line, _, _, _) and
      qs.hasLocationInfo(qsFile, qsLine, _, _, _) and
      element = q.toString() and
      value = qs.toString()
    )
  }
}

class QueryString extends InlineExpectationsTest {
  QueryString() { this = "QueryString no Query" }

  override string getARelevantTag() { result = "querystring" }

  override predicate hasActualResult(string file, int line, string element, string tag, string value) {
    tag = "querystring" and
    element = "" and
    exists(SQL::QueryString qs | not exists(SQL::Query q | qs = q.getAQueryString()) |
      qs.hasLocationInfo(file, line, _, _, _) and
      value = qs.toString()
    )
  }
}

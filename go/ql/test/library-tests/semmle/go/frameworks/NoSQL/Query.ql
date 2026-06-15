import go
import semmle.go.dataflow.ExternalFlow
import ModelValidation
import utils.test.InlineExpectationsTest

module NoSqlQueryTest implements TestSig {
  string getARelevantTag() { result = "nosqlquery" }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(NoSql::Query q |
      q.getLocation() = location and
      element = q.toString() and
      value = q.toString() and
      tag = "nosqlquery"
    )
  }
}

import MakeTest<NoSqlQueryTest>

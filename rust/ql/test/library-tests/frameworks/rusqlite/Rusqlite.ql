import rust
import codeql.rust.security.SqlInjectionExtensions
import codeql.rust.Concepts
import utils.test.InlineExpectationsTest

module RusqliteTest implements TestSig {
  string getARelevantTag() { result = ["sql-sink", "database-read"] }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(SqlInjection::Sink sink |
      location = sink.getLocation() and
      location.getFile().getBaseName() != "" and
      element = sink.toString() and
      tag = "sql-sink" and
      value = ""
    )
    or
    exists(ModeledDatabaseSource sink |
      location = sink.getLocation() and
      location.getFile().getBaseName() != "" and
      element = sink.toString() and
      tag = "database-read" and
      value = ""
    )
  }
}

import MakeTest<RusqliteTest>

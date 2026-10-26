import rust
import codeql.rust.Concepts
import codeql.rust.security.SqlInjectionExtensions
import utils.test.InlineExpectationsTest

module PostgresTest implements TestSig {
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
    exists(ModeledDatabaseSource source |
      location = source.getLocation() and
      location.getFile().getBaseName() != "" and
      element = source.toString() and
      tag = "database-read" and
      value = ""
    )
  }
}

import MakeTest<PostgresTest>

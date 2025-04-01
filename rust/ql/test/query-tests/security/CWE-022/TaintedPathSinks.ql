import rust
import codeql.rust.security.TaintedPathExtensions
import utils.test.InlineExpectationsTest

module TaintedPathSinksTest implements TestSig {
  string getARelevantTag() { result = "path-injection-sink" }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(TaintedPath::Sink sink |
      location = sink.getLocation() and
      location.getFile().getBaseName() != "" and
      element = sink.toString() and
      tag = "path-injection-sink" and
      value = ""
    )
  }
}

import MakeTest<TaintedPathSinksTest>

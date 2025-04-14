import java
import semmle.code.java.dataflow.TaintTracking
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.security.SpelInjectionQuery
import utils.test.InlineExpectationsTest

module HasSpelInjectionTest implements TestSig {
  string getARelevantTag() { result = "hasSpelInjection" }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "hasSpelInjection" and
    exists(DataFlow::Node sink | SpelInjectionFlow::flowTo(sink) |
      sink.getLocation() = location and
      element = sink.toString() and
      value = ""
    )
  }
}

import MakeTest<HasSpelInjectionTest>

import java
import semmle.code.java.dataflow.TaintTracking
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.security.MvelInjectionQuery
import utils.test.InlineExpectationsTest

module HasMvelInjectionTest implements TestSig {
  string getARelevantTag() { result = "hasMvelInjection" }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "hasMvelInjection" and
    exists(DataFlow::Node sink | MvelInjectionFlow::flowTo(sink) |
      sink.getLocation() = location and
      element = sink.toString() and
      value = ""
    )
  }
}

import MakeTest<HasMvelInjectionTest>

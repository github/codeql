import java
import semmle.code.java.dataflow.TaintTracking
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.security.XsltInjectionQuery
import utils.test.InlineExpectationsTest

module HasXsltInjectionTest implements TestSig {
  string getARelevantTag() { result = "hasXsltInjection" }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "hasXsltInjection" and
    exists(DataFlow::Node sink | XsltInjectionFlow::flowTo(sink) |
      sink.getLocation() = location and
      element = sink.toString() and
      value = ""
    )
  }
}

import MakeTest<HasXsltInjectionTest>

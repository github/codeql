import java
import semmle.code.java.dataflow.TaintTracking
import semmle.code.java.dataflow.FlowSources
import semmle.code.java.security.GroovyInjectionQuery
import utils.test.InlineExpectationsTest

module HasGroovyInjectionTest implements TestSig {
  string getARelevantTag() { result = "hasGroovyInjection" }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "hasGroovyInjection" and
    exists(DataFlow::Node sink | GroovyInjectionFlow::flowTo(sink) |
      sink.getLocation() = location and
      element = sink.toString() and
      value = ""
    )
  }
}

import MakeTest<HasGroovyInjectionTest>

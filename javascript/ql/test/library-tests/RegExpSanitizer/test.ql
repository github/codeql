import javascript
import utils.test.InlineExpectationsTest
import semmle.javascript.frameworks.ClassValidator
import semmle.javascript.security.dataflow.CommandInjectionQuery as CommandInjection
import semmle.javascript.security.dataflow.ReflectedXssQuery as ReflectedXss

module TestConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) {
    source.(DataFlow::CallNode).getCalleeName() = "source"
  }

  predicate isSink(DataFlow::Node sink) {
    sink = any(DataFlow::CallNode call | call.getCalleeName() = "sink").getArgument(0)
  }
}

module TestFlow = TaintTracking::Global<TestConfig>;

module InlineTest implements TestSig {
  string getARelevantTag() { result = ["flow", "command-injection", "reflected-xss", "sanitizer"] }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    element = "" and
    value = "" and
    exists(DataFlow::Node node |
      location = node.getLocation() and
      (
        tag = "flow" and TestFlow::flowTo(node)
        or
        tag = "command-injection" and CommandInjection::CommandInjectionFlow::flowTo(node)
        or
        tag = "reflected-xss" and ReflectedXss::ReflectedXssFlow::flowTo(node)
        or
        tag = "sanitizer" and node = ClassValidator::sanitizingDecorator()
      )
    )
  }
}

import MakeTest<InlineTest>

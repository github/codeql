import go
import TestUtilities.InlineExpectationsTest
import experimental.frameworks.CleverGo

class Configuration extends TaintTracking::Configuration {
  Configuration() { this = "test-configuration" }

  override predicate isSource(DataFlow::Node source) {
    exists(Function fn | fn.hasQualifiedName(_, "source") | source = fn.getACall().getResult())
  }

  override predicate isSink(DataFlow::Node sink) {
    exists(Function fn | fn.hasQualifiedName(_, "sink") | sink = fn.getACall().getAnArgument())
  }
}

module TaintTrackingTest implements TestSig {
  string getARelevantTag() { result = "taintSink" }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "taintSink" and
    exists(DataFlow::Node sink | any(Configuration c).hasFlow(_, sink) |
      element = sink.toString() and
      value = "" and
      sink.hasLocationInfo(location.getFile().getAbsolutePath(), location.getStartLine(),
        location.getStartColumn(), location.getEndLine(), location.getEndColumn())
    )
  }
}

import MakeTest<TaintTrackingTest>

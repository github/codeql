import go
import TestUtilities.InlineExpectationsTest

class Configuration extends DataFlow::Configuration {
  Configuration() { this = "test-configuration" }

  override predicate isSource(DataFlow::Node source) {
    source = any(DataFlow::CallNode c | c.getCalleeName() = "src").getResult(0)
  }

  override predicate isSink(DataFlow::Node sink) {
    sink = any(DataFlow::CallNode c | c.getCalleeName() = "sink").getArgument(0)
  }
}

module DataFlowTest implements TestSig {
  string getARelevantTag() { result = "dataflow" }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "dataflow" and
    exists(DataFlow::Node sink | any(Configuration c).hasFlow(_, sink) |
      element = sink.toString() and
      value = sink.toString() and
      sink.hasLocationInfo(location.getFile().getAbsolutePath(), location.getStartLine(),
        location.getStartColumn(), location.getEndLine(), location.getEndColumn())
    )
  }
}

import MakeTest<DataFlowTest>

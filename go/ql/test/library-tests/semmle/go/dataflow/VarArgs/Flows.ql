import go
import TestUtilities.InlineExpectationsTest

class DataConfiguration extends DataFlow::Configuration {
  DataConfiguration() { this = "data-configuration" }

  override predicate isSource(DataFlow::Node source) {
    source = any(DataFlow::CallNode c | c.getCalleeName() = "source").getResult(0)
  }

  override predicate isSink(DataFlow::Node sink) {
    sink = any(DataFlow::CallNode c | c.getCalleeName() = "sink").getArgument(0)
  }
}

module DataFlowTest implements TestSig {
  string getARelevantTag() { result = "dataflow" }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "dataflow" and
    exists(DataFlow::Node sink | any(DataConfiguration c).hasFlow(_, sink) |
      element = sink.toString() and
      value = "" and
      sink.hasLocationInfo(location.getFile().getAbsolutePath(), location.getStartLine(),
        location.getStartColumn(), location.getEndLine(), location.getEndColumn())
    )
  }
}

class TaintConfiguration extends TaintTracking::Configuration {
  TaintConfiguration() { this = "taint-configuration" }

  override predicate isSource(DataFlow::Node source) {
    source = any(DataFlow::CallNode c | c.getCalleeName() = "source").getResult(0)
  }

  override predicate isSink(DataFlow::Node sink) {
    sink = any(DataFlow::CallNode c | c.getCalleeName() = "sink").getArgument(0)
  }
}

module TaintFlowTest implements TestSig {
  string getARelevantTag() { result = "taintflow" }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "taintflow" and
    exists(DataFlow::Node sink | any(TaintConfiguration c).hasFlow(_, sink) |
      element = sink.toString() and
      value = "" and
      sink.hasLocationInfo(location.getFile().getAbsolutePath(), location.getStartLine(),
        location.getStartColumn(), location.getEndLine(), location.getEndColumn())
    )
  }
}

import MakeTest<MergeTests<DataFlowTest, TaintFlowTest>>

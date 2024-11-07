import go
import semmle.go.dataflow.ExternalFlow
import ModelValidation
import semmle.go.dataflow.internal.FlowSummaryImpl as FlowSummaryImpl
import TestUtilities.InlineExpectationsTest
import MakeTest<FlowTest>

module Config implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  predicate isSink(DataFlow::Node sink) { sink = any(FileSystemAccess fsa).getAPathArgument() }
}

module Flow = TaintTracking::Global<Config>;

module FlowTest implements TestSig {
  string getARelevantTag() { result = "I1[t]" }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "I1[t]" and
    exists(DataFlow::Node sink | Flow::flowTo(sink) |
      sink.hasLocationInfo(location.getFile().getAbsolutePath(), location.getStartLine(),
        location.getStartColumn(), location.getEndLine(), location.getEndColumn()) and
      element = sink.toString() and
      value = ""
    )
  }
}

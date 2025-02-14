import go
import ModelValidation
import utils.test.InlineExpectationsTest
import MakeTest<FlowTest>

module Config implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { sourceNode(source, "qltest") }

  predicate isSink(DataFlow::Node sink) { sinkNode(sink, "qltest") }
}

module Flow = TaintTracking::Global<Config>;

module FlowTest implements TestSig {
  string getARelevantTag() { result = "SEmbedI1[t]" }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "SEmbedI1[t]" and
    exists(DataFlow::Node sink | Flow::flowTo(sink) |
      sink.hasLocationInfo(location.getFile().getAbsolutePath(), location.getStartLine(),
        location.getStartColumn(), location.getEndLine(), location.getEndColumn()) and
      element = sink.toString() and
      value = ""
    )
  }
}

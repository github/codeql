import go
import utils.test.InlineExpectationsTest

class Sink extends DataFlow::Node {
  Sink() {
    exists(DataFlow::CallNode c | c.getTarget().getName() = "sink" | this = c.getAnArgument())
  }
}

private module TestConfig implements DataFlow::ConfigSig {
  predicate isSource(DataFlow::Node source) { source instanceof RemoteFlowSource }

  predicate isSink(DataFlow::Node sink) { sink instanceof Sink }
}

private module TestFlow = TaintTracking::Global<TestConfig>;

module MissingDataFlowTest implements TestSig {
  string getARelevantTag() { result = "noflow" }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "noflow" and
    value = "" and
    exists(Sink sink |
      not TestFlow::flowTo(sink) and
      sink.hasLocationInfo(location.getFile().getAbsolutePath(), location.getStartLine(),
        location.getStartColumn(), location.getEndLine(), location.getEndColumn()) and
      element = sink.toString()
    )
  }
}

module HttpResponseBodyTest implements TestSig {
  string getARelevantTag() { result = "responsebody" }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "responsebody" and
    exists(Http::ResponseBody rb |
      rb.hasLocationInfo(location.getFile().getAbsolutePath(), location.getStartLine(),
        location.getStartColumn(), location.getEndLine(), location.getEndColumn()) and
      element = rb.toString() and
      value = "'" + rb.toString() + "'"
    )
  }
}

import MakeTest<MergeTests<MissingDataFlowTest, HttpResponseBodyTest>>

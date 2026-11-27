import go
import utils.test.InlineExpectationsTest

module LocalFlowTest implements TestSig {
  string getARelevantTag() { result = ["local-flow", "local-taint"] }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(DataFlow::CallNode call, DataFlow::Node sink |
      call.getEnclosingCallable().getName() = "localCapturedFlow" and
      call.getTarget().getName() = "sink" and
      sink = call.getArgument(0) and
      location = sink.getLocation() and
      element = sink.toString() and
      tag = getARelevantTag() and
      value =
        count(DataFlow::CallNode source |
          source.getTarget().getName() = "source" and
          (
            tag = "local-flow" and DataFlow::localFlow(source, sink)
            or
            tag = "local-taint" and TaintTracking::localTaint(source, sink)
          )
        ).toString()
    )
  }
}

import MakeTest<LocalFlowTest>

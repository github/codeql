import javascript
import utils.test.InlineSummaries
import utils.test.InlineExpectationsTest

private DataFlow::SourceNode typeTrack(DataFlow::TypeTracker t, string name) {
  t.start() and
  exists(DataFlow::CallNode call |
    call.getCalleeName() = "source" and
    name = call.getArgument(0).getStringValue() and
    result = call
  )
  or
  exists(DataFlow::TypeTracker t2 | result = typeTrack(t2, name).track(t2, t))
}

DataFlow::SourceNode typeTrack(string name) {
  result = typeTrack(DataFlow::TypeTracker::end(), name)
}

module TestConfig implements TestSig {
  string getARelevantTag() { result = "track" }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    element = "" and
    tag = "track" and
    exists(DataFlow::CallNode call, DataFlow::Node arg |
      call.getCalleeName() = "sink" and
      arg = call.getArgument(0) and
      typeTrack(value).flowsTo(arg) and
      location = arg.getLocation()
    )
  }

  predicate hasOptionalResult(Location location, string element, string tag, string value) {
    none()
  }
}

import MakeTest<TestConfig>

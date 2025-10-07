import ruby
import utils.test.InlineExpectationsTest
import utils.test.InlineFlowTestUtil
private import codeql.ruby.typetracking.TypeTracking

private DataFlow::LocalSourceNode track(TypeTracker t, DataFlow::CallNode source) {
  t.start() and
  defaultSource(source) and
  result = source
  or
  exists(TypeTracker t2 | result = track(t2, source).track(t2, t))
}

DataFlow::LocalSourceNode track(DataFlow::CallNode source) {
  result = track(TypeTracker::end(), source)
}

module TypeTrackingFlowTest implements TestSig {
  string getARelevantTag() { result = "hasValueFlow" }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(DataFlow::Node sink, DataFlow::Node source |
      defaultSink(sink) and
      track(source).flowsTo(sink) and
      location = sink.getLocation() and
      element = sink.toString() and
      tag = "hasValueFlow" and
      value = getSourceArgString(source)
    )
  }
}

import MakeTest<TypeTrackingFlowTest>

import python
import semmle.python.dataflow.new.DataFlow
import utils.test.InlineExpectationsTest
import utils.test.dataflow.testConfig

module CaptureTest implements TestSig {
  string getARelevantTag() { result = "captured" }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(DataFlow::Node sink | TestFlow::flowTo(sink) |
      location = sink.getLocation() and
      tag = "captured" and
      value = "" and
      element = sink.toString()
    )
  }
}

import MakeTest<CaptureTest>

import go
import semmle.go.dataflow.ExternalFlow
import ModelValidation
import utils.test.InlineExpectationsTest

module RemoteFlowSourceTest implements TestSig {
  string getARelevantTag() { result = "RemoteFlowSource" }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(RemoteFlowSource src |
      src.getLocation() = location and
      element = src.toString() and
      value = "" and
      tag = "RemoteFlowSource"
    )
  }
}

import MakeTest<RemoteFlowSourceTest>

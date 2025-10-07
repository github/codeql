import go
import semmle.go.dataflow.ExternalFlow
import ModelValidation
import utils.test.InlineExpectationsTest

module RemoteFlowSourceTest implements TestSig {
  string getARelevantTag() { result = "source" }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(RemoteFlowSource source |
      source.getLocation() = location and
      element = source.toString() and
      value = "\"" + source.toString() + "\"" and
      tag = "source"
    )
  }
}

import MakeTest<RemoteFlowSourceTest>

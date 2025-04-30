import go
import utils.test.InlineExpectationsTest

module FasthttpTest implements TestSig {
  string getARelevantTag() { result = "RemoteFlowSource" }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(RemoteFlowSource source |
      source.getLocation() = location and
      element = source.toString() and
      value = "\"" + source.toString() + "\"" and
      tag = "RemoteFlowSource"
    )
  }
}

import MakeTest<FasthttpTest>

import java
import semmle.code.java.dataflow.FlowSources
import utils.test.InlineExpectationsTest

module JmsRemoteSourcesTest implements TestSig {
  string getARelevantTag() { result = "source" }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "source" and
    exists(RemoteFlowSource source |
      location = source.getLocation() and element = source.toString() and value = ""
    )
  }
}

import MakeTest<JmsRemoteSourcesTest>

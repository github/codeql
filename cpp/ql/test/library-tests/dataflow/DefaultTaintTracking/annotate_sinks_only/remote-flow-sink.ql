/** This tests that we are able to detect remote flow sinks. */

import cpp
import TestUtilities.InlineExpectationsTest
import semmle.code.cpp.security.FlowSources

class RemoteFlowSinkTest extends InlineExpectationsTest {
  RemoteFlowSinkTest() { this = "RemoteFlowSinkTest" }

  override string getARelevantTag() { result = "remote" }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "remote" and
    value = "" and
    exists(RemoteFlowSink node |
      location = node.getLocation() and
      element = node.toString()
    )
  }
}

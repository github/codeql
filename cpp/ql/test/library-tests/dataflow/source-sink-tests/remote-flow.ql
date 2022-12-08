/** This tests that we are able to detect remote flow sources and sinks. */

import cpp
import TestUtilities.InlineExpectationsTest
import semmle.code.cpp.security.FlowSources

class RemoteFlowSourceTest extends InlineExpectationsTest {
  RemoteFlowSourceTest() { this = "RemoteFlowSourceTest" }

  override string getARelevantTag() { result = "remote_source" }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "remote_source" and
    value = "" and
    exists(RemoteFlowSource node |
      location = node.getLocation() and
      element = node.toString()
    )
  }
}

class RemoteFlowSinkTest extends InlineExpectationsTest {
  RemoteFlowSinkTest() { this = "RemoteFlowSinkTest" }

  override string getARelevantTag() { result = "remote_sink" }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "remote_sink" and
    value = "" and
    exists(RemoteFlowSink node |
      location = node.getLocation() and
      element = node.toString()
    )
  }
}

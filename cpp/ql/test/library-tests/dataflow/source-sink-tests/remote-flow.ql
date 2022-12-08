/** This tests that we are able to detect remote flow sources and sinks. */

import cpp
import TestUtilities.InlineExpectationsTest
import semmle.code.cpp.security.FlowSources

class RemoteFlowSourceTest extends InlineExpectationsTest {
  RemoteFlowSourceTest() { this = "RemoteFlowSourceTest" }

  override string getARelevantTag() { result = "remote_source" }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "remote_source" and
    exists(RemoteFlowSource node, int n |
      n =
        strictcount(RemoteFlowSource otherNode |
          node.getLocation().getStartLine() = otherNode.getLocation().getStartLine()
        ) and
      (
        n = 1 and value = ""
        or
        // If there is more than one node on this line
        // we specify the location explicitly.
        n > 1 and
        value =
          node.getLocation().getStartLine().toString() + ":" + node.getLocation().getStartColumn()
      ) and
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
    exists(RemoteFlowSink node, int n |
      n =
        strictcount(RemoteFlowSink otherNode |
          node.getLocation().getStartLine() = otherNode.getLocation().getStartLine()
        ) and
      (
        n = 1 and value = ""
        or
        // If there is more than one node on this line
        // we specify the location explicitly.
        n > 1 and
        value =
          node.getLocation().getStartLine().toString() + ":" + node.getLocation().getStartColumn()
      ) and
      location = node.getLocation() and
      element = node.toString()
    )
  }
}

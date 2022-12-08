/** This tests that we are able to detect local flow sources. */

import cpp
import TestUtilities.InlineExpectationsTest
import semmle.code.cpp.security.FlowSources

class LocalFlowSourceTest extends InlineExpectationsTest {
  LocalFlowSourceTest() { this = "LocalFlowSourceTest" }

  override string getARelevantTag() { result = "local_source" }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "local_source" and
    exists(LocalFlowSource node, int n |
      n =
        strictcount(LocalFlowSource otherNode |
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

/** This tests that we are able to detect local flow sources. */

import cpp
import TestUtilities.InlineExpectationsTest
import semmle.code.cpp.security.FlowSources

class LocalFlowSourceTest extends InlineExpectationsTest {
  LocalFlowSourceTest() { this = "LocalFlowSourceTest" }

  override string getARelevantTag() { result = "local_source" }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "local_source" and
    value = "" and
    exists(LocalFlowSource node |
      location = node.getLocation() and
      element = node.toString()
    )
  }
}

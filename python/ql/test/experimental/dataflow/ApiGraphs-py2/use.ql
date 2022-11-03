import python
import semmle.python.dataflow.new.DataFlow
import TestUtilities.InlineExpectationsTest
import semmle.python.ApiGraphs

class ApiUseTest extends InlineExpectationsTest {
  ApiUseTest() { this = "ApiUseTest" }

  override string getARelevantTag() { result = "use" }

  private predicate relevant_node(API::Node a, DataFlow::Node n, Location l) {
    n = a.getAUse() and l = n.getLocation()
  }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(API::Node a, DataFlow::Node n | relevant_node(a, n, location) |
      tag = "use" and
      // Only report the longest path on this line:
      value =
        max(API::Node a2, Location l2 |
          relevant_node(a2, _, l2) and
          l2.getFile() = location.getFile() and
          l2.getStartLine() = location.getStartLine()
        |
          a2.getPath()
        ) and
      element = n.toString()
    )
  }
}

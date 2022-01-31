import python
import semmle.python.dataflow.new.DataFlow
import TestUtilities.InlineExpectationsTest
import semmle.python.ApiGraphs

class ApiDefTest extends InlineExpectationsTest {
  ApiDefTest() { this = "ApiDefTest" }

  override string getARelevantTag() { result = "def" }

  private predicate relevant_node(API::Node a, DataFlow::Node n, Location l) {
    n = a.getARhs() and
    l = n.getLocation() and
    // Module variable nodes have no suitable location, so it's best to simply exclude them entirely
    // from the inline tests.
    not n instanceof DataFlow::ModuleVariableNode and
    exists(l.getFile().getRelativePath()) and
    n.getLocation().getFile().getBaseName().matches("def%.py")
  }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(API::Node a, DataFlow::Node n | relevant_node(a, n, location) |
      tag = "def" and
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

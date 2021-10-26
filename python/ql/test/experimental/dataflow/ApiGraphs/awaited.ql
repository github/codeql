import python
import semmle.python.dataflow.new.DataFlow
import TestUtilities.InlineExpectationsTest
import semmle.python.ApiGraphs

class AwaitedTest extends InlineExpectationsTest {
  AwaitedTest() { this = "AwaitedTest" }

  override string getARelevantTag() { result = "awaited" }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(API::Node a, DataFlow::Node n, API::Node pred |
      a = pred.getAwaited() and
      n = a.getAUse() and
      location = n.getLocation() and
      // Module variable nodes have no suitable location, so it's best to simply exclude them entirely
      // from the inline tests.
      not n instanceof DataFlow::ModuleVariableNode and
      exists(location.getFile().getRelativePath())
    |
      tag = "awaited" and
      value = pred.getPath() and
      element = n.toString()
    )
  }
}

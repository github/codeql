import python
import semmle.python.dataflow.new.DataFlow
import utils.test.InlineExpectationsTest
import semmle.python.ApiGraphs

module ApiUseTest implements TestSig {
  string getARelevantTag() { result = "use" }

  private predicate relevant_node(API::Node a, DataFlow::Node n, Location l) {
    n = a.getAValueReachableFromSource() and l = n.getLocation()
  }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(DataFlow::Node n | relevant_node(_, n, location) |
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

import MakeTest<ApiUseTest>

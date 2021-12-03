import ruby
import codeql.ruby.DataFlow
import TestUtilities.InlineExpectationsTest
import codeql.ruby.ApiGraphs

class ApiUseTest extends InlineExpectationsTest {
  ApiUseTest() { this = "ApiUseTest" }

  override string getARelevantTag() { result = "use" }

  private predicate relevantNode(API::Node a, DataFlow::Node n, Location l) {
    n = a.getAUse() and
    l = n.getLocation()
  }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(API::Node a, DataFlow::Node n | relevantNode(a, n, location) |
      tag = "use" and
      // Only report the longest path on this line:
      value =
        max(API::Node a2, Location l2, DataFlow::Node n2 |
          relevantNode(a2, n2, l2) and
          l2.getFile() = location.getFile() and
          l2.getStartLine() = location.getStartLine()
        |
          a2.getPath()
          order by
            size(n2.asExpr().getExpr()), a2.getPath().length() desc, a2.getPath() desc
        ) and
      element = n.toString()
    )
  }
}

private int size(AstNode n) { not n instanceof StmtSequence and result = count(n.getAChild*()) }

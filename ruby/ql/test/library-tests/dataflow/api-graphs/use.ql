import ruby
import codeql.ruby.DataFlow
import TestUtilities.InlineExpectationsTest
import codeql.ruby.ApiGraphs

class CustomEntryPointCall extends API::EntryPoint {
  CustomEntryPointCall() { this = "CustomEntryPointCall" }

  override DataFlow::CallNode getACall() { result.getMethodName() = "customEntryPointCall" }
}

class CustomEntryPointUse extends API::EntryPoint {
  CustomEntryPointUse() { this = "CustomEntryPointUse" }

  override DataFlow::LocalSourceNode getAUse() {
    result.(DataFlow::CallNode).getMethodName() = "customEntryPointUse"
  }
}

class ApiUseTest extends InlineExpectationsTest {
  ApiUseTest() { this = "ApiUseTest" }

  override string getARelevantTag() { result = ["use", "def"] }

  private predicate relevantNode(API::Node a, DataFlow::Node n, Location l, string tag) {
    l = n.getLocation() and
    (
      tag = "use" and
      n = a.getAUse()
      or
      tag = "def" and
      n = a.getARhs()
      or
      tag = "call" and
      n = a.(API::MethodAccessNode).getCallNode()
    )
  }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "use" and // def tags are always optional
    exists(API::Node a, DataFlow::Node n | relevantNode(a, n, location, tag) |
      // Only report the longest path on this line:
      value =
        max(API::Node a2, Location l2, DataFlow::Node n2 |
          relevantNode(a2, n2, l2, tag) and
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

  // We also permit optional annotations for any other path on the line.
  // This is used to test subclass paths, which typically have a shorter canonical path.
  override predicate hasOptionalResult(Location location, string element, string tag, string value) {
    exists(API::Node a, DataFlow::Node n | relevantNode(a, n, location, tag) |
      element = n.toString() and
      value = getAPath(a, _)
    )
  }
}

private int size(AstNode n) { not n instanceof StmtSequence and result = count(n.getAChild*()) }

/**
 * Gets a path of the given `length` from the root to the given node.
 * This is a copy of `API::getAPath()` without the restriction on path length,
 * which would otherwise rule out paths involving `getASubclass()`.
 */
string getAPath(API::Node node, int length) {
  node instanceof API::Root and
  length = 0 and
  result = ""
  or
  exists(API::Node pred, API::Label::ApiLabel lbl, string predpath |
    pred.getASuccessor(lbl) = node and
    predpath = getAPath(pred, length - 1) and
    exists(string dot | if length = 1 then dot = "" else dot = "." |
      result = predpath + dot + lbl and
      // avoid producing strings longer than 1MB
      result.length() < 1000 * 1000
    )
  )
}

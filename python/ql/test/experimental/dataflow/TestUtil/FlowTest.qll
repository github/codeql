import python
import semmle.python.dataflow.new.DataFlow
import TestUtilities.InlineExpectationsTest
private import semmle.python.dataflow.new.internal.PrintNode

abstract class FlowTest extends InlineExpectationsTest {
  bindingset[this]
  FlowTest() { any() }

  abstract string flowTag();

  abstract predicate relevantFlow(DataFlow::Node fromNode, DataFlow::Node toNode);

  override string getARelevantTag() { result = this.flowTag() }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(DataFlow::Node fromNode, DataFlow::Node toNode | this.relevantFlow(fromNode, toNode) |
      location = toNode.getLocation() and
      tag = this.flowTag() and
      value =
        "\"" + prettyNode(fromNode).replaceAll("\"", "'") + this.lineStr(fromNode, toNode) + " -> " +
          prettyNode(toNode).replaceAll("\"", "'") + "\"" and
      element = toNode.toString()
    )
  }

  pragma[inline]
  private string lineStr(DataFlow::Node fromNode, DataFlow::Node toNode) {
    exists(int delta |
      delta = fromNode.getLocation().getStartLine() - toNode.getLocation().getStartLine()
    |
      if delta = 0
      then result = ""
      else
        if delta > 0
        then result = ", l:+" + delta.toString()
        else result = ", l:" + delta.toString()
    )
  }
}

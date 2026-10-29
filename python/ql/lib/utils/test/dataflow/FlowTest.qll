import python
import semmle.python.dataflow.new.DataFlow
import utils.test.InlineExpectationsTest
private import semmle.python.dataflow.new.internal.PrintNode

signature module FlowTestSig {
  string flowTag();

  predicate relevantFlow(DataFlow::Node fromNode, DataFlow::Node toNode);
}

module MakeTestSig<FlowTestSig Impl> implements TestSig {
  string getARelevantTag() { result = Impl::flowTag() }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(DataFlow::Node fromNode, DataFlow::Node toNode | Impl::relevantFlow(fromNode, toNode) |
      location = toNode.getLocation() and
      tag = Impl::flowTag() and
      value =
        "\"" + prettyNode(fromNode).replaceAll("\"", "'") + lineStr(fromNode, toNode) + " -> " +
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

import python
import semmle.python.dataflow.new.DataFlow
import TestUtilities.InlineExpectationsTest
import experimental.dataflow.TestUtil.PrintNode

/**
 * A routing test is designed to test that vlues are routed to the
 * correct arguments of the correct functions. It is assumed that
 * the functions tested sink their arguments sequentially, that is
 * `SINK1(arg1)`, etc.
 */
abstract class RoutingTest extends InlineExpectationsTest {
  bindingset[this]
  RoutingTest() { any() }

  abstract string flowTag();

  abstract predicate relevantFlow(DataFlow::Node fromNode, DataFlow::Node toNode);

  override string getARelevantTag() { result in ["func", this.flowTag()] }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(DataFlow::Node fromNode, DataFlow::Node toNode | this.relevantFlow(fromNode, toNode) |
      location = fromNode.getLocation() and
      element = fromNode.toString() and
      (
        tag = this.flowTag() and
        value = "\"" + prettyNode(fromNode).replaceAll("\"", "'") + "\""
        or
        tag = "func" and
        value = toNode.getEnclosingCallable().getCallableValue().getScope().getQualifiedName() // TODO: More robust pretty printing?
      )
    )
  }
}

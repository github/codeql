import python
import semmle.python.dataflow.new.DataFlow
import TestUtilities.InlineExpectationsTest
import semmle.python.functions.ModificationOfParameterWithDefault
private import semmle.python.dataflow.new.internal.PrintNode

class ModificationOfParameterWithDefaultTest extends InlineExpectationsTest {
  ModificationOfParameterWithDefaultTest() { this = "ModificationOfParameterWithDefaultTest" }

  override string getARelevantTag() { result = "modification" }

  predicate relevant_node(DataFlow::Node sink) {
    exists(ModificationOfParameterWithDefault::Configuration cfg | cfg.hasFlowTo(sink))
  }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(DataFlow::Node n | relevant_node(n) |
      n.getLocation() = location and
      tag = "modification" and
      value = prettyNode(n) and
      element = n.toString()
    )
  }
}

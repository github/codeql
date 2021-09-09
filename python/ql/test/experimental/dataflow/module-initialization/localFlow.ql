// This query should be more focused yet.
import python
import experimental.dataflow.TestUtil.FlowTest
private import semmle.python.dataflow.new.internal.PrintNode
private import semmle.python.dataflow.new.internal.DataFlowPrivate as DP

class ImportTimeLocalFlowTest extends InlineExpectationsTest {
  ImportTimeLocalFlowTest() { this = "ImportTimeLocalFlowTest" }

  override string getARelevantTag() { result = "importTimeFlow" }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    exists(DataFlow::Node nodeFrom, DataFlow::ModuleVariableNode nodeTo |
      DP::importTimeLocalFlowStep(nodeFrom, nodeTo)
    |
      nodeFrom.getLocation().getFile().getBaseName() = "multiphase.py" and
      location = nodeFrom.getLocation() and
      tag = "importTimeFlow" and
      value = "\"" + prettyNode(nodeTo).replaceAll("\"", "'") + "\"" and
      element = nodeTo.toString()
    )
  }
}

class RuntimeLocalFlowTest extends FlowTest {
  RuntimeLocalFlowTest() { this = "RuntimeLocalFlowTest" }

  override string flowTag() { result = "runtimFlow" }

  override predicate relevantFlow(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
    nodeFrom.getLocation().getFile().getBaseName() = "multiphase.py" and
    // results are displayed next to `nodeTo`, so we need a line to write on
    nodeTo.getLocation().getStartLine() > 0 and
    (
      nodeFrom instanceof DataFlow::ModuleVariableNode or
      nodeTo instanceof DataFlow::ModuleVariableNode
    ) and
    DP::runtimeJumpStep(nodeFrom, nodeTo)
  }
}

// This query should be more focused yet.
import python
import experimental.dataflow.TestUtil.FlowTest
private import semmle.python.dataflow.new.internal.PrintNode
private import semmle.python.dataflow.new.internal.DataFlowPrivate as DP

class ImportTimeLocalFlowTest extends FlowTest {
  ImportTimeLocalFlowTest() { this = "ImportTimeLocalFlowTest" }

  override string flowTag() { result = "importTimeFlow" }

  override predicate relevantFlow(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
    nodeFrom.getLocation().getFile().getBaseName() = "multiphase.py" and
    // results are displayed next to `nodeTo`, so we need a line to write on
    nodeTo.getLocation().getStartLine() > 0 and
    nodeTo.asVar() instanceof GlobalSsaVariable and
    DP::importTimeLocalFlowStep(nodeFrom, nodeTo)
  }
}

class RuntimeLocalFlowTest extends FlowTest {
  RuntimeLocalFlowTest() { this = "RuntimeLocalFlowTest" }

  override string flowTag() { result = "runtimeFlow" }

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

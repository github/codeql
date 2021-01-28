import python
import semmle.python.dataflow.new.DataFlow
import FlowTest

class LocalFlowStepTest extends FlowTest {
  LocalFlowStepTest() { this = "LocalFlowStepTest" }

  override string flowTag() { result = "step" }

  override predicate relevantFlow(DataFlow::Node fromNode, DataFlow::Node toNode) {
    DataFlow::localFlowStep(fromNode, toNode)
  }
}

import python
import semmle.python.dataflow.new.DataFlow
import FlowTest

module LocalFlowStepTest implements FlowTestSig {
  string flowTag() { result = "step" }

  predicate relevantFlow(DataFlow::Node fromNode, DataFlow::Node toNode) {
    DataFlow::localFlowStep(fromNode, toNode)
  }
}

import MakeTest<MakeTestSig<LocalFlowStepTest>>

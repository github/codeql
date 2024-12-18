// This query should be more focused yet.
import python
import utils.test.dataflow.FlowTest
private import semmle.python.dataflow.new.internal.PrintNode
private import semmle.python.dataflow.new.internal.DataFlowPrivate as DP

module ImportTimeLocalFlowTest implements FlowTestSig {
  string flowTag() { result = "importTimeFlow" }

  predicate relevantFlow(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
    nodeFrom.getLocation().getFile().getBaseName() = "multiphase.py" and
    // results are displayed next to `nodeTo`, so we need a line to write on
    nodeTo.getLocation().getStartLine() > 0 and
    exists(GlobalSsaVariable g |
      nodeTo.asCfgNode() = g.getDefinition().(EssaNodeDefinition).getDefiningNode()
    ) and
    // nodeTo.asVar() instanceof GlobalSsaVariable and
    DP::PhaseDependentFlow<DP::LocalFlow::localFlowStep/2>::importTimeStep(nodeFrom, nodeTo)
  }
}

module RuntimeLocalFlowTest implements FlowTestSig {
  string flowTag() { result = "runtimeFlow" }

  predicate relevantFlow(DataFlow::Node nodeFrom, DataFlow::Node nodeTo) {
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

import MakeTest<MergeTests<MakeTestSig<ImportTimeLocalFlowTest>, MakeTestSig<RuntimeLocalFlowTest>>>

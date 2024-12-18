import codeql.ruby.dataflow.internal.DataFlowPrivate
import codeql.ruby.dataflow.internal.DataFlowPublic
import codeql.ruby.dataflow.BarrierGuards
import codeql.ruby.controlflow.CfgNodes
import codeql.ruby.controlflow.ControlFlowGraph
import codeql.ruby.controlflow.BasicBlocks
import codeql.ruby.DataFlow
import utils.test.InlineExpectationsTest

query predicate newStyleBarrierGuards(DataFlow::Node n) {
  n instanceof StringConstCompareBarrier or
  n instanceof StringConstArrayInclusionCallBarrier
}

query predicate controls(CfgNode condition, BasicBlock bb, SuccessorTypes::ConditionalSuccessor s) {
  exists(ConditionBlock cb |
    cb.controls(bb, s) and
    condition = cb.getLastNode()
  )
}

module BarrierGuardTest implements TestSig {
  string getARelevantTag() { result = "guarded" }

  predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "guarded" and
    exists(DataFlow::Node n |
      newStyleBarrierGuards(n) and
      not n instanceof SsaInputNode and
      location = n.getLocation() and
      element = n.toString() and
      value = ""
    )
  }
}

import MakeTest<BarrierGuardTest>

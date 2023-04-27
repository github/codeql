import codeql.ruby.dataflow.internal.DataFlowPublic
import codeql.ruby.dataflow.BarrierGuards
import codeql.ruby.controlflow.CfgNodes
import codeql.ruby.controlflow.ControlFlowGraph
import codeql.ruby.controlflow.BasicBlocks
import codeql.ruby.DataFlow
import TestUtilities.InlineExpectationsTest

query predicate oldStyleBarrierGuards(
  BarrierGuard g, DataFlow::Node guardedNode, ExprCfgNode expr, boolean branch
) {
  g.checks(expr, branch) and guardedNode = g.getAGuardedNode()
}

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

class BarrierGuardTest extends InlineExpectationsTest {
  BarrierGuardTest() { this = "BarrierGuardTest" }

  override string getARelevantTag() { result = "guarded" }

  override predicate hasActualResult(Location location, string element, string tag, string value) {
    tag = "guarded" and
    exists(DataFlow::Node n |
      newStyleBarrierGuards(n) and
      location = n.getLocation() and
      element = n.toString() and
      value = ""
    )
  }
}

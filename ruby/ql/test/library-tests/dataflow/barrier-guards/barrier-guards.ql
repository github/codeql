import codeql.ruby.dataflow.internal.DataFlowPublic
import codeql.ruby.dataflow.BarrierGuards
import codeql.ruby.controlflow.CfgNodes
import codeql.ruby.controlflow.ControlFlowGraph
import codeql.ruby.controlflow.BasicBlocks
import codeql.ruby.DataFlow

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

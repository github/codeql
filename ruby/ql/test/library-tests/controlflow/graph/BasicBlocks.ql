import codeql.ruby.controlflow.ControlFlowGraph
import codeql.ruby.controlflow.BasicBlocks

query predicate conditionBlockControls(ConditionBlock cb, CfgNode cn, BasicBlock bb, SuccessorType s) {
  cn = cb.getLastNode() and
  cb.immediatelyControls(bb, s)
}

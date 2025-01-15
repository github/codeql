import ruby
import codeql.ruby.controlflow.ControlFlowGraph
import codeql.ruby.controlflow.BasicBlocks

query predicate dominates(BasicBlock bb1, BasicBlock bb2) { bb1.dominates(bb2) }

query predicate postDominance(BasicBlock bb1, BasicBlock bb2) { bb1.postDominates(bb2) }

query predicate immediateDominator(BasicBlock bb1, BasicBlock bb2) {
  bb1.getImmediateDominator() = bb2
}

query predicate controls(ConditionBlock bb1, BasicBlock bb2, SuccessorType t) {
  bb1.controls(bb2, t)
}

query predicate successor(ConditionBlock bb1, BasicBlock bb2, SuccessorType t) {
  bb1.getASuccessor(t) = bb2
}

query predicate joinBlockPredecessor(JoinBlock bb1, BasicBlock bb2, int i) {
  bb1.getJoinBlockPredecessor(i) = bb2
}

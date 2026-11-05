import codeql.ruby.controlflow.ControlFlowGraph

query predicate dominates(BasicBlock bb1, BasicBlock bb2) { bb1.dominates(bb2) }

query predicate postDominance(BasicBlock bb1, BasicBlock bb2) { bb1.postDominates(bb2) }

query predicate immediateDominator(BasicBlock bb1, BasicBlock bb2) {
  bb1.getImmediateDominator() = bb2
}

query predicate controls(BasicBlock bb1, BasicBlock bb2, ConditionalSuccessor t) {
  bb1.edgeDominates(bb2, t)
}

query predicate successor(BasicBlock bb1, BasicBlock bb2, ConditionalSuccessor t) {
  bb1.getASuccessor(t) = bb2
}

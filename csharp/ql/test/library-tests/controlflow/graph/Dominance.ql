import csharp
import Common

query predicate dominance(SourceControlFlowNode dom, SourceControlFlowNode node) {
  dom.strictlyDominates(node) and
  dom.getASuccessor() = node
}

query predicate postDominance(SourceControlFlowNode dom, SourceControlFlowNode node) {
  dom.strictlyPostDominates(node) and
  dom.getAPredecessor() = node
}

query predicate blockDominance(SourceBasicBlock dom, SourceBasicBlock bb) { dom.dominates(bb) }

query predicate postBlockDominance(SourceBasicBlock dom, SourceBasicBlock bb) {
  dom.postDominates(bb)
}

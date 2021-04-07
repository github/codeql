import csharp
import Common

/** Holds if `node` is not from a library. */
private predicate isSourceBased(SourceControlFlowNode node) { not node.getElement().fromLibrary() }

query predicate dominance(SourceControlFlowNode dom, SourceControlFlowNode node) {
  isSourceBased(dom) and
  dom.strictlyDominates(node) and
  dom.getASuccessor() = node
}

query predicate postDominance(SourceControlFlowNode dom, SourceControlFlowNode node) {
  isSourceBased(dom) and
  dom.strictlyPostDominates(node) and
  dom.getAPredecessor() = node
}

query predicate blockDominance(SourceBasicBlock dom, SourceBasicBlock bb) {
  isSourceBased(dom.getFirstNode()) and dom.dominates(bb)
}

query predicate postBlockDominance(SourceBasicBlock dom, SourceBasicBlock bb) {
  isSourceBased(dom.getFirstNode()) and dom.postDominates(bb)
}

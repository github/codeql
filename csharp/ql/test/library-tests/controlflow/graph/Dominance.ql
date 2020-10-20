import csharp
import Common

query predicate dominance(SourceControlFlowNode dom, SourceControlFlowNode node) {
  dom.strictlyDominates(node) and
  dom.getASuccessor() = node and
  dom.getLocation().getFile().fromSource()
}

query predicate postDominance(SourceControlFlowNode dom, SourceControlFlowNode node) {
  dom.strictlyPostDominates(node) and
  dom.getAPredecessor() = node and
  dom.getLocation().getFile().fromSource()
}

query predicate blockDominance(SourceBasicBlock dom, SourceBasicBlock bb) {
  dom.dominates(bb) and
  dom.getLocation().getFile().fromSource()
}

query predicate postBlockDominance(SourceBasicBlock dom, SourceBasicBlock bb) {
  dom.postDominates(bb) and
  dom.getLocation().getFile().fromSource()
}

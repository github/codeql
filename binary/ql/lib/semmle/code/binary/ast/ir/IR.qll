import internal.Instruction2.Instruction2::Instruction2
// import internal.Instruction1.Instruction1::Instruction1
// import internal.Instruction0.Instruction0::Instruction0
import semmle.code.binary.ast.Location
import codeql.controlflow.SuccessorType
private import codeql.controlflow.BasicBlock as BB

final private class BasicBlockAlias = BasicBlock;

final private class ControlFlowNodeAlias = ControlFlowNode;

module BinaryCfg implements BB::CfgSig<Location> {
  class ControlFlowNode = ControlFlowNodeAlias;

  class BasicBlock extends BasicBlockAlias {
    ControlFlowNode getNode(int i) { result = super.getNode(i) }

    ControlFlowNode getLastNode() { result = super.getLastNode() }

    int length() { result = strictcount(super.getNode(_)) }

    BasicBlock getASuccessor() { result = super.getASuccessor() }

    BasicBlock getASuccessor(SuccessorType t) { exists(t) and result = super.getASuccessor() }

    predicate strictlyDominates(BasicBlock bb) { super.strictlyDominates(bb) }

    predicate dominates(BasicBlock bb) { super.dominates(bb) }

    BasicBlock getImmediateDominator() { result = super.getImmediateDominator() }

    predicate inDominanceFrontier(BasicBlock df) { super.inDominanceFrontier(df) }

    predicate strictlyPostDominates(BasicBlock bb) { super.strictlyPostDominates(bb) }

    predicate postDominates(BasicBlock bb) { super.postDominates(bb) }

    predicate edgeDominates(BasicBlock dominated, SuccessorType s) {
      exists(BasicBlock succ |
        succ = this.getASuccessor(s) and dominatingEdge(this, succ) and succ.dominates(dominated)
      )
    }
  }

  class EntryBasicBlock extends BasicBlock {
    EntryBasicBlock() { this.isFunctionEntryBasicBlock() }
  }

  additional class ConditionBasicBlock extends BasicBlock {
    ConditionBasicBlock() { this.getLastNode().asInstruction() instanceof CJumpInstruction }
  }

  pragma[nomagic]
  predicate dominatingEdge(BasicBlock bb1, BasicBlock bb2) {
    bb1.getASuccessor() = bb2 and
    bb1 = bb2.getImmediateDominator() and
    forall(BasicBlock pred | pred = bb2.getAPredecessor() and pred != bb1 | bb2.dominates(pred))
  }
}

class EntryBasicBlock = BinaryCfg::EntryBasicBlock;

class ConditionBasicBlock = BinaryCfg::ConditionBasicBlock;

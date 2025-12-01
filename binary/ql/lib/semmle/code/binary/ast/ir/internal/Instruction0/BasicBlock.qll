private import semmle.code.binary.ast.Location
private import Instruction
private import Operand
private import InstructionTag
private import codeql.controlflow.BasicBlock as BB
private import codeql.util.Unit
private import codeql.controlflow.SuccessorType
private import Function

private ControlFlowNode getASuccessor(ControlFlowNode n) { result = n.getSuccessor(_) }

private ControlFlowNode getAPredecessor(ControlFlowNode n) { n = getASuccessor(result) }

private predicate isJoin(ControlFlowNode n) { strictcount(getAPredecessor(n)) > 1 }

private predicate isBranch(ControlFlowNode n) { strictcount(getASuccessor(n)) > 1 }

private predicate startsBasicBlock(ControlFlowNode n) {
  n.asOperand() = any(Function f).getEntryInstruction().getFirstOperand()
  or
  exists(Instruction i |
    n.asInstruction() = i and
    i = any(Function f).getEntryInstruction() and
    not exists(i.getAnOperand())
  )
  or
  not exists(getAPredecessor(n)) and exists(getASuccessor(n))
  or
  isJoin(n)
  or
  isBranch(getAPredecessor(n))
}

newtype TBasicBlock = TMkBasicBlock(ControlFlowNode n) { startsBasicBlock(n) }

private predicate intraBBSucc(ControlFlowNode n1, ControlFlowNode n2) {
  n2 = getASuccessor(n1) and
  not startsBasicBlock(n2)
}

private predicate bbIndex(ControlFlowNode bbStart, ControlFlowNode i, int index) =
  shortestDistances(startsBasicBlock/1, intraBBSucc/2)(bbStart, i, index)

private predicate entryBB(BasicBlock bb) { bb.isFunctionEntryBasicBlock() }

private predicate succBB(BasicBlock pred, BasicBlock succ) { pred.getASuccessor() = succ }

/** Holds if `dom` is an immediate dominator of `bb`. */
cached
private predicate bbIdominates(BasicBlock dom, BasicBlock bb) =
  idominance(entryBB/1, succBB/2)(_, dom, bb)

private predicate predBB(BasicBlock succ, BasicBlock pred) { pred.getASuccessor() = succ }

class FunctionExitBasicBlock extends BasicBlock {
  FunctionExitBasicBlock() { this.getLastNode().asInstruction() instanceof RetInstruction }
}

private predicate exitBB(FunctionExitBasicBlock exit) { any() }

/** Holds if `dom` is an immediate post-dominator of `bb`. */
cached
predicate bbIPostDominates(BasicBlock dom, BasicBlock bb) =
  idominance(exitBB/1, predBB/2)(_, dom, bb)

module BinaryCfg implements BB::CfgSig<Location> {
  private newtype TControlFlowNode =
    TInstructionControlFlowNode(Instruction i) or
    TOperandControlFlowNode(Operand op)

  class ControlFlowNode extends TControlFlowNode {
    Instruction asInstruction() { this = TInstructionControlFlowNode(result) }

    Operand asOperand() { this = TOperandControlFlowNode(result) }

    string toString() {
      result = this.asInstruction().toString()
      or
      result = this.asOperand().toString()
    }

    Location getLocation() {
      result = this.asInstruction().getLocation()
      or
      result = this.asOperand().getLocation()
    }

    ControlFlowNode getSuccessor(SuccessorType t) {
      t instanceof DirectSuccessor and
      exists(Instruction i, OperandTag tag | this.asOperand() = i.getOperand(tag) |
        result.asOperand() = i.getOperand(tag.getSuccessorTag())
        or
        this.asOperand() = i.getOperand(tag) and
        not exists(i.getOperand(tag.getSuccessorTag())) and
        result.asInstruction() = i
      )
      or
      exists(Instruction i | i = this.asInstruction().getSuccessor(t) |
        result.asOperand() = i.getFirstOperand()
        or
        not exists(i.getAnOperand()) and
        result.asInstruction() = i
      )
    }

    Function getEnclosingFunction() {
      result = this.asInstruction().getEnclosingFunction()
      or
      result = this.asOperand().getEnclosingFunction()
    }
  }

  class BasicBlock extends TBasicBlock {
    ControlFlowNode getNode(int i) { bbIndex(this.getFirstNode(), result, i) }

    ControlFlowNode getLastNode() { result = this.getNode(this.getNumberOfInstructions() - 1) }

    int length() { result = strictcount(this.getNode(_)) }

    BasicBlock getASuccessor() { result = this.getASuccessor(_) }

    ControlFlowNode getANode() { result = this.getNode(_) }

    ControlFlowNode getFirstNode() { this = TMkBasicBlock(result) }

    BasicBlock getASuccessor(SuccessorType t) {
      result.getFirstNode() = this.getLastNode().getSuccessor(t)
    }

    BasicBlock getAPredecessor() { this = result.getASuccessor() }

    int getNumberOfInstructions() { result = strictcount(this.getNode(_)) }

    string toString() { result = this.getFirstNode().toString() + ".." + this.getLastNode() }

    string getDumpString() {
      result =
        strictconcat(int index, ControlFlowNode node |
          node = this.getNode(index)
        |
          node.toString(), "\n" order by index
        )
    }

    Location getLocation() { result = this.getFirstNode().getLocation() }

    Function getEnclosingFunction() { result = this.getFirstNode().getEnclosingFunction() }

    predicate isFunctionEntryBasicBlock() {
      any(Function f).getEntryInstruction() =
        [this.getFirstNode().asInstruction(), this.getFirstNode().asOperand().getUse()]
    }

    predicate strictlyDominates(BasicBlock bb) { bbIdominates+(this, bb) }

    predicate dominates(BasicBlock bb) { this.strictlyDominates(bb) or this = bb }

    predicate inDominanceFrontier(BasicBlock df) {
      this.getASuccessor() = df and
      not bbIdominates(this, df)
      or
      exists(BasicBlock prev | prev.inDominanceFrontier(df) |
        bbIdominates(this, prev) and
        not bbIdominates(this, df)
      )
    }

    BasicBlock getImmediateDominator() { bbIdominates(result, this) }

    /**
     * Holds if this basic block strictly post-dominates basic block `bb`.
     *
     * That is, all paths reaching a normal exit point basic block from basic
     * block `bb` must go through this basic block and this basic block is
     * different from `bb`.
     */
    predicate strictlyPostDominates(BasicBlock bb) { bbIPostDominates+(this, bb) }

    /**
     * Holds if this basic block post-dominates basic block `bb`.
     *
     * That is, all paths reaching a normal exit point basic block from basic
     * block `bb` must go through this basic block.
     */
    predicate postDominates(BasicBlock bb) {
      this.strictlyPostDominates(bb) or
      this = bb
    }
  }

  class EntryBasicBlock extends BasicBlock {
    EntryBasicBlock() { this.isFunctionEntryBasicBlock() }
  }

  pragma[nomagic]
  predicate dominatingEdge(BasicBlock bb1, BasicBlock bb2) {
    bb1.getASuccessor() = bb2 and
    bb1 = bb2.getImmediateDominator() and
    forall(BasicBlock pred | pred = bb2.getAPredecessor() and pred != bb1 | bb2.dominates(pred))
  }
}

class BasicBlock = BinaryCfg::BasicBlock;

class ControlFlowNode = BinaryCfg::ControlFlowNode;

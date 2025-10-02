private import binary
private import codeql.controlflow.BasicBlock as BB
private import codeql.util.Unit
private import codeql.controlflow.SuccessorType

Instruction getASuccessor(Instruction i) { result = i.getASuccessor() }

Instruction getAPredecessor(Instruction i) { i = getASuccessor(result) }

private predicate isJoin(Instruction i) { strictcount(getAPredecessor(i)) > 1 }

private predicate isBranch(Instruction i) { strictcount(getASuccessor(i)) > 1 }

private predicate startsBasicBlock(Instruction i) {
  i instanceof ProgramEntryInstruction
  or
  not exists(getAPredecessor(i)) and exists(getASuccessor(i))
  or
  any(Call call).getTarget() = i
  or
  isJoin(i)
  or
  isBranch(getAPredecessor(i))
}

newtype TBasicBlock = TMkBasicBlock(Instruction i) { startsBasicBlock(i) }

private predicate intraBBSucc(Instruction i1, Instruction i2) {
  i2 = getASuccessor(i1) and
  not startsBasicBlock(i2)
}

private predicate bbIndex(Instruction bbStart, Instruction i, int index) =
  shortestDistances(startsBasicBlock/1, intraBBSucc/2)(bbStart, i, index)

private predicate entryBB(FunctionEntryBasicBlock entry) { any() }

private predicate succBB(BasicBlock pred, BasicBlock succ) { pred.getASuccessor() = succ }

/** Holds if `dom` is an immediate dominator of `bb`. */
cached
private predicate bbIdominates(BasicBlock dom, BasicBlock bb) =
  idominance(entryBB/1, succBB/2)(_, dom, bb)

private predicate predBB(BasicBlock succ, BasicBlock pred) { pred.getASuccessor() = succ }

class FunctionExitBasicBlock extends BasicBlock {
  FunctionExitBasicBlock() { this.getLastInstruction() instanceof Ret }
}

private predicate exitBB(FunctionExitBasicBlock exit) { any() }

/** Holds if `dom` is an immediate post-dominator of `bb`. */
cached
predicate bbIPostDominates(BasicBlock dom, BasicBlock bb) =
  idominance(exitBB/1, predBB/2)(_, dom, bb)

class BasicBlock extends TBasicBlock {
  Instruction getInstruction(int index) { bbIndex(this.getFirstInstruction(), result, index) }

  Instruction getAnInstruction() { result = this.getInstruction(_) }

  Instruction getFirstInstruction() { this = TMkBasicBlock(result) }

  Instruction getLastInstruction() {
    result = this.getInstruction(this.getNumberOfInstructions() - 1)
  }

  BasicBlock getASuccessor() {
    result.getFirstInstruction() = this.getLastInstruction().getASuccessor()
  }

  BasicBlock getBackEdgeSuccessor() {
    result = this.getASuccessor() and
    result.getFirstInstruction().getIndex() < this.getFirstInstruction().getIndex()
  }

  BasicBlock getAPredecessor() { this = result.getASuccessor() }

  int getNumberOfInstructions() { result = strictcount(this.getInstruction(_)) }

  string toString() {
    result = this.getFirstInstruction().toString() + ".." + this.getLastInstruction()
  }

  string getDumpString() {
    result =
      strictconcat(int index, Instruction instr |
        instr = this.getInstruction(index)
      |
        instr.toString(), "\n" order by index
      )
  }

  Location getLocation() { result = this.getFirstInstruction().getLocation() }

  Function getEnclosingFunction() { result.getABasicBlock() = this }

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

final private class BasicBlockAlias = BasicBlock;

class ProgramEntryBasicBlock extends BasicBlock {
  ProgramEntryBasicBlock() { this.getFirstInstruction() instanceof ProgramEntryInstruction }
}

module BinaryCfg implements BB::CfgSig<Location> {
  class ControlFlowNode = Instruction;

  class BasicBlock extends BasicBlockAlias {
    ControlFlowNode getNode(int i) { result = super.getInstruction(i) }

    ControlFlowNode getLastNode() { result = super.getLastInstruction() }

    int length() { result = strictcount(super.getInstruction(_)) }

    BasicBlock getASuccessor() { result = super.getASuccessor() }

    BasicBlock getASuccessor(SuccessorType t) { exists(t) and result = super.getASuccessor() }

    predicate strictlyDominates(BasicBlock bb) { super.strictlyDominates(bb) }

    predicate dominates(BasicBlock bb) { super.dominates(bb) }

    BasicBlock getImmediateDominator() { result = super.getImmediateDominator() }

    predicate inDominanceFrontier(BasicBlock df) { super.inDominanceFrontier(df) }

    predicate strictlyPostDominates(BasicBlock bb) { super.strictlyPostDominates(bb) }

    predicate postDominates(BasicBlock bb) { super.postDominates(bb) }
  }

  class EntryBasicBlock extends BasicBlock instanceof FunctionEntryBasicBlock { }

  pragma[nomagic]
  predicate dominatingEdge(BasicBlock bb1, BasicBlock bb2) {
    bb1.getASuccessor() = bb2 and
    bb1 = bb2.getImmediateDominator() and
    forall(BasicBlock pred | pred = bb2.getAPredecessor() and pred != bb1 | bb2.dominates(pred))
  }
}

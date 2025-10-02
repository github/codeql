private import semmle.code.binary.ast.Location
private import Instruction
private import codeql.controlflow.BasicBlock as BB
private import codeql.util.Unit
private import codeql.controlflow.SuccessorType
private import Function

Instruction getASuccessor(Instruction i) { result = i.getASuccessor() }

Instruction getAPredecessor(Instruction i) { i = getASuccessor(result) }

private predicate isJoin(Instruction i) { strictcount(getAPredecessor(i)) > 1 }

private predicate isBranch(Instruction i) { strictcount(getASuccessor(i)) > 1 }

private predicate startsBasicBlock(Instruction i) {
  i = any(Function f).getEntryInstruction()
  or
  not exists(getAPredecessor(i)) and exists(getASuccessor(i))
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

  Function getEnclosingFunction() { result = this.getFirstInstruction().getEnclosingFunction() }

  predicate isFunctionEntryBasicBlock() {
    any(Function f).getEntryInstruction() = this.getFirstInstruction()
  }
}

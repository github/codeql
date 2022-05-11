private import semmle.code.cpp.ir.IR as IR

class BasicBlock = IR::IRBlock;

private newtype TSsaVariable = MkSsaVariable(IR::Instruction instr)

class SsaVariable extends IR::Instruction {
  SsaVariable() {
    this.getResultIRType() instanceof IR::IRNumericType and
    this.hasMemoryResult() and
    // If a Phi has at least one inexact input, we treat it as an "unknown sign" expression.
    not exists(IR::PhiInputOperand operand |
      operand = this.(IR::PhiInstruction).getAnInputOperand()
    |
      operand.isDefinitionInexact()
    )
  }
}

class SsaPhiNode extends SsaVariable, IR::PhiInstruction {
  predicate hasInputFromBlock(SsaVariable v, BasicBlock block) {
    exists(IR::PhiInputOperand operand | operand = this.getAnInputOperand() |
      operand.getDef() = v and
      operand.getPredecessorBlock() = block
    )
  }

  BasicBlock getBasicBlock() { result = this.getBlock() }
}

/** Gets a basic block in which SSA variable `v` is read. */
BasicBlock getAReadBasicBlock(SsaVariable v) { result = v.getAUse().getUse().getBlock() }

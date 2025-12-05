/**
 * Provides the module `Ssa` for working with static single assignment (SSA) form.
 */

/**
 * Provides classes for working with static single assignment (SSA) form.
 */
module Ssa {
  private import semmle.code.binary.ast.ir.IR
  private import internal.SsaImpl as SsaImpl

  /** A static single assignment (SSA) definition. */
  class Definition extends SsaImpl::Definition {
    final ControlFlowNode getControlFlowNode() {
      exists(BasicBlock bb, int i | this.definesAt(_, bb, i) | result = bb.getNode(i))
    }

    final Operand getARead() { result = SsaImpl::getARead(this) }

    private Definition getAPhiInputOrPriorDefinition() {
      result = this.(PhiDefinition).getAnInput()
    }

    final Definition getAnUltimateDefinition() {
      result = this.getAPhiInputOrPriorDefinition*() and
      not result instanceof PhiDefinition
    }

    Instruction asInstruction() { result = this.getControlFlowNode().asInstruction() }

    /** Gets the function of this SSA definition. */
    Function getFunction() { result = this.getBasicBlock().getEnclosingFunction() }
  }

  class WriteDefinition extends Definition, SsaImpl::WriteDefinition {
    private Instruction write;

    WriteDefinition() {
      exists(BasicBlock bb, int i, Variable v |
        this.definesAt(v, bb, i) and
        SsaImpl::variableWriteActual(bb, i, v, write)
      )
    }

    /** Gets the underlying write access. */
    final Instruction getWriteAccess() { result = write }

    predicate assigns(Operand value) { value = write.(CopyInstruction).getOperand() }
  }

  class PhiDefinition extends Definition, SsaImpl::PhiDefinition {
    final Definition getAnInput() { this.hasInputFromBlock(result, _) }

    predicate hasInputFromBlock(Definition inp, BasicBlock bb) {
      inp = SsaImpl::phiHasInputFromBlock(this, bb)
    }
  }
}

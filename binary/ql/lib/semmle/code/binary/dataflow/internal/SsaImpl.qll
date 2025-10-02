private import binary
private import codeql.ssa.Ssa as SsaImplCommon
private import semmle.code.binary.controlflow.BasicBlock

pragma[nomagic]
private predicate isClear(Instruction instr) {
  exists(Register r, XorInstruction xor |
    instr = xor and
    pragma[only_bind_out](xor.getOperand(0).(RegisterOperand).getRegister()) = r and
    pragma[only_bind_out](xor.getOperand(1).(RegisterOperand).getRegister()) = r
  )
}

module SsaInput implements SsaImplCommon::InputSig<Location, BinaryCfg::BasicBlock> {
  private newtype TSourceVariable =
    TRegisterSourceVariable(Register reg, Function f) {
      exists(Instruction instr |
        instr.getAnOperand() = reg.getAnAccess().getDirectUse() and
        not isClear(instr) and
        instr.getEnclosingFunction() = f
      )
    } or
    TMemorySourceVariable(Register reg, int offset, Function f) {
      exists(MemoryOperand mem |
        mem.getEnclosingFunction() = f and
        // This instruction does not actually load anything. It's often used in a prologue
        not mem.getUse() instanceof LeaInstruction and
        mem.getBaseRegister().getTarget() = reg and
        mem.getDisplacementValue() = offset
      |
        reg instanceof RspRegister
        or
        reg instanceof RbpRegister
      )
    }

  class SourceVariable extends TSourceVariable {
    string toString() {
      exists(Register reg, int offset |
        this.asParameter(reg, offset, _)
        or
        this.asLocalStackVariable(reg, offset, _)
      |
        result = reg.toString() + "+" + offset.toString()
      )
      or
      exists(Register reg | this.asLocalRegisterVariable(reg, _) and result = reg.toString())
    }

    predicate asParameter(Register reg, int offset, Function f) {
      this = TMemorySourceVariable(reg, offset, f) and
      offset > 0
    }

    predicate asLocalStackVariable(Register reg, int offset, Function f) {
      this = TMemorySourceVariable(reg, offset, f) and
      offset < 0
    }

    predicate asLocalRegisterVariable(Register reg, Function f) {
      this = TRegisterSourceVariable(reg, f)
    }

    Location getLocation() { result instanceof EmptyLocation }
  }

  bindingset[instr]
  pragma[inline_late]
  private Function getInstructionEnclosingFunctionLate(Instruction instr) {
    result.getABasicBlock() = instr.getBasicBlock()
  }

  pragma[nomagic]
  private RegisterAccess getARegisterAccessInFunction(Register r, Function f) {
    result.getEnclosingFunction() = f and
    result.getTarget() = r
  }

  bindingset[r, f]
  pragma[inline_late]
  private predicate asLocalRegisterVariableLate(SourceVariable v, Register r, Function f) {
    v.asLocalRegisterVariable(r, f)
  }

  predicate variableWrite(BinaryCfg::BasicBlock bb, int i, SourceVariable v, boolean certain) {
    certain = true and
    exists(Instruction instr, Function f |
      instr = bb.getInstruction(i) and
      getInstructionEnclosingFunctionLate(instr) = f
    |
      exists(Register r |
        asLocalRegisterVariableLate(v, r, f) and
        instr.(MovInstruction).getOperand(0) = getARegisterAccessInFunction(r, f).getDirectUse()
        or
        exists(int offset, MemoryOperand mem |
          v.asLocalStackVariable(r, offset, f) and
          instr.(MovInstruction).getOperand(0) = mem and
          mem.getBaseRegister() = getARegisterAccessInFunction(r, f) and
          mem.getDisplacementValue() = offset
        )
      )
    )
  }

  additional predicate variableRead(
    BinaryCfg::BasicBlock bb, int i, SourceVariable v, Operand op, boolean certain
  ) {
    certain = true and
    exists(Instruction instr, Function f |
      instr = bb.getInstruction(i) and
      getInstructionEnclosingFunctionLate(instr) = f and
      op = instr.(MovInstruction).getOperand(1)
    |
      exists(Register r |
        asLocalRegisterVariableLate(v, r, f) and
        op = getARegisterAccessInFunction(r, f).getDirectUse()
        or
        exists(int offset, MemoryOperand mem |
          v.asLocalStackVariable(r, offset, f) and
          op = mem and
          mem.getBaseRegister() = getARegisterAccessInFunction(r, f) and
          mem.getDisplacementValue() = offset
        )
      )
    )
  }

  predicate variableRead(BinaryCfg::BasicBlock bb, int i, SourceVariable v, boolean certain) {
    variableRead(bb, i, v, _, certain)
  }
}

import SsaImplCommon::Make<Location, BinaryCfg, SsaInput> as Impl

class Definition = Impl::Definition;

class WriteDefinition = Impl::WriteDefinition;

class PhiDefinition = Impl::PhiNode;

cached
private module Cached {
  cached
  Instruction getARead(Definition def) {
    exists(SsaInput::SourceVariable v, BasicBlock bb, int i |
      Impl::ssaDefReachesRead(v, def, bb, i) and
      SsaInput::variableRead(bb, i, v, true) and
      result = bb.getInstruction(i)
    )
  }

  // cached
  // Definition phiHasInputFromBlock(PhiDefinition phi, BasicBlock bb) {
  //   Impl::phiHasInputFromBlock(phi, result, bb)
  // }
  cached
  module DataFlowIntegration {
    import DataFlowIntegrationImpl

    cached
    predicate localFlowStep(
      SsaInput::SourceVariable v, Node nodeFrom, Node nodeTo, boolean isUseStep
    ) {
      DataFlowIntegrationImpl::localFlowStep(v, nodeFrom, nodeTo, isUseStep)
    }

    cached
    predicate localMustFlowStep(SsaInput::SourceVariable v, Node nodeFrom, Node nodeTo) {
      DataFlowIntegrationImpl::localMustFlowStep(v, nodeFrom, nodeTo)
    }
  }
}

import Cached

private module DataFlowIntegrationInput implements Impl::DataFlowIntegrationInputSig {
  private import DataFlowImpl as DataFlowImpl
  private import codeql.util.Void

  class Expr extends Instruction {
    predicate hasCfgNode(BinaryCfg::BasicBlock bb, int i) { this = bb.getInstruction(i) }
  }

  Expr getARead(Definition def) { result = Cached::getARead(def) }

  class GuardValue = Void;

  class Guard extends Instruction {
    predicate hasValueBranchEdge(
      BinaryCfg::BasicBlock bb1, BinaryCfg::BasicBlock bb2, GuardValue val
    ) {
      none()
    }

    predicate valueControlsBranchEdge(
      BinaryCfg::BasicBlock bb1, BinaryCfg::BasicBlock bb2, GuardValue val
    ) {
      none()
    }
  }

  predicate guardDirectlyControlsBlock(Guard guard, BinaryCfg::BasicBlock bb, GuardValue val) {
    none()
  }
}

private module DataFlowIntegrationImpl = Impl::DataFlowIntegration<DataFlowIntegrationInput>;

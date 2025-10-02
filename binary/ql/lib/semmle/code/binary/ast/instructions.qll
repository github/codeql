private import internal.instructions as Internal
private import binary
private import Headers
private import Sections
private import semmle.code.binary.controlflow.BasicBlock
private import Functions
private import codeql.util.Unit

private class TElement = @instruction or @operand;

class Element extends TElement {
  string toString() { none() }
}

private module Pre {
  module PreInput implements Internal::InstructionInputSig {
    class BaseInstruction extends Internal::Instruction {
      private string toString0() { instruction_string(this, result) }

      string toString() {
        if exists(this.getAnOperand())
        then
          result =
            this.toString0() + " " +
              strictconcat(int i, string s | s = this.getOperand(i).toString() | s, ", " order by i)
        else result = this.toString0()
      }

      Operand getOperand(int i) { operand(result, this, i, _) }

      Operand getAnOperand() { result = this.getOperand(_) }
    }

    abstract private class MyCall extends BaseInstruction instanceof Internal::Call {
      Operand op;

      MyCall() { op = this.getOperand(0) }

      abstract Internal::Instruction getTarget();
    }

    private class CallImmediate extends MyCall {
      override ImmediateOperand op;
      BaseInstruction target;

      CallImmediate() {
        op.isRelative() and
        op.getValue().toBigInt() + this.getIndex() + this.getLength().toBigInt() = target.getIndex()
      }

      override Internal::Instruction getTarget() { result = target }
    }

    private class CallConstantMemoryOperand extends MyCall {
      override MemoryOperand op;
      int displacement;

      CallConstantMemoryOperand() {
        op.getBaseRegister().getTarget() instanceof RipRegister and
        not exists(op.getIndexRegister()) and
        displacement = op.getDisplacementValue()
      }

      final override BaseInstruction getTarget() {
        exists(
          QlBuiltins::BigInt rip, QlBuiltins::BigInt effectiveVA,
          QlBuiltins::BigInt offsetWithinSection, RDataSection rdata, QlBuiltins::BigInt address
        |
          rip = this.getVirtualAddress() + this.getLength().toBigInt() and
          effectiveVA = rip + displacement.toBigInt() and
          offsetWithinSection = effectiveVA - rdata.getVirtualAddress().toBigInt() and
          address = rdata.read8Bytes(offsetWithinSection) - any(OptionalHeader h).getImageBase() and
          result.getVirtualAddress() = address
        )
      }
    }

    BaseInstruction getCallTarget(BaseInstruction b) { result = b.(MyCall).getTarget() }

    abstract private class MyJumping extends BaseInstruction instanceof Internal::JumpingInstruction
    {
      abstract BaseInstruction getTarget();
    }

    private class ImmediateRelativeJumping extends MyJumping {
      ImmediateOperand op;

      ImmediateRelativeJumping() { op = this.getOperand(0) and op.isRelative() }

      final override BaseInstruction getTarget() {
        op.getValue().toBigInt() + this.getIndex() + this.getLength().toBigInt() = result.getIndex()
      }
    }

    BaseInstruction getJumpTarget(BaseInstruction b) { result = b.(MyJumping).getTarget() }
  }

  import Internal::MakeInstructions<PreInput> as Instructions
}

private int getOffsetOfEntryPoint() {
  result = any(OptionalHeader x).getEntryPoint() - any(TextSection s).getVirtualAddress()
}

private module Input implements Internal::InstructionInputSig {
  private class ProgramEntryInstruction0 extends Pre::Instructions::Instruction {
    ProgramEntryInstruction0() { this.getIndex() = getOffsetOfEntryPoint().toBigInt() }
  }

  private predicate fwd(Pre::Instructions::Instruction i) {
    i instanceof ProgramEntryInstruction0
    or
    exists(Pre::Instructions::Instruction i0 | fwd(i0) |
      i0.getASuccessor() = i
      or
      Pre::PreInput::getCallTarget(i0) = i
    )
  }

  class BaseInstruction extends Pre::Instructions::Instruction {
    BaseInstruction() { fwd(this) }

    BasicBlock getBasicBlock() { result.getAnInstruction() = this }

    Function getEnclosingFunction() { result.getABasicBlock() = this.getBasicBlock() }
  }

  BaseInstruction getCallTarget(BaseInstruction b) { result = Pre::PreInput::getCallTarget(b) }

  BaseInstruction getJumpTarget(BaseInstruction b) { result = Pre::PreInput::getJumpTarget(b) }
}

import Internal::MakeInstructions<Input>

class ProgramEntryInstruction extends Instruction {
  ProgramEntryInstruction() { this.getIndex() = getOffsetOfEntryPoint().toBigInt() }
}

class AdditionalDumpText extends Unit {
  abstract string getAdditionalDumpText(Instruction i);
}

string getAdditionalDumpText(Instruction i) {
  result = any(AdditionalDumpText adt).getAdditionalDumpText(i)
}

private class CallMemoryOperandWithDisplacementInstructionAdditionalDumpText extends AdditionalDumpText
{
  final override string getAdditionalDumpText(Instruction i) {
    result = i.(Call).getTarget().getEnclosingFunction().getName()
  }
}

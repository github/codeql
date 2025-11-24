private import internal.instructions as Internal
private import binary
private import Headers
private import Sections
private import Functions
private import codeql.util.Unit

private class TElement = @instruction or @operand;

class Element extends TElement {
  final string toString() {
    exists(string sInstr |
      instruction_string(this, sInstr) and
      result =
        sInstr + " " +
          concat(Element op, int i, string sOp |
            operand(op, this, i, _) and operand_string(op, sOp)
          |
            sOp, ", " order by i
          )
    )
    or
    operand_string(this, result)
  }

  Element getNext() {
    exists(int a, int b, int length |
      instruction(this, a, b, _) and
      instruction_length(this, length) and
      instruction(result, a, b + length, _)
    )
  }
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
    }

    class BaseRegister extends Internal::Register { }

    class BaseRipRegister extends BaseRegister, Internal::RipRegister { }

    class BaseRspRegister extends BaseRegister, Internal::RspRegister { }

    class BaseRbpRegister extends BaseRegister, Internal::RbpRegister { }

    class BaseOperand extends Internal::Operand { }

    class BaseRegisterAccess extends Internal::RegisterAccess {
      BaseRegister getTarget() { result = super.getTarget() }
    }

    class BaseUnusedOperand extends BaseOperand, Internal::UnusedOperand { }

    class BaseRegisterOperand extends BaseOperand, Internal::RegisterOperand {
      BaseRegisterAccess getAccess() { result = super.getAccess() }
    }

    class BasePointerOperand extends BaseOperand, Internal::PointerOperand { }

    class BaseImmediateOperand extends BaseOperand, Internal::ImmediateOperand { }

    abstract private class MyCall extends BaseInstruction instanceof Internal::Call {
      Internal::Operand op;

      MyCall() { op = this.getOperand(0) }

      abstract Internal::Instruction getTarget();
    }

    private class CallImmediate extends MyCall {
      override Internal::ImmediateOperand op;
      BaseInstruction target;

      CallImmediate() {
        op.isRelative() and
        op.getValue().toBigInt() + this.getIndex() + this.getLength().toBigInt() = target.getIndex()
      }

      override Internal::Instruction getTarget() { result = target }
    }

    class BaseMemoryOperand extends Operand instanceof Internal::MemoryOperand {
      predicate hasDisplacement() { super.hasDisplacement() }

      BaseRegisterAccess getSegmentRegister() { result = super.getSegmentRegister() }

      BaseRegisterAccess getBaseRegister() { result = super.getBaseRegister() }

      BaseRegisterAccess getIndexRegister() { result = super.getIndexRegister() }

      int getScaleFactor() { result = super.getScaleFactor() }

      int getDisplacementValue() { result = super.getDisplacementValue() }
    }

    private class CallConstantMemoryOperand extends MyCall {
      override Internal::MemoryOperand op;
      int displacement;

      CallConstantMemoryOperand() {
        op.getBaseRegister().getTarget() instanceof Internal::RipRegister and
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

private int getOffsetOfAnExportedFunction() {
  result = any(ExportTableEntry e).getAddress() - any(TextSection s).getVirtualAddress()
}

private module Input implements Internal::InstructionInputSig {
  private class ProgramEntryInstruction0 extends Pre::Instructions::Instruction {
    ProgramEntryInstruction0() { this.getIndex() = getOffsetOfEntryPoint().toBigInt() }
  }

  private class ExportedInstruction0 extends Pre::Instructions::Instruction {
    ExportedInstruction0() { this.getIndex() = getOffsetOfAnExportedFunction().toBigInt() }
  }

  private predicate fwd(Pre::Instructions::Instruction i) {
    i instanceof ProgramEntryInstruction0
    or
    i instanceof ExportedInstruction0
    or
    exists(Pre::Instructions::Instruction i0 | fwd(i0) |
      i0.getASuccessor() = i
      or
      Pre::PreInput::getCallTarget(i0) = i
    )
  }

  class BaseInstruction extends Pre::Instructions::Instruction {
    BaseInstruction() { fwd(this) }
  }

  BaseInstruction getCallTarget(BaseInstruction b) { result = Pre::PreInput::getCallTarget(b) }

  BaseInstruction getJumpTarget(BaseInstruction b) { result = Pre::PreInput::getJumpTarget(b) }

  class BaseRegister extends Pre::Instructions::Register { }

  class BaseRipRegister extends BaseRegister, Pre::Instructions::RipRegister { }

  class BaseRspRegister extends BaseRegister, Pre::Instructions::RspRegister { }

  class BaseRbpRegister extends BaseRegister, Pre::Instructions::RbpRegister { }

  class BaseOperand extends Pre::Instructions::Operand {
    BaseOperand() { this.getUse() instanceof BaseInstruction }
  }

  class BaseRegisterAccess extends Pre::Instructions::RegisterAccess {
    BaseRegister getTarget() { result = super.getTarget() }
  }

  class BaseUnusedOperand extends BaseOperand, Pre::Instructions::UnusedOperand { }

  class BaseRegisterOperand extends BaseOperand, Pre::Instructions::RegisterOperand {
    BaseRegisterAccess getAccess() { result = super.getAccess() }
  }

  final private class FinalBaseOperand = BaseOperand;

  class BaseMemoryOperand extends FinalBaseOperand, Pre::Instructions::MemoryOperand {
    BaseRegisterAccess getSegmentRegister() { result = super.getSegmentRegister() }

    BaseRegisterAccess getBaseRegister() { result = super.getBaseRegister() }

    BaseRegisterAccess getIndexRegister() { result = super.getIndexRegister() }
  }

  class BasePointerOperand extends BaseOperand, Pre::Instructions::PointerOperand { }

  class BaseImmediateOperand extends BaseOperand, Pre::Instructions::ImmediateOperand { }
}

import Internal::MakeInstructions<Input>

class ProgramEntryInstruction extends Instruction {
  ProgramEntryInstruction() { this.getIndex() = getOffsetOfEntryPoint().toBigInt() }
}

class ExportedEntryInstruction extends Instruction {
  ExportedEntryInstruction() { this.getIndex() = getOffsetOfAnExportedFunction().toBigInt() }
}

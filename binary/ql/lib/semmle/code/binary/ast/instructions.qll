private import internal.X86Instructions as Internal
private import binary
private import Headers
private import Sections
private import codeql.util.Unit

private class TElement = @x86_instruction or @operand or @il_instruction or @method or @il_parameter or @type or @jvm_instruction or @jvm_parameter;

class Element extends TElement {
  final string toString() { none() }
}

private class X86InstructionElement extends Element {
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
  }
}

private class X86OperandElement extends Element {
  final string toString() { operand_string(this, result) }
}

private class IlInstructionElement extends Element {
  final string toString() { instruction_string(this, result) }
}

private class CilMethodElement extends Element {
  final string toString() { methods(this, result, _, _) }
}

private module Pre {
  module PreInput implements Internal::InstructionInputSig {
    class BaseX86Instruction extends Internal::X86Instruction {
      private string toString0() { instruction_string(this, result) }

      override string toString() {
        if exists(this.getAnOperand())
        then
          result =
            this.toString0() + " " +
              strictconcat(int i, string s | s = this.getOperand(i).toString() | s, ", " order by i)
        else result = this.toString0()
      }
    }

    class BaseX86Register extends Internal::X86Register {
      BaseX86Register getASubRegister() { result = super.getASubRegister() }
    }

    class BaseRipRegister extends BaseX86Register instanceof Internal::RipRegister { }

    class BaseRspRegister extends BaseX86Register instanceof Internal::RspRegister { }

    class BaseRbpRegister extends BaseX86Register instanceof Internal::RbpRegister { }

    class BaseRcxRegister extends BaseX86Register instanceof Internal::RcxRegister { }

    class BaseRdxRegister extends BaseX86Register instanceof Internal::RdxRegister { }

    class BaseR8Register extends BaseX86Register instanceof Internal::R8Register { }

    class BaseR9Register extends BaseX86Register instanceof Internal::R9Register { }

    class BaseX86Operand extends Internal::X86Operand { }

    class BaseX86RegisterAccess extends Internal::X86RegisterAccess {
      BaseX86Register getTarget() { result = super.getTarget() }
    }

    class BaseX86UnusedOperand extends BaseX86Operand, Internal::X86UnusedOperand { }

    class BaseX86RegisterOperand extends BaseX86Operand, Internal::X86RegisterOperand {
      BaseX86RegisterAccess getAccess() { result = super.getAccess() }
    }

    class BaseX86PointerOperand extends BaseX86Operand, Internal::X86PointerOperand { }

    class BaseX86ImmediateOperand extends BaseX86Operand, Internal::X86ImmediateOperand { }

    abstract private class MyCall extends BaseX86Instruction instanceof Internal::X86Call {
      Internal::X86Operand op;

      MyCall() { op = this.getOperand(0) }

      abstract Internal::X86Instruction getTarget();
    }

    private class CallImmediate extends MyCall {
      override Internal::X86ImmediateOperand op;
      BaseX86Instruction target;

      CallImmediate() {
        op.isRelative() and
        op.getValue().toBigInt() + this.getIndex() + this.getLength().toBigInt() = target.getIndex()
      }

      override Internal::X86Instruction getTarget() { result = target }
    }

    class BaseX86MemoryOperand extends X86Operand instanceof Internal::X86MemoryOperand {
      predicate hasDisplacement() { super.hasDisplacement() }

      BaseX86RegisterAccess getSegmentRegister() { result = super.getSegmentRegister() }

      BaseX86RegisterAccess getBaseRegister() { result = super.getBaseRegister() }

      BaseX86RegisterAccess getIndexRegister() { result = super.getIndexRegister() }

      int getScaleFactor() { result = super.getScaleFactor() }

      int getDisplacementValue() { result = super.getDisplacementValue() }
    }

    private class CallConstantMemoryOperand extends MyCall {
      override Internal::X86MemoryOperand op;
      int displacement;

      CallConstantMemoryOperand() {
        op.getBaseRegister().getTarget() instanceof Internal::RipRegister and
        not exists(op.getIndexRegister()) and
        displacement = op.getDisplacementValue()
      }

      final override BaseX86Instruction getTarget() {
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

    BaseX86Instruction getCallTarget(BaseX86Instruction b) { result = b.(MyCall).getTarget() }

    abstract private class MyJumping extends BaseX86Instruction instanceof Internal::X86JumpingInstruction
    {
      abstract BaseX86Instruction getTarget();
    }

    private class ImmediateRelativeJumping extends MyJumping {
      X86ImmediateOperand op;

      ImmediateRelativeJumping() { op = this.getOperand(0) and op.isRelative() }

      final override BaseX86Instruction getTarget() {
        op.getValue().toBigInt() + this.getIndex() + this.getLength().toBigInt() = result.getIndex()
      }
    }

    BaseX86Instruction getJumpTarget(BaseX86Instruction b) { result = b.(MyJumping).getTarget() }
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
  private class ProgramEntryInstruction0 extends Pre::Instructions::X86Instruction {
    ProgramEntryInstruction0() { this.getIndex() = getOffsetOfEntryPoint().toBigInt() }
  }

  private class ExportedInstruction0 extends Pre::Instructions::X86Instruction {
    ExportedInstruction0() { this.getIndex() = getOffsetOfAnExportedFunction().toBigInt() }
  }

  private predicate fwd(Pre::Instructions::X86Instruction i) {
    i instanceof ProgramEntryInstruction0
    or
    i instanceof ExportedInstruction0
    or
    exists(Pre::Instructions::X86Instruction i0 | fwd(i0) |
      i0.getASuccessor() = i
      or
      Pre::PreInput::getCallTarget(i0) = i
    )
  }

  class BaseX86Instruction extends Pre::Instructions::X86Instruction {
    BaseX86Instruction() { fwd(this) }
  }

  BaseX86Instruction getCallTarget(BaseX86Instruction b) {
    result = Pre::PreInput::getCallTarget(b)
  }

  BaseX86Instruction getJumpTarget(BaseX86Instruction b) {
    result = Pre::PreInput::getJumpTarget(b)
  }

  class BaseX86Register extends Pre::Instructions::X86Register {
    BaseX86Register getASubRegister() { result = super.getASubRegister() }
  }

  class BaseRipRegister extends BaseX86Register instanceof Pre::Instructions::RipRegister { }

  class BaseRspRegister extends BaseX86Register instanceof Pre::Instructions::RspRegister { }

  class BaseRbpRegister extends BaseX86Register instanceof Pre::Instructions::RbpRegister { }

  class BaseRcxRegister extends BaseX86Register instanceof Pre::Instructions::RcxRegister { }

  class BaseRdxRegister extends BaseX86Register instanceof Pre::Instructions::RdxRegister { }

  class BaseR8Register extends BaseX86Register instanceof Pre::Instructions::R8Register { }

  class BaseR9Register extends BaseX86Register instanceof Pre::Instructions::R9Register { }

  class BaseX86Operand extends Pre::Instructions::X86Operand {
    BaseX86Operand() { this.getUse() instanceof BaseX86Instruction }
  }

  class BaseX86RegisterAccess extends Pre::Instructions::X86RegisterAccess {
    BaseX86Register getTarget() { result = super.getTarget() }
  }

  class BaseX86UnusedOperand extends BaseX86Operand, Pre::Instructions::X86UnusedOperand { }

  class BaseX86RegisterOperand extends BaseX86Operand, Pre::Instructions::X86RegisterOperand {
    BaseX86RegisterAccess getAccess() { result = super.getAccess() }
  }

  final private class FinalBaseX86Operand = BaseX86Operand;

  class BaseX86MemoryOperand extends FinalBaseX86Operand, Pre::Instructions::X86MemoryOperand {
    BaseX86RegisterAccess getSegmentRegister() { result = super.getSegmentRegister() }

    BaseX86RegisterAccess getBaseRegister() { result = super.getBaseRegister() }

    BaseX86RegisterAccess getIndexRegister() { result = super.getIndexRegister() }
  }

  class BaseX86PointerOperand extends BaseX86Operand, Pre::Instructions::X86PointerOperand { }

  class BaseX86ImmediateOperand extends BaseX86Operand, Pre::Instructions::X86ImmediateOperand { }
}

import Internal::MakeInstructions<Input>

class ProgramEntryInstruction extends X86Instruction {
  ProgramEntryInstruction() { this.getIndex() = getOffsetOfEntryPoint().toBigInt() }
}

class ExportedEntryInstruction extends X86Instruction {
  ExportedEntryInstruction() { this.getIndex() = getOffsetOfAnExportedFunction().toBigInt() }
}

import internal.CilInstructions
import internal.JvmInstructions

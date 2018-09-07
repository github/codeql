private import internal.IRInternal
import Instruction
import IRBlock
import cpp

private newtype TOperandTag =
  TAddressOperand() or
  TBufferSizeOperand() or
  TSideEffectOperand() or
  TCopySourceOperand() or
  TUnaryOperand() or
  TLeftOperand() or
  TRightOperand() or
  TReturnValueOperand() or
  TExceptionOperand() or
  TConditionOperand() or
  TUnmodeledUseOperand() or
  TCallTargetOperand() or
  TThisArgumentOperand() or
  TPositionalArgumentOperand(int argIndex) {
    argIndex in [0..Construction::getMaxCallArgIndex()] or
    exists(BuiltInOperation op |
      exists(op.getChild(argIndex))
    )
  } or
  TPhiOperand(IRBlock predecessorBlock) {
    exists(PhiInstruction phi |
      predecessorBlock = Construction::getPhiInstructionBlockStart(phi).getBlock().getAPredecessor()
    )
  }

/**
 * Identifies the kind of operand on an instruction. Each `Instruction` has at
 * most one operand of any single `OperandTag`. The set of `OperandTag`s used by
 * an `Instruction` is determined by the instruction's opcode.
 */
abstract class OperandTag extends TOperandTag {
   abstract string toString();

   abstract int getSortOrder();

   string getLabel() {
     result = ""
   }
}

// Note: individual subtypes are listed in the order that the operands should
// appear in the operand list of the instruction when printing.

/**
 * The address operand of an instruction that loads or stores a value from
 * memory (e.g. `Load`, `Store`, `InitializeParameter`, `IndirectReadSideEffect`).
 */
class AddressOperand extends OperandTag, TAddressOperand {
  override final string toString() {
    result = "Address"
  }

  override final int getSortOrder() {
    result = 0
  }
}

AddressOperand addressOperand() {
  result = TAddressOperand()
}

/**
 * The buffer size operand of an instruction that represents a read or write of
 * a buffer.
 */
class BufferSizeOperand extends OperandTag, TBufferSizeOperand {
  override final string toString() {
    result = "BufferSize"
  }

  override final int getSortOrder() {
    result = 1
  }
}

/**
 * The operand representing the read side effect of a `SideEffectInstruction`.
 */
class SideEffectOperand extends OperandTag, TSideEffectOperand {
  override final string toString() {
    result = "SideEffect"
  }

  override final int getSortOrder() {
    result = 2
  }
}

/**
 * The source value operand of an instruction that copies this value to its
 * result (e.g. `Copy`, `Load`, `Store`).
 */
class CopySourceOperand extends OperandTag, TCopySourceOperand {
  override final string toString() {
    result = "CopySource"
  }

  override final int getSortOrder() {
    result = 3
  }
}

CopySourceOperand copySourceOperand() {
  result = TCopySourceOperand()
}

/**
 * The sole operand of a unary instruction (e.g. `Convert`, `Negate`).
 */
class UnaryOperand extends OperandTag, TUnaryOperand {
  override final string toString() {
    result = "Unary"
  }

  override final int getSortOrder() {
    result = 4
  }
}

UnaryOperand unaryOperand() {
  result = TUnaryOperand()
}

/**
 * The left operand of a binary instruction (e.g. `Add`, `CompareEQ`).
 */
class LeftOperand extends OperandTag, TLeftOperand {
  override final string toString() {
    result = "Left"
  }

  override final int getSortOrder() {
    result = 5
  }
}

LeftOperand leftOperand() {
  result = TLeftOperand()
}

/**
 * The right operand of a binary instruction (e.g. `Add`, `CompareEQ`).
 */
class RightOperand extends OperandTag, TRightOperand {
  override final string toString() {
    result = "Right"
  }

  override final int getSortOrder() {
    result = 6
  }
}

RightOperand rightOperand() {
  result = TRightOperand()
}

/**
 * The return value operand of a `ReturnValue` instruction.
 */
class ReturnValueOperand extends OperandTag, TReturnValueOperand {
  override final string toString() {
    result = "ReturnValue"
  }

  override final int getSortOrder() {
    result = 7
  }
}

ReturnValueOperand returnValueOperand() {
  result = TReturnValueOperand()
}

/**
 * The exception thrown by a `ThrowValue` instruction.
 */
class ExceptionOperand extends OperandTag, TExceptionOperand {
  override final string toString() {
    result = "Exception"
  }

  override final int getSortOrder() {
    result = 8
  }
}

ExceptionOperand exceptionOperand() {
  result = TExceptionOperand()
}

/**
 * The condition operand of a `ConditionalBranch` or `Switch` instruction.
 */
class ConditionOperand extends OperandTag, TConditionOperand {
  override final string toString() {
    result = "Condition"
  }

  override final int getSortOrder() {
    result = 9
  }
}

ConditionOperand conditionOperand() {
  result = TConditionOperand()
}

/**
 * An operand of the special `UnmodeledUse` instruction, representing a value
 * whose set of uses is unknown.
 */
class UnmodeledUseOperand extends OperandTag, TUnmodeledUseOperand {
  override final string toString() {
    result = "UnmodeledUse"
  }

  override final int getSortOrder() {
    result = 10
  }
}

UnmodeledUseOperand unmodeledUseOperand() {
  result = TUnmodeledUseOperand()
}

/**
 * The operand representing the target function of an `Call` instruction.
 */
class CallTargetOperand extends OperandTag, TCallTargetOperand {
  override final string toString() {
    result = "CallTarget"
  }

  override final int getSortOrder() {
    result = 11
  }
}

CallTargetOperand callTargetOperand() {
  result = TCallTargetOperand()
}

/**
 * An operand representing an argument to a function call. This includes both
 * positional arguments (represented by `PositionalArgumentOperand`) and the
 * implicit `this` argument, if any (represented by `ThisArgumentOperand`).
 */
abstract class ArgumentOperand extends OperandTag {
}

/**
 * An operand representing the implicit 'this' argument to a member function
 * call.
 */
class ThisArgumentOperand extends ArgumentOperand, TThisArgumentOperand {
  ThisArgumentOperand() {
    this = TThisArgumentOperand()
  }

  override final string toString() {
    result = "Arg(this)"
  }

  override final int getSortOrder() {
    result = 12
  }

  override final string getLabel() {
    result = "this:"
  }
}

ThisArgumentOperand thisArgumentOperand() {
  result = TThisArgumentOperand()
}

/**
 * An operand representing an argument to a function call.
 */
class PositionalArgumentOperand extends ArgumentOperand,
  TPositionalArgumentOperand {
  int argIndex;

  PositionalArgumentOperand() {
    this = TPositionalArgumentOperand(argIndex)
  }

  override final string toString() {
    result = "Arg(" + argIndex + ")"
  }

  override final int getSortOrder() {
    result = 13 + argIndex
  }

  final int getArgIndex() {
    result = argIndex
  }
}

PositionalArgumentOperand positionalArgumentOperand(int argIndex) {
  result = TPositionalArgumentOperand(argIndex)
}

/**
 * An operand of an SSA `Phi` instruction.
 */
class PhiOperand extends OperandTag, TPhiOperand {
  IRBlock predecessorBlock;

  PhiOperand() {
    this = TPhiOperand(predecessorBlock)
  }

  override final string toString() {
    result = "Phi"
  }

  override final int getSortOrder() {
    result = 13 + getPredecessorBlock().getDisplayIndex()
  }

  override final string getLabel() {
    result = "from " + getPredecessorBlock().getDisplayIndex().toString() + ":"
  }

  final IRBlock getPredecessorBlock() {
    result = predecessorBlock
  }
}

PhiOperand phiOperand(IRBlock predecessorBlock) {
  result = TPhiOperand(predecessorBlock)
}

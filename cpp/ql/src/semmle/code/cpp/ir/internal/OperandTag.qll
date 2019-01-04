import cpp

private int getMaxCallArgIndex() {
  result = max(int argIndex |
    exists(FunctionCall call |
      exists(call.getArgument(argIndex))
    )
  )
}

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
    argIndex in [0..getMaxCallArgIndex()] or
    exists(BuiltInOperation op |
      exists(op.getChild(argIndex))
    )
  } or
  TChiTotalOperand() or
  TChiPartialOperand()

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
class AddressOperandTag extends OperandTag, TAddressOperand {
  override final string toString() {
    result = "Address"
  }

  override final int getSortOrder() {
    result = 0
  }
}

AddressOperandTag addressOperand() {
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
class SideEffectOperandTag extends OperandTag, TSideEffectOperand {
  override final string toString() {
    result = "SideEffect"
  }

  override final int getSortOrder() {
    result = 2
  }
}

SideEffectOperandTag sideEffectOperand() {
  result = TSideEffectOperand()
}

/**
 * The source value operand of an instruction that copies this value to its
 * result (e.g. `Copy`, `Load`, `Store`).
 */
class CopySourceOperandTag extends OperandTag, TCopySourceOperand {
  override final string toString() {
    result = "CopySource"
  }

  override final int getSortOrder() {
    result = 3
  }
}

CopySourceOperandTag copySourceOperand() {
  result = TCopySourceOperand()
}

/**
 * The sole operand of a unary instruction (e.g. `Convert`, `Negate`).
 */
class UnaryOperandTag extends OperandTag, TUnaryOperand {
  override final string toString() {
    result = "Unary"
  }

  override final int getSortOrder() {
    result = 4
  }
}

UnaryOperandTag unaryOperand() {
  result = TUnaryOperand()
}

/**
 * The left operand of a binary instruction (e.g. `Add`, `CompareEQ`).
 */
class LeftOperandTag extends OperandTag, TLeftOperand {
  override final string toString() {
    result = "Left"
  }

  override final int getSortOrder() {
    result = 5
  }
}

LeftOperandTag leftOperand() {
  result = TLeftOperand()
}

/**
 * The right operand of a binary instruction (e.g. `Add`, `CompareEQ`).
 */
class RightOperandTag extends OperandTag, TRightOperand {
  override final string toString() {
    result = "Right"
  }

  override final int getSortOrder() {
    result = 6
  }
}

RightOperandTag rightOperand() {
  result = TRightOperand()
}

/**
 * The return value operand of a `ReturnValue` instruction.
 */
class ReturnValueOperandTag extends OperandTag, TReturnValueOperand {
  override final string toString() {
    result = "ReturnValue"
  }

  override final int getSortOrder() {
    result = 7
  }
}

ReturnValueOperandTag returnValueOperand() {
  result = TReturnValueOperand()
}

/**
 * The exception thrown by a `ThrowValue` instruction.
 */
class ExceptionOperandTag extends OperandTag, TExceptionOperand {
  override final string toString() {
    result = "Exception"
  }

  override final int getSortOrder() {
    result = 8
  }
}

ExceptionOperandTag exceptionOperand() {
  result = TExceptionOperand()
}

/**
 * The condition operand of a `ConditionalBranch` or `Switch` instruction.
 */
class ConditionOperandTag extends OperandTag, TConditionOperand {
  override final string toString() {
    result = "Condition"
  }

  override final int getSortOrder() {
    result = 9
  }
}

ConditionOperandTag conditionOperand() {
  result = TConditionOperand()
}

/**
 * An operand of the special `UnmodeledUse` instruction, representing a value
 * whose set of uses is unknown.
 */
class UnmodeledUseOperandTag extends OperandTag, TUnmodeledUseOperand {
  override final string toString() {
    result = "UnmodeledUse"
  }

  override final int getSortOrder() {
    result = 10
  }
}

UnmodeledUseOperandTag unmodeledUseOperand() {
  result = TUnmodeledUseOperand()
}

/**
 * The operand representing the target function of an `Call` instruction.
 */
class CallTargetOperandTag extends OperandTag, TCallTargetOperand {
  override final string toString() {
    result = "CallTarget"
  }

  override final int getSortOrder() {
    result = 11
  }
}

CallTargetOperandTag callTargetOperand() {
  result = TCallTargetOperand()
}

/**
 * An operand representing an argument to a function call. This includes both
 * positional arguments (represented by `PositionalArgumentOperand`) and the
 * implicit `this` argument, if any (represented by `ThisArgumentOperand`).
 */
abstract class ArgumentOperandTag extends OperandTag {
}

/**
 * An operand representing the implicit 'this' argument to a member function
 * call.
 */
class ThisArgumentOperandTag extends ArgumentOperandTag, TThisArgumentOperand {
  ThisArgumentOperandTag() {
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

ThisArgumentOperandTag thisArgumentOperand() {
  result = TThisArgumentOperand()
}

/**
 * An operand representing an argument to a function call.
 */
class PositionalArgumentOperandTag extends ArgumentOperandTag,
  TPositionalArgumentOperand {
  int argIndex;

  PositionalArgumentOperandTag() {
    this = TPositionalArgumentOperand(argIndex)
  }

  override final string toString() {
    result = "Arg(" + argIndex + ")"
  }

  override final int getSortOrder() {
    result = 14 + argIndex
  }

  final int getArgIndex() {
    result = argIndex
  }
}

PositionalArgumentOperandTag positionalArgumentOperand(int argIndex) {
  result = TPositionalArgumentOperand(argIndex)
}

class ChiTotalOperandTag extends OperandTag, TChiTotalOperand {
  override final string toString() {
    result = "ChiTotal"
  }

  override final int getSortOrder() {
    result = 14
  }
}

ChiTotalOperandTag chiTotalOperand() {
  result = TChiTotalOperand()
}

class ChiPartialOperandTag extends OperandTag, TChiPartialOperand {
  override final string toString() {
    result = "ChiPartial"
  }

  override final int getSortOrder() {
    result = 15
  }
}

ChiPartialOperandTag chiPartialOperand() {
  result = TChiPartialOperand()
}

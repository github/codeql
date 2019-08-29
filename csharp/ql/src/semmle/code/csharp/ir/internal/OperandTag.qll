import csharp

private int getMaxCallArgIndex() {
  result = max(int argIndex |
    exists(Call call |
      exists(call.getArgument(argIndex))
    ) or
    // Quick fix so that generated calls (`Invoke` etc) will have the
    // correct number of parameters; it is an overestimation,
    // since we don't care about all the callables, so it
    // should be restricted more
    exists(Callable callable |
      callable.getNumberOfParameters() = argIndex
    )
  )
}

private newtype TOperandTag =
  TAddressOperand() or
  TBufferSizeOperand() or
  TSideEffectOperand() or
  TLoadOperand() or
  TStoreValueOperand() or
  TUnaryOperand() or
  TLeftOperand() or
  TRightOperand() or
  TConditionOperand() or
  TUnmodeledUseOperand() or
  TCallTargetOperand() or
  TThisArgumentOperand() or
  TPositionalArgumentOperand(int argIndex) {
    argIndex in [0..getMaxCallArgIndex()] 
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

/**
 * An operand that consumes a memory result (e.g. the `LoadOperand` on a `Load` instruction).
 */
abstract class MemoryOperandTag extends OperandTag {
}

/**
 * An operand that consumes a register (non-memory) result.
 */
abstract class RegisterOperandTag extends OperandTag {
}

/**
 * A memory operand whose type may be different from the result type of its definition instruction.
 */
abstract class TypedOperandTag extends MemoryOperandTag {
}

// Note: individual subtypes are listed in the order that the operands should
// appear in the operand list of the instruction when printing.

/**
 * The address operand of an instruction that loads or stores a value from
 * memory (e.g. `Load`, `Store`, `InitializeParameter`, `IndirectReadSideEffect`).
 */
class AddressOperandTag extends RegisterOperandTag, TAddressOperand {
  override final string toString() {
    result = "Address"
  }

  override final int getSortOrder() {
    result = 0
  }
  
  override final string getLabel() {
    result = "&:"
  }
}

AddressOperandTag addressOperand() {
  result = TAddressOperand()
}

/**
 * The buffer size operand of an instruction that represents a read or write of
 * a buffer.
 */
class BufferSizeOperand extends RegisterOperandTag, TBufferSizeOperand {
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
class SideEffectOperandTag extends TypedOperandTag, TSideEffectOperand {
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
 * The source value operand of an instruction that loads a value from memory (e.g. `Load`,
 * `ReturnValue`, `ThrowValue`).
 */
class LoadOperandTag extends TypedOperandTag, TLoadOperand {
  override final string toString() {
    result = "Load"
  }

  override final int getSortOrder() {
    result = 3
  }
}

LoadOperandTag loadOperand() {
  result = TLoadOperand()
}

/**
 * The source value operand of a `Store` instruction.
 */
class StoreValueOperandTag extends RegisterOperandTag, TStoreValueOperand {
  override final string toString() {
    result = "StoreValue"
  }

  override final int getSortOrder() {
    result = 4
  }
}

StoreValueOperandTag storeValueOperand() {
  result = TStoreValueOperand()
}

/**
 * The sole operand of a unary instruction (e.g. `Convert`, `Negate`, `Copy`).
 */
class UnaryOperandTag extends RegisterOperandTag, TUnaryOperand {
  override final string toString() {
    result = "Unary"
  }

  override final int getSortOrder() {
    result = 5
  }
}

UnaryOperandTag unaryOperand() {
  result = TUnaryOperand()
}

/**
 * The left operand of a binary instruction (e.g. `Add`, `CompareEQ`).
 */
class LeftOperandTag extends RegisterOperandTag, TLeftOperand {
  override final string toString() {
    result = "Left"
  }

  override final int getSortOrder() {
    result = 6
  }
}

LeftOperandTag leftOperand() {
  result = TLeftOperand()
}

/**
 * The right operand of a binary instruction (e.g. `Add`, `CompareEQ`).
 */
class RightOperandTag extends RegisterOperandTag, TRightOperand {
  override final string toString() {
    result = "Right"
  }

  override final int getSortOrder() {
    result = 7
  }
}

RightOperandTag rightOperand() {
  result = TRightOperand()
}

/**
 * The condition operand of a `ConditionalBranch` or `Switch` instruction.
 */
class ConditionOperandTag extends RegisterOperandTag, TConditionOperand {
  override final string toString() {
    result = "Condition"
  }

  override final int getSortOrder() {
    result = 8
  }
}

ConditionOperandTag conditionOperand() {
  result = TConditionOperand()
}

/**
 * An operand of the special `UnmodeledUse` instruction, representing a value
 * whose set of uses is unknown.
 */
class UnmodeledUseOperandTag extends MemoryOperandTag, TUnmodeledUseOperand {
  override final string toString() {
    result = "UnmodeledUse"
  }

  override final int getSortOrder() {
    result = 9
  }
}

UnmodeledUseOperandTag unmodeledUseOperand() {
  result = TUnmodeledUseOperand()
}

/**
 * The operand representing the target function of an `Call` instruction.
 */
class CallTargetOperandTag extends RegisterOperandTag, TCallTargetOperand {
  override final string toString() {
    result = "CallTarget"
  }

  override final int getSortOrder() {
    result = 10
  }

  override final string getLabel() {
    result = "func:"
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
abstract class ArgumentOperandTag extends RegisterOperandTag {
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
    result = 11
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
    result = 12 + argIndex
  }

  override final string getLabel() {
    result = argIndex.toString() + ":"
  }
  
  final int getArgIndex() {
    result = argIndex
  }
}

PositionalArgumentOperandTag positionalArgumentOperand(int argIndex) {
  result = TPositionalArgumentOperand(argIndex)
}

class ChiTotalOperandTag extends MemoryOperandTag, TChiTotalOperand {
  override final string toString() {
    result = "ChiTotal"
  }

  override final int getSortOrder() {
    result = 13
  }

  override final string getLabel() {
    result = "total:"
  }
}

ChiTotalOperandTag chiTotalOperand() {
  result = TChiTotalOperand()
}

class ChiPartialOperandTag extends MemoryOperandTag, TChiPartialOperand {
  override final string toString() {
    result = "ChiPartial"
  }

  override final int getSortOrder() {
    result = 14
  }

  override final string getLabel() {
    result = "partial:"
  }
}

ChiPartialOperandTag chiPartialOperand() {
  result = TChiPartialOperand()
}

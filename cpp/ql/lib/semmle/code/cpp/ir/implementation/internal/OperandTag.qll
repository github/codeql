/**
 * Defines the set of possible `OperandTag`s, which are used to identify the role each `Operand`
 * plays in the evaluation of its `Instruction`.
 */

private import OperandTagInternal

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
  TCallTargetOperand() or
  TThisArgumentOperand() or
  TPositionalArgumentOperand(int argIndex) { Language::hasPositionalArgIndex(argIndex) } or
  TChiTotalOperand() or
  TChiPartialOperand() or
  TAsmOperand(int index) { Language::hasAsmOperandIndex(index) }

/**
 * Identifies the kind of operand on an instruction. Each `Instruction` has at
 * most one operand of any single `OperandTag`. The set of `OperandTag`s used by
 * an `Instruction` is determined by the instruction's opcode.
 */
abstract class OperandTag extends TOperandTag {
  /** Gets a textual representation of this operand tag */
  abstract string toString();

  /**
   * Gets an integer that represents where this this operand will appear in the operand list of an
   * instruction when the IR is printed.
   */
  abstract int getSortOrder();

  /**
   * Gets a label that will appear before the operand when the IR is printed.
   */
  final string getLabel() {
    if this.alwaysPrintLabel() then result = this.getId() + ":" else result = ""
  }

  /**
   * Gets an identifier that uniquely identifies this operand within its instruction.
   */
  abstract string getId();

  /**
   * Holds if the operand should always be prefixed with its label in the dump of its instruction.
   */
  predicate alwaysPrintLabel() { none() }
}

/**
 * An operand that consumes a memory result (e.g. the `LoadOperand` on a `Load` instruction).
 */
abstract class MemoryOperandTag extends OperandTag { }

/**
 * An operand that consumes a register (non-memory) result.
 */
abstract class RegisterOperandTag extends OperandTag { }

/**
 * A memory operand whose type may be different from the result type of its definition instruction.
 */
abstract class TypedOperandTag extends MemoryOperandTag { }

// Note: individual subtypes are listed in the order that the operands should
// appear in the operand list of the instruction when the IR is printed.
/**
 * The address operand of an instruction that loads or stores a value from
 * memory (e.g. `Load`, `Store`, `InitializeParameter`, `IndirectReadSideEffect`).
 */
class AddressOperandTag extends RegisterOperandTag, TAddressOperand {
  final override string toString() { result = "Address" }

  final override int getSortOrder() { result = 0 }

  final override predicate alwaysPrintLabel() { any() }

  final override string getId() { result = "&" }
}

AddressOperandTag addressOperand() { result = TAddressOperand() }

/**
 * The buffer size operand of an instruction that represents a read or write of
 * a buffer.
 */
class BufferSizeOperandTag extends RegisterOperandTag, TBufferSizeOperand {
  final override string toString() { result = "BufferSize" }

  final override int getSortOrder() { result = 1 }

  final override string getId() { result = "size" }
}

BufferSizeOperandTag bufferSizeOperand() { result = TBufferSizeOperand() }

/**
 * The operand representing the read side effect of a `SideEffectInstruction`.
 */
class SideEffectOperandTag extends TypedOperandTag, TSideEffectOperand {
  final override string toString() { result = "SideEffect" }

  final override int getSortOrder() { result = 2 }

  final override string getId() { result = "side_effect" }
}

SideEffectOperandTag sideEffectOperand() { result = TSideEffectOperand() }

/**
 * The source value operand of an instruction that loads a value from memory (e.g. `Load`,
 * `ReturnValue`, `ThrowValue`).
 */
class LoadOperandTag extends TypedOperandTag, TLoadOperand {
  final override string toString() { result = "Load" }

  final override int getSortOrder() { result = 3 }

  final override string getId() { result = "load" }
}

LoadOperandTag loadOperand() { result = TLoadOperand() }

/**
 * The source value operand of a `Store` instruction.
 */
class StoreValueOperandTag extends RegisterOperandTag, TStoreValueOperand {
  final override string toString() { result = "StoreValue" }

  final override int getSortOrder() { result = 4 }

  final override string getId() { result = "store" }
}

StoreValueOperandTag storeValueOperand() { result = TStoreValueOperand() }

/**
 * The sole operand of a unary instruction (e.g. `Convert`, `Negate`, `Copy`).
 */
class UnaryOperandTag extends RegisterOperandTag, TUnaryOperand {
  final override string toString() { result = "Unary" }

  final override int getSortOrder() { result = 5 }

  final override string getId() { result = "unary" }
}

UnaryOperandTag unaryOperand() { result = TUnaryOperand() }

/**
 * The left operand of a binary instruction (e.g. `Add`, `CompareEQ`).
 */
class LeftOperandTag extends RegisterOperandTag, TLeftOperand {
  final override string toString() { result = "Left" }

  final override int getSortOrder() { result = 6 }

  final override string getId() { result = "left" }
}

LeftOperandTag leftOperand() { result = TLeftOperand() }

/**
 * The right operand of a binary instruction (e.g. `Add`, `CompareEQ`).
 */
class RightOperandTag extends RegisterOperandTag, TRightOperand {
  final override string toString() { result = "Right" }

  final override int getSortOrder() { result = 7 }

  final override string getId() { result = "right" }
}

RightOperandTag rightOperand() { result = TRightOperand() }

/**
 * The condition operand of a `ConditionalBranch` or `Switch` instruction.
 */
class ConditionOperandTag extends RegisterOperandTag, TConditionOperand {
  final override string toString() { result = "Condition" }

  final override int getSortOrder() { result = 8 }

  final override string getId() { result = "cond" }
}

ConditionOperandTag conditionOperand() { result = TConditionOperand() }

/**
 * The operand representing the target function of an `Call` instruction.
 */
class CallTargetOperandTag extends RegisterOperandTag, TCallTargetOperand {
  final override string toString() { result = "CallTarget" }

  final override int getSortOrder() { result = 10 }

  final override predicate alwaysPrintLabel() { any() }

  final override string getId() { result = "func" }
}

CallTargetOperandTag callTargetOperand() { result = TCallTargetOperand() }

/**
 * An operand representing an argument to a function call. This includes both
 * positional arguments (represented by `PositionalArgumentOperand`) and the
 * implicit `this` argument, if any (represented by `ThisArgumentOperand`).
 */
abstract class ArgumentOperandTag extends RegisterOperandTag { }

/**
 * An operand representing the implicit 'this' argument to a member function
 * call.
 */
class ThisArgumentOperandTag extends ArgumentOperandTag, TThisArgumentOperand {
  ThisArgumentOperandTag() { this = TThisArgumentOperand() }

  final override string toString() { result = "Arg(this)" }

  final override int getSortOrder() { result = 11 }

  final override predicate alwaysPrintLabel() { any() }

  final override string getId() { result = "this" }
}

ThisArgumentOperandTag thisArgumentOperand() { result = TThisArgumentOperand() }

/**
 * An operand representing an argument to a function call.
 */
class PositionalArgumentOperandTag extends ArgumentOperandTag, TPositionalArgumentOperand {
  int argIndex;

  PositionalArgumentOperandTag() { this = TPositionalArgumentOperand(argIndex) }

  final override string toString() { result = "Arg(" + argIndex + ")" }

  final override int getSortOrder() { result = 12 + argIndex }

  final override predicate alwaysPrintLabel() { any() }

  final int getArgIndex() { result = argIndex }

  final override string getId() { result = argIndex.toString() }
}

PositionalArgumentOperandTag positionalArgumentOperand(int argIndex) {
  result = TPositionalArgumentOperand(argIndex)
}

abstract class ChiOperandTag extends MemoryOperandTag { }

class ChiTotalOperandTag extends ChiOperandTag, TChiTotalOperand {
  final override string toString() { result = "ChiTotal" }

  final override int getSortOrder() { result = 13 }

  final override predicate alwaysPrintLabel() { any() }

  final override string getId() { result = "total" }
}

ChiTotalOperandTag chiTotalOperand() { result = TChiTotalOperand() }

class ChiPartialOperandTag extends ChiOperandTag, TChiPartialOperand {
  final override string toString() { result = "ChiPartial" }

  final override int getSortOrder() { result = 14 }

  final override predicate alwaysPrintLabel() { any() }

  final override string getId() { result = "partial" }
}

ChiPartialOperandTag chiPartialOperand() { result = TChiPartialOperand() }

class AsmOperandTag extends RegisterOperandTag, TAsmOperand {
  int index;

  AsmOperandTag() { this = TAsmOperand(index) }

  final override string toString() { result = "AsmOperand(" + index + ")" }

  final override int getSortOrder() { result = 15 + index }

  final override predicate alwaysPrintLabel() { any() }

  final override string getId() { result = index.toString() }
}

AsmOperandTag asmOperand(int index) { result = TAsmOperand(index) }

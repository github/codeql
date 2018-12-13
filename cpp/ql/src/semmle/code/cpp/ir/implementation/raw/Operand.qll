private import internal.IRInternal
import Instruction
import IRBlock
import cpp
import semmle.code.cpp.ir.implementation.MemoryAccessKind
private import semmle.code.cpp.ir.internal.OperandTag

private newtype TOperand =
  TNonPhiOperand(Instruction instr, OperandTag tag, Instruction defInstr) {
    defInstr = Construction::getInstructionOperandDefinition(instr, tag)
  } or
  TPhiOperand(PhiInstruction instr, Instruction defInstr, IRBlock predecessorBlock) {
    defInstr = Construction::getPhiInstructionOperandDefinition(instr, predecessorBlock)
  }

/**
 * A source operand of an `Instruction`. The operand represents a value consumed by the instruction.
 */
class Operand extends TOperand {
  string toString() {
    result = "Operand"
  }

  /**
   * Gets the `Instruction` that consumes this operand.
   */
  Instruction getInstruction() {
    none()
  }

  /**
   * Gets the `Instruction` whose result is the value of the operand.
   */
  Instruction getDefinitionInstruction() {
    none()
  }

  /**
   * Gets a prefix to use when dumping the operand in an operand list.
   */
  string getDumpLabel() {
    result = ""
  }

  /**
   * Gets a string describing this operand, suitable for display in IR dumps. This consists of the
   * result ID of the instruction consumed by the operand, plus a label identifying the operand
   * kind.
   *
   * For example: `this:r3_5`
   */
  final string getDumpString() {
    result = getDumpLabel() + getDefinitionInstruction().getResultId()
  }

  /**
   * Get the order in which the operand should be sorted in the operand list.
   */
  int getDumpSortOrder() {
    result = -1
  }

  /**
   * Gets the kind of memory access performed by the operand. Holds only for memory operands.
   */
  MemoryAccessKind getMemoryAccess() {
    none()
  }

  /**
   * Returns the operand that holds the memory address from which the current operand loads its
   * value, if any. For example, in `r3 = Load r1, m2`, the result of `getAddressOperand()` for `m2`
   * is `r1`.
   */
  final AddressOperand getAddressOperand() {
    getMemoryAccess() instanceof IndirectMemoryAccess and
    result.getInstruction() = getInstruction()
  }
}

/**
 * An operand that is not an operand of a `PhiInstruction`.
 */
class NonPhiOperand extends Operand, TNonPhiOperand {
  Instruction instr;
  Instruction defInstr;
  OperandTag tag;

  NonPhiOperand() {
    this = TNonPhiOperand(instr, tag, defInstr)
  }

  override final Instruction getInstruction() {
    result = instr
  }

  override final Instruction getDefinitionInstruction() {
    result = defInstr
  }

  override final string getDumpLabel() {
    result = tag.getLabel()
  }

  override final int getDumpSortOrder() {
    result = tag.getSortOrder()
  }

  final OperandTag getOperandTag() {
    result = tag
  }
}

/**
 * The address operand of an instruction that loads or stores a value from
 * memory (e.g. `Load`, `Store`).
 */
class AddressOperand extends NonPhiOperand {
  AddressOperand() {
    this = TNonPhiOperand(_, addressOperand(), _)
  }

  override string toString() {
    result = "Address"
  }
}

/**
 * The source value operand of an instruction that copies this value to its
 * result (e.g. `Copy`, `Load`, `Store`).
 */
class CopySourceOperand extends NonPhiOperand {
  CopySourceOperand() {
    this = TNonPhiOperand(_, copySourceOperand(), _)
  }

  override string toString() {
    result = "CopySource"
  }

  override final MemoryAccessKind getMemoryAccess() {
    instr.getOpcode() instanceof Opcode::Load and
    result instanceof IndirectMemoryAccess
  }
}

/**
 * The sole operand of a unary instruction (e.g. `Convert`, `Negate`).
 */
class UnaryOperand extends NonPhiOperand {
  UnaryOperand() {
    this = TNonPhiOperand(_, unaryOperand(), _)
  }

  override string toString() {
    result = "Unary"
  }
}

/**
 * The left operand of a binary instruction (e.g. `Add`, `CompareEQ`).
 */
class LeftOperand extends NonPhiOperand {
  LeftOperand() {
    this = TNonPhiOperand(_, leftOperand(), _)
  }

  override string toString() {
    result = "Left"
  }
}

/**
 * The right operand of a binary instruction (e.g. `Add`, `CompareEQ`).
 */
class RightOperand extends NonPhiOperand {
  RightOperand() {
    this = TNonPhiOperand(_, rightOperand(), _)
  }

  override string toString() {
    result = "Right"
  }
}

/**
 * The return value operand of a `ReturnValue` instruction.
 */
class ReturnValueOperand extends NonPhiOperand {
  ReturnValueOperand() {
    this = TNonPhiOperand(_, returnValueOperand(), _)
  }

  override string toString() {
    result = "ReturnValue"
  }

  override final MemoryAccessKind getMemoryAccess() {
    result instanceof IndirectMemoryAccess
  }
}

/**
 * The exception thrown by a `ThrowValue` instruction.
 */
class ExceptionOperand extends NonPhiOperand {
  ExceptionOperand() {
    this = TNonPhiOperand(_, exceptionOperand(), _)
  }

  override string toString() {
    result = "Exception"
  }

  override final MemoryAccessKind getMemoryAccess() {
    result instanceof IndirectMemoryAccess
  }
}

/**
 * The condition operand of a `ConditionalBranch` or `Switch` instruction.
 */
class ConditionOperand extends NonPhiOperand {
  ConditionOperand() {
    this = TNonPhiOperand(_, conditionOperand(), _)
  }

  override string toString() {
    result = "Condition"
  }
}

/**
 * An operand of the special `UnmodeledUse` instruction, representing a value
 * whose set of uses is unknown.
 */
class UnmodeledUseOperand extends NonPhiOperand {
  UnmodeledUseOperand() {
    this = TNonPhiOperand(_, unmodeledUseOperand(), _)
  }

  override string toString() {
    result = "UnmodeledUse"
  }

  override final MemoryAccessKind getMemoryAccess() {
    result instanceof UnmodeledMemoryAccess
  }
}

/**
 * The operand representing the target function of an `Call` instruction.
 */
class CallTargetOperand extends NonPhiOperand {
  CallTargetOperand() {
    this = TNonPhiOperand(_, callTargetOperand(), _)
  }

  override string toString() {
    result = "CallTarget"
  }
}

/**
 * An operand representing an argument to a function call. This includes both
 * positional arguments (represented by `PositionalArgumentOperand`) and the
 * implicit `this` argument, if any (represented by `ThisArgumentOperand`).
 */
class ArgumentOperand extends NonPhiOperand {
  ArgumentOperand() {
    exists(ArgumentOperandTag argTag |
      this = TNonPhiOperand(_, argTag, _)
    )
  }
}

/**
 * An operand representing the implicit 'this' argument to a member function
 * call.
 */
class ThisArgumentOperand extends ArgumentOperand {
  ThisArgumentOperand() {
    this = TNonPhiOperand(_, thisArgumentOperand(), _)
  }

  override string toString() {
    result = "ThisArgument"
  }
}

/**
 * An operand representing an argument to a function call.
 */
class PositionalArgumentOperand extends ArgumentOperand {
  int argIndex;

  PositionalArgumentOperand() {
    exists(PositionalArgumentOperandTag argTag |
      this = TNonPhiOperand(_, argTag, _) and
      argIndex = argTag.getArgIndex()
    )
  }

  override string toString() {
    result = "Arg(" + argIndex + ")"
  }

  /**
   * Gets the zero-based index of the argument.
   */
  final int getIndex() {
    result = argIndex
  }
}

class SideEffectOperand extends NonPhiOperand {
  SideEffectOperand() {
    this = TNonPhiOperand(_, sideEffectOperand(), _)
  }
  
  override MemoryAccessKind getMemoryAccess() {
    instr instanceof CallSideEffectInstruction and
    result instanceof EscapedMemoryAccess
    or
    instr instanceof CallReadSideEffectInstruction and
    result instanceof EscapedMemoryAccess
    or
    instr instanceof IndirectReadSideEffectInstruction and
    result instanceof IndirectMemoryAccess
    or
    instr instanceof BufferReadSideEffectInstruction and
    result instanceof BufferMemoryAccess
    or
    instr instanceof IndirectWriteSideEffectInstruction and
    result instanceof IndirectMemoryAccess
    or
    instr instanceof BufferWriteSideEffectInstruction and
    result instanceof BufferMemoryAccess
    or
    instr instanceof IndirectMayWriteSideEffectInstruction and
    result instanceof IndirectMayMemoryAccess
    or
    instr instanceof BufferMayWriteSideEffectInstruction and
    result instanceof BufferMayMemoryAccess
  }
}

/**
 * An operand of a `PhiInstruction`.
 */
class PhiOperand extends Operand, TPhiOperand {
  PhiInstruction instr;
  Instruction defInstr;
  IRBlock predecessorBlock;

  PhiOperand() {
    this = TPhiOperand(instr, defInstr, predecessorBlock)
  }

  override string toString() {
    result = "Phi"
  }

  override final PhiInstruction getInstruction() {
    result = instr
  }

  override final Instruction getDefinitionInstruction() {
    result = defInstr
  }

  override final int getDumpSortOrder() {
    result = 11 + getPredecessorBlock().getDisplayIndex()
  }

  override final string getDumpLabel() {
    result = "from " + getPredecessorBlock().getDisplayIndex().toString() + ":"
  }

  /**
   * Gets the predecessor block from which this value comes.
   */
  final IRBlock getPredecessorBlock() {
    result = predecessorBlock
  }

  override final MemoryAccessKind getMemoryAccess() {
    result instanceof PhiMemoryAccess
  }
}

/**
 * An operand that reads a value from memory.
 */
class MemoryOperand extends Operand {
  MemoryOperand() {
    exists(getMemoryAccess())
  }
}

/**
 * The total operand of a Chi node, representing the previous value of the memory.
 */
class ChiTotalOperand extends Operand {
  ChiTotalOperand() {
    this = TNonPhiOperand(_, chiTotalOperand(), _)
  }

  override string toString() {
    result = "ChiTotal"
  }

  override final MemoryAccessKind getMemoryAccess() {
    result instanceof ChiTotalMemoryAccess
  }
}


/**
 * The partial operand of a Chi node, representing the value being written to part of the memory.
 */
class ChiPartialOperand extends Operand {
  ChiPartialOperand() {
    this = TNonPhiOperand(_, chiPartialOperand(), _)
  }

  override string toString() {
    result = "ChiPartial"
  }

  override final MemoryAccessKind getMemoryAccess() {
    result instanceof ChiPartialMemoryAccess
  }
}

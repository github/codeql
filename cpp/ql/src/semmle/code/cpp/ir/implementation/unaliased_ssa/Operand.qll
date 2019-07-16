private import internal.IRInternal
import Instruction
import IRBlock
private import cpp
import semmle.code.cpp.ir.implementation.MemoryAccessKind
import semmle.code.cpp.ir.internal.Overlap
private import semmle.code.cpp.ir.internal.OperandTag

cached
private newtype TOperand =
  TRegisterOperand(Instruction useInstr, RegisterOperandTag tag, Instruction defInstr) {
    defInstr = Construction::getRegisterOperandDefinition(useInstr, tag) and
    not isInCycle(useInstr)
  } or
  TNonPhiMemoryOperand(Instruction useInstr, MemoryOperandTag tag, Instruction defInstr, Overlap overlap) {
    defInstr = Construction::getMemoryOperandDefinition(useInstr, tag, overlap) and
    not isInCycle(useInstr)
  } or
  TPhiOperand(PhiInstruction useInstr, Instruction defInstr, IRBlock predecessorBlock, Overlap overlap) {
    defInstr = Construction::getPhiOperandDefinition(useInstr, predecessorBlock, overlap)
  }

/** Gets a non-phi instruction that defines an operand of `instr`. */
private Instruction getNonPhiOperandDef(Instruction instr) {
  result = Construction::getRegisterOperandDefinition(instr, _)
  or
  result = Construction::getMemoryOperandDefinition(instr, _, _)
}

/**
 * Holds if `instr` is part of a cycle in the operand graph that doesn't go
 * through a phi instruction and therefore should be impossible.
 *
 * If such cycles are present, either due to a programming error in the IR
 * generation or due to a malformed database, it can cause infinite loops in
 * analyses that assume a cycle-free graph of non-phi operands. Therefore it's
 * better to remove these operands than to leave cycles in the operand graph.
 */
pragma[noopt]
private predicate isInCycle(Instruction instr) {
  instr instanceof Instruction and
  getNonPhiOperandDef+(instr) = instr
}

/**
 * A source operand of an `Instruction`. The operand represents a value consumed by the instruction.
 */
class Operand extends TOperand {
  string toString() {
    result = "Operand"
  }

  final Location getLocation() {
    result = getUse().getLocation()
  }

  final IRFunction getEnclosingIRFunction() {
    result = getUse().getEnclosingIRFunction()
  }

  /**
   * Gets the `Instruction` that consumes this operand.
   */
  Instruction getUse() {
    none()
  }

  /**
   * Gets the `Instruction` whose result is the value of the operand. Unlike
   * `getDef`, this also has a result when `isDefinitionInexact` holds, which
   * means that the resulting instruction may only _partially_ or _potentially_
   * be the value of this operand.
   */
  Instruction getAnyDef() {
    none()
  }

  /**
   * Gets the `Instruction` whose result is the value of the operand. Unlike
   * `getAnyDef`, this also has no result when `isDefinitionInexact` holds,
   * which means that the resulting instruction must always be exactly the be
   * the value of this operand.
   */
  final Instruction getDef() {
    result = this.getAnyDef() and
    getDefinitionOverlap() instanceof MustExactlyOverlap
  }

  /**
   * DEPRECATED: renamed to `getUse`.
   *
   * Gets the `Instruction` that consumes this operand.
   */
  deprecated
  final Instruction getUseInstruction() {
    result = getUse()
  }

  /**
   * DEPRECATED: use `getAnyDef` or `getDef`. The exact replacement for this
   * predicate is `getAnyDef`, but most uses of this predicate should probably
   * be replaced with `getDef`.
   *
   * Gets the `Instruction` whose result is the value of the operand.
   */
  deprecated
  final Instruction getDefinitionInstruction() {
    result = getAnyDef()
  }

  /**
   * Gets the overlap relationship between the operand's definition and its use.
   */
  Overlap getDefinitionOverlap() {
    none()
  }

  /**
   * Holds if the result of the definition instruction does not exactly overlap this use.
   */
  final predicate isDefinitionInexact() {
    not getDefinitionOverlap() instanceof MustExactlyOverlap
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
    result = getDumpLabel() + getInexactSpecifier() + getAnyDef().getResultId()
  }

  /**
   * Gets a string prefix to prepend to the operand's definition ID in an IR dump, specifying whether the operand is
   * an exact or inexact use of its definition. For an inexact use, the prefix is "~". For an exact use, the prefix is
   * the empty string.
   */
  private string getInexactSpecifier() {
    if isDefinitionInexact() then
      result = "~"
    else
      result = ""
  }

  /**
   * Get the order in which the operand should be sorted in the operand list.
   */
  int getDumpSortOrder() {
    result = -1
  }

  /**
   * Gets the type of the value consumed by this operand. This is usually the same as the
   * result type of the definition instruction consumed by this operand. For register operands,
   * this is always the case. For some memory operands, the operand type may be different from
   * the definition type, such as in the case of a partial read or a read from a pointer that
   * has been cast to a different type.
   */
  Type getType() {
    result = getAnyDef().getResultType()
  }

  /**
   * Holds if the value consumed by this operand is a glvalue. If this
   * holds, the value of the operand represents the address of a location,
   * and the type of the location is given by `getType()`. If this does
   * not hold, the value of the operand represents a value whose type is
   * given by `getResultType()`.
   */
  predicate isGLValue() {
    getAnyDef().isGLValue()
  }

  /**
   * Gets the size of the value consumed by this operand, in bytes. If the operand does not have
   * a known constant size, this predicate does not hold.
   */
  int getSize() {
    result = getType().getSize()
  }
}

/**
 * An operand that consumes a memory result (e.g. the `LoadOperand` on a `Load` instruction).
 */
class MemoryOperand extends Operand {
  MemoryOperand() {
    this = TNonPhiMemoryOperand(_, _, _, _) or
    this = TPhiOperand(_, _, _, _)
  }

  override predicate isGLValue() {
    // A `MemoryOperand` can never be a glvalue
    none()
  }

  /**
   * Gets the kind of memory access performed by the operand.
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
    getMemoryAccess().usesAddressOperand() and
    result.getUse() = getUse()
  }
}

/**
 * An operand that is not an operand of a `PhiInstruction`.
 */
class NonPhiOperand extends Operand {
  Instruction useInstr;
  Instruction defInstr;
  OperandTag tag;

  NonPhiOperand() {
    this = TRegisterOperand(useInstr, tag, defInstr) or
    this = TNonPhiMemoryOperand(useInstr, tag, defInstr, _)
  }

  override final Instruction getUse() {
    result = useInstr
  }

  override final Instruction getAnyDef() {
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
 * An operand that consumes a register (non-memory) result.
 */
class RegisterOperand extends NonPhiOperand, TRegisterOperand {
  override RegisterOperandTag tag;

  override final Overlap getDefinitionOverlap() {
    // All register results overlap exactly with their uses.
    result instanceof MustExactlyOverlap
  }
}

class NonPhiMemoryOperand extends NonPhiOperand, MemoryOperand, TNonPhiMemoryOperand {
  override MemoryOperandTag tag;
  Overlap overlap;

  NonPhiMemoryOperand() {
    this = TNonPhiMemoryOperand(useInstr, tag, defInstr, overlap)
  }

  override final Overlap getDefinitionOverlap() {
    result = overlap
  }
}

class TypedOperand extends NonPhiMemoryOperand {
  override TypedOperandTag tag;

  override final Type getType() {
    result = Construction::getInstructionOperandType(useInstr, tag)
  }
}

/**
 * The address operand of an instruction that loads or stores a value from
 * memory (e.g. `Load`, `Store`).
 */
class AddressOperand extends RegisterOperand {
  override AddressOperandTag tag;

  override string toString() {
    result = "Address"
  }
}

/**
 * The source value operand of an instruction that loads a value from memory (e.g. `Load`,
 * `ReturnValue`, `ThrowValue`).
 */
class LoadOperand extends TypedOperand {
  override LoadOperandTag tag;

  override string toString() {
    result = "Load"
  }

  override final MemoryAccessKind getMemoryAccess() {
    result instanceof IndirectMemoryAccess
  }
}

/**
 * The source value operand of a `Store` instruction.
 */
class StoreValueOperand extends RegisterOperand {
  override StoreValueOperandTag tag;

  override string toString() {
    result = "StoreValue"
  }
}

/**
 * The sole operand of a unary instruction (e.g. `Convert`, `Negate`, `Copy`).
 */
class UnaryOperand extends RegisterOperand {
  override UnaryOperandTag tag;

  override string toString() {
    result = "Unary"
  }
}

/**
 * The left operand of a binary instruction (e.g. `Add`, `CompareEQ`).
 */
class LeftOperand extends RegisterOperand {
  override LeftOperandTag tag;

  override string toString() {
    result = "Left"
  }
}

/**
 * The right operand of a binary instruction (e.g. `Add`, `CompareEQ`).
 */
class RightOperand extends RegisterOperand {
  override RightOperandTag tag;

  override string toString() {
    result = "Right"
  }
}

/**
 * The condition operand of a `ConditionalBranch` or `Switch` instruction.
 */
class ConditionOperand extends RegisterOperand {
  override ConditionOperandTag tag;

  override string toString() {
    result = "Condition"
  }
}

/**
 * An operand of the special `UnmodeledUse` instruction, representing a value
 * whose set of uses is unknown.
 */
class UnmodeledUseOperand extends NonPhiMemoryOperand {
  override UnmodeledUseOperandTag tag;

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
class CallTargetOperand extends RegisterOperand {
  override CallTargetOperandTag tag;

  override string toString() {
    result = "CallTarget"
  }
}

/**
 * An operand representing an argument to a function call. This includes both
 * positional arguments (represented by `PositionalArgumentOperand`) and the
 * implicit `this` argument, if any (represented by `ThisArgumentOperand`).
 */
class ArgumentOperand extends RegisterOperand {
  override ArgumentOperandTag tag;
}

/**
 * An operand representing the implicit 'this' argument to a member function
 * call.
 */
class ThisArgumentOperand extends ArgumentOperand {
  override ThisArgumentOperandTag tag;

  override string toString() {
    result = "ThisArgument"
  }
}

/**
 * An operand representing an argument to a function call.
 */
class PositionalArgumentOperand extends ArgumentOperand {
  override PositionalArgumentOperandTag tag;
  int argIndex;

  PositionalArgumentOperand() {
    argIndex = tag.getArgIndex()
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

class SideEffectOperand extends TypedOperand {
  override SideEffectOperandTag tag;

  override final int getSize() {
    if getType() instanceof UnknownType then
      result = Construction::getInstructionOperandSize(useInstr, tag)
    else
      result = getType().getSize()
  }

  override MemoryAccessKind getMemoryAccess() {
    useInstr instanceof CallSideEffectInstruction and
    result instanceof EscapedMayMemoryAccess
    or
    useInstr instanceof CallReadSideEffectInstruction and
    result instanceof EscapedMayMemoryAccess
    or
    useInstr instanceof IndirectReadSideEffectInstruction and
    result instanceof IndirectMemoryAccess
    or
    useInstr instanceof BufferReadSideEffectInstruction and
    result instanceof BufferMemoryAccess
    or
    useInstr instanceof IndirectWriteSideEffectInstruction and
    result instanceof IndirectMemoryAccess
    or
    useInstr instanceof BufferWriteSideEffectInstruction and
    result instanceof BufferMemoryAccess
    or
    useInstr instanceof IndirectMayWriteSideEffectInstruction and
    result instanceof IndirectMayMemoryAccess
    or
    useInstr instanceof BufferMayWriteSideEffectInstruction and
    result instanceof BufferMayMemoryAccess
  }
}

/**
 * An operand of a `PhiInstruction`.
 */
class PhiInputOperand extends MemoryOperand, TPhiOperand {
  PhiInstruction useInstr;
  Instruction defInstr;
  IRBlock predecessorBlock;
  Overlap overlap;

  PhiInputOperand() {
    this = TPhiOperand(useInstr, defInstr, predecessorBlock, overlap)
  }

  override string toString() {
    result = "Phi"
  }

  override final PhiInstruction getUse() {
    result = useInstr
  }

  override final Instruction getAnyDef() {
    result = defInstr
  }

  override final Overlap getDefinitionOverlap() {
    result = overlap
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
 * The total operand of a Chi node, representing the previous value of the memory.
 */
class ChiTotalOperand extends NonPhiMemoryOperand {
  override ChiTotalOperandTag tag;

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
class ChiPartialOperand extends NonPhiMemoryOperand {
  override ChiPartialOperandTag tag;

  override string toString() {
    result = "ChiPartial"
  }

  override final MemoryAccessKind getMemoryAccess() {
    result instanceof ChiPartialMemoryAccess
  }
}

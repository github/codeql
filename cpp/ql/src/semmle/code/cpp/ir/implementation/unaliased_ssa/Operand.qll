/**
 * Provides classes that represent the input values of IR instructions.
 */

private import internal.IRInternal
private import Instruction
private import IRBlock
private import internal.OperandImports as Imports
private import Imports::MemoryAccessKind
private import Imports::IRType
private import Imports::Overlap
private import Imports::OperandTag

cached
private newtype TOperand =
  TRegisterOperand(Instruction useInstr, RegisterOperandTag tag, Instruction defInstr) {
    defInstr = Construction::getRegisterOperandDefinition(useInstr, tag) and
    not Construction::isInCycle(useInstr) and
    strictcount(Construction::getRegisterOperandDefinition(useInstr, tag)) = 1
  } or
  TNonPhiMemoryOperand(Instruction useInstr, MemoryOperandTag tag) {
    useInstr.getOpcode().hasOperand(tag)
  } or
  TPhiOperand(
    PhiInstruction useInstr, Instruction defInstr, IRBlock predecessorBlock, Overlap overlap
  ) {
    defInstr = Construction::getPhiOperandDefinition(useInstr, predecessorBlock, overlap)
  }

/**
 * Base class for all register operands. This is a placeholder for the IPA union type that we will
 * eventually use for this purpose.
 */
private class RegisterOperandBase extends TRegisterOperand {
  /** Gets a textual representation of this element. */
  abstract string toString();
}

/**
 * Returns the register operand with the specified parameters.
 */
private RegisterOperandBase registerOperand(
  Instruction useInstr, RegisterOperandTag tag, Instruction defInstr
) {
  result = TRegisterOperand(useInstr, tag, defInstr)
}

/**
 * Base class for all non-Phi memory operands. This is a placeholder for the IPA union type that we
 * will eventually use for this purpose.
 */
private class NonPhiMemoryOperandBase extends TNonPhiMemoryOperand {
  /** Gets a textual representation of this element. */
  abstract string toString();
}

/**
 * Returns the non-Phi memory operand with the specified parameters.
 */
private NonPhiMemoryOperandBase nonPhiMemoryOperand(Instruction useInstr, MemoryOperandTag tag) {
  result = TNonPhiMemoryOperand(useInstr, tag)
}

/**
 * Base class for all Phi operands. This is a placeholder for the IPA union type that we will
 * eventually use for this purpose.
 */
private class PhiOperandBase extends TPhiOperand {
  abstract string toString();
}

/**
 * Returns the Phi operand with the specified parameters.
 */
private PhiOperandBase phiOperand(
  Instruction useInstr, Instruction defInstr, IRBlock predecessorBlock, Overlap overlap
) {
  result = TPhiOperand(useInstr, defInstr, predecessorBlock, overlap)
}

/**
 * An operand of an `Instruction`. The operand represents a use of the result of one instruction
 * (the defining instruction) in another instruction (the use instruction)
 */
class Operand extends TOperand {
  /** Gets a textual representation of this element. */
  string toString() { result = "Operand" }

  /**
   * Gets the location of the source code for this operand.
   */
  final Language::Location getLocation() { result = getUse().getLocation() }

  /**
   * Gets the function that contains this operand.
   */
  final IRFunction getEnclosingIRFunction() { result = getUse().getEnclosingIRFunction() }

  /**
   * Gets the `Instruction` that consumes this operand.
   */
  Instruction getUse() { none() }

  /**
   * Gets the `Instruction` whose result is the value of the operand. Unlike
   * `getDef`, this also has a result when `isDefinitionInexact` holds, which
   * means that the resulting instruction may only _partially_ or _potentially_
   * be the value of this operand.
   */
  Instruction getAnyDef() { none() }

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
  deprecated final Instruction getUseInstruction() { result = getUse() }

  /**
   * DEPRECATED: use `getAnyDef` or `getDef`. The exact replacement for this
   * predicate is `getAnyDef`, but most uses of this predicate should probably
   * be replaced with `getDef`.
   *
   * Gets the `Instruction` whose result is the value of the operand.
   */
  deprecated final Instruction getDefinitionInstruction() { result = getAnyDef() }

  /**
   * Gets the overlap relationship between the operand's definition and its use.
   */
  Overlap getDefinitionOverlap() { none() }

  /**
   * Holds if the result of the definition instruction does not exactly overlap this use.
   */
  final predicate isDefinitionInexact() { not getDefinitionOverlap() instanceof MustExactlyOverlap }

  /**
   * Gets a prefix to use when dumping the operand in an operand list.
   */
  string getDumpLabel() { result = "" }

  /**
   * Gets a string that uniquely identifies this operand on its use instruction.
   */
  string getDumpId() { result = "" }

  /**
   * Gets a string describing this operand, suitable for display in IR dumps. This consists of the
   * result ID of the instruction consumed by the operand, plus a label identifying the operand
   * kind.
   *
   * For example: `this:r3_5`
   */
  final string getDumpString() {
    result = getDumpLabel() + getInexactSpecifier() + getDefinitionId()
  }

  /**
   * Gets a string containing the identifier of the definition of this use, or `m?` if the
   * definition is not modeled in SSA.
   */
  private string getDefinitionId() {
    result = getAnyDef().getResultId()
    or
    not exists(getAnyDef()) and result = "m?"
  }

  /**
   * Gets a string prefix to prepend to the operand's definition ID in an IR dump, specifying whether the operand is
   * an exact or inexact use of its definition. For an inexact use, the prefix is "~". For an exact use, the prefix is
   * the empty string.
   */
  private string getInexactSpecifier() {
    if isDefinitionInexact() then result = "~" else result = ""
  }

  /**
   * Get the order in which the operand should be sorted in the operand list.
   */
  int getDumpSortOrder() { result = -1 }

  /**
   * Gets the type of the value consumed by this operand. This is usually the same as the
   * result type of the definition instruction consumed by this operand. For register operands,
   * this is always the case. For some memory operands, the operand type may be different from
   * the definition type, such as in the case of a partial read or a read from a pointer that
   * has been cast to a different type.
   */
  Language::LanguageType getLanguageType() { result = getAnyDef().getResultLanguageType() }

  /**
   * Gets the language-neutral type of the value consumed by this operand. This is usually the same
   * as the result type of the definition instruction consumed by this operand. For register
   * operands, this is always the case. For some memory operands, the operand type may be different
   * from the definition type, such as in the case of a partial read or a read from a pointer that
   * has been cast to a different type.
   */
  final IRType getIRType() { result = getLanguageType().getIRType() }

  /**
   * Gets the type of the value consumed by this operand. This is usually the same as the
   * result type of the definition instruction consumed by this operand. For register operands,
   * this is always the case. For some memory operands, the operand type may be different from
   * the definition type, such as in the case of a partial read or a read from a pointer that
   * has been cast to a different type.
   */
  final Language::Type getType() { getLanguageType().hasType(result, _) }

  /**
   * Holds if the value consumed by this operand is a glvalue. If this
   * holds, the value of the operand represents the address of a location,
   * and the type of the location is given by `getType()`. If this does
   * not hold, the value of the operand represents a value whose type is
   * given by `getType()`.
   */
  final predicate isGLValue() { getLanguageType().hasType(_, true) }

  /**
   * Gets the size of the value consumed by this operand, in bytes. If the operand does not have
   * a known constant size, this predicate does not hold.
   */
  final int getSize() { result = getLanguageType().getByteSize() }
}

/**
 * An operand that consumes a memory result (e.g. the `LoadOperand` on a `Load` instruction).
 */
class MemoryOperand extends Operand {
  MemoryOperand() {
    this instanceof NonPhiMemoryOperandBase or
    this instanceof PhiOperandBase
  }

  /**
   * Gets the kind of memory access performed by the operand.
   */
  MemoryAccessKind getMemoryAccess() { result = getUse().getOpcode().getReadMemoryAccess() }

  /**
   * Holds if the memory access performed by this operand will not always read from every bit in the
   * memory location. This is most commonly used for memory accesses that may or may not actually
   * occur depending on runtime state (for example, the write side effect of an output parameter
   * that is not written to on all paths), or for accesses where the memory location is a
   * conservative estimate of the memory that might actually be accessed at runtime (for example,
   * the global side effects of a function call).
   */
  predicate hasMayReadMemoryAccess() { getUse().getOpcode().hasMayReadMemoryAccess() }

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
  OperandTag tag;

  NonPhiOperand() {
    this = registerOperand(useInstr, tag, _) or
    this = nonPhiMemoryOperand(useInstr, tag)
  }

  final override Instruction getUse() { result = useInstr }

  final override string getDumpLabel() { result = tag.getLabel() }

  final override string getDumpId() { result = tag.getId() }

  final override int getDumpSortOrder() { result = tag.getSortOrder() }

  /**
   * Gets the `OperandTag` that specifies how this operand is used by its `Instruction`.
   */
  final OperandTag getOperandTag() { result = tag }
}

/**
 * An operand that consumes a register (non-memory) result.
 */
class RegisterOperand extends NonPhiOperand, RegisterOperandBase {
  override RegisterOperandTag tag;
  Instruction defInstr;

  RegisterOperand() { this = registerOperand(useInstr, tag, defInstr) }

  final override string toString() { result = tag.toString() }

  final override Instruction getAnyDef() { result = defInstr }

  final override Overlap getDefinitionOverlap() {
    // All register results overlap exactly with their uses.
    result instanceof MustExactlyOverlap
  }
}

/**
 * A memory operand other than the operand of a `Phi` instruction.
 */
class NonPhiMemoryOperand extends NonPhiOperand, MemoryOperand, NonPhiMemoryOperandBase {
  override MemoryOperandTag tag;

  NonPhiMemoryOperand() { this = nonPhiMemoryOperand(useInstr, tag) }

  final override string toString() { result = tag.toString() }

  final override Instruction getAnyDef() {
    result = unique(Instruction defInstr | hasDefinition(defInstr, _))
  }

  final override Overlap getDefinitionOverlap() { hasDefinition(_, result) }

  pragma[noinline]
  private predicate hasDefinition(Instruction defInstr, Overlap overlap) {
    defInstr = Construction::getMemoryOperandDefinition(useInstr, tag, overlap) and
    not Construction::isInCycle(useInstr) and
    strictcount(Construction::getMemoryOperandDefinition(useInstr, tag, _)) = 1
  }

  /**
   * Holds if the operand totally overlaps with its definition and consumes the
   * bit range `[startBitOffset, endBitOffset)` relative to the start address of the definition.
   */
  predicate getUsedInterval(int startBitOffset, int endBitOffset) {
    Construction::getUsedInterval(this, startBitOffset, endBitOffset)
  }
}

/**
 * A memory operand whose type may be different from the type of the result of its definition.
 */
class TypedOperand extends NonPhiMemoryOperand {
  override TypedOperandTag tag;

  final override Language::LanguageType getLanguageType() {
    result = Construction::getInstructionOperandType(useInstr, tag)
  }
}

/**
 * The address operand of an instruction that loads or stores a value from
 * memory (e.g. `Load`, `Store`).
 */
class AddressOperand extends RegisterOperand {
  override AddressOperandTag tag;
}

/**
 * The buffer size operand of an instruction that represents a read or write of
 * a buffer.
 */
class BufferSizeOperand extends RegisterOperand {
  override BufferSizeOperandTag tag;
}

/**
 * The source value operand of an instruction that loads a value from memory (e.g. `Load`,
 * `ReturnValue`, `ThrowValue`).
 */
class LoadOperand extends TypedOperand {
  override LoadOperandTag tag;
}

/**
 * The source value operand of a `Store` instruction.
 */
class StoreValueOperand extends RegisterOperand {
  override StoreValueOperandTag tag;
}

/**
 * The sole operand of a unary instruction (e.g. `Convert`, `Negate`, `Copy`).
 */
class UnaryOperand extends RegisterOperand {
  override UnaryOperandTag tag;
}

/**
 * The left operand of a binary instruction (e.g. `Add`, `CompareEQ`).
 */
class LeftOperand extends RegisterOperand {
  override LeftOperandTag tag;
}

/**
 * The right operand of a binary instruction (e.g. `Add`, `CompareEQ`).
 */
class RightOperand extends RegisterOperand {
  override RightOperandTag tag;
}

/**
 * The condition operand of a `ConditionalBranch` or `Switch` instruction.
 */
class ConditionOperand extends RegisterOperand {
  override ConditionOperandTag tag;
}

/**
 * The operand representing the target function of an `Call` instruction.
 */
class CallTargetOperand extends RegisterOperand {
  override CallTargetOperandTag tag;
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
}

/**
 * An operand representing an argument to a function call.
 */
class PositionalArgumentOperand extends ArgumentOperand {
  override PositionalArgumentOperandTag tag;

  /**
   * Gets the zero-based index of the argument.
   */
  final int getIndex() { result = tag.getArgIndex() }
}

/**
 * An operand representing memory read as a side effect of evaluating another instruction.
 */
class SideEffectOperand extends TypedOperand {
  override SideEffectOperandTag tag;
}

/**
 * An operand of a `PhiInstruction`.
 */
class PhiInputOperand extends MemoryOperand, PhiOperandBase {
  PhiInstruction useInstr;
  Instruction defInstr;
  IRBlock predecessorBlock;
  Overlap overlap;

  PhiInputOperand() { this = phiOperand(useInstr, defInstr, predecessorBlock, overlap) }

  override string toString() { result = "Phi" }

  final override PhiInstruction getUse() { result = useInstr }

  final override Instruction getAnyDef() { result = defInstr }

  final override Overlap getDefinitionOverlap() { result = overlap }

  final override int getDumpSortOrder() { result = 11 + getPredecessorBlock().getDisplayIndex() }

  final override string getDumpLabel() {
    result = "from " + getPredecessorBlock().getDisplayIndex().toString() + ":"
  }

  final override string getDumpId() { result = getPredecessorBlock().getDisplayIndex().toString() }

  /**
   * Gets the predecessor block from which this value comes.
   */
  final IRBlock getPredecessorBlock() { result = predecessorBlock }

  final override MemoryAccessKind getMemoryAccess() { result instanceof PhiMemoryAccess }
}

/**
 * The total operand of a Chi node, representing the previous value of the memory.
 */
class ChiTotalOperand extends NonPhiMemoryOperand {
  override ChiTotalOperandTag tag;

  final override MemoryAccessKind getMemoryAccess() { result instanceof ChiTotalMemoryAccess }
}

/**
 * The partial operand of a Chi node, representing the value being written to part of the memory.
 */
class ChiPartialOperand extends NonPhiMemoryOperand {
  override ChiPartialOperandTag tag;

  final override MemoryAccessKind getMemoryAccess() { result instanceof ChiPartialMemoryAccess }
}

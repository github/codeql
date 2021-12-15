/**
 * Provides classes that describe how a particular `Instruction` or its operands access memory.
 */

private import IRConfiguration

private newtype TMemoryAccessKind =
  TIndirectMemoryAccess() or
  TBufferMemoryAccess() or
  TEntireAllocationMemoryAccess() or
  TEscapedMemoryAccess() or
  TNonLocalMemoryAccess() or
  TPhiMemoryAccess() or
  TUnmodeledMemoryAccess() or
  TChiTotalMemoryAccess() or
  TChiPartialMemoryAccess()

/**
 * Describes the set of memory locations memory accessed by a memory operand or
 * memory result.
 */
class MemoryAccessKind extends TMemoryAccessKind {
  /** Gets a textual representation of this access kind. */
  string toString() { none() }

  /**
   * Holds if the operand or result accesses memory pointed to by the `AddressOperand` on the
   * same instruction.
   */
  predicate usesAddressOperand() { none() }
}

/**
 * The operand or result accesses memory at the address specified by the `AddressOperand` on the
 * same instruction.
 */
class IndirectMemoryAccess extends MemoryAccessKind, TIndirectMemoryAccess {
  override string toString() { result = "indirect" }

  final override predicate usesAddressOperand() { any() }
}

/**
 * The operand or result accesses memory starting at the address specified by the `AddressOperand`
 * on the same instruction, accessing a number of consecutive elements given by the
 * `BufferSizeOperand`.
 */
class BufferMemoryAccess extends MemoryAccessKind, TBufferMemoryAccess {
  override string toString() { result = "buffer" }

  final override predicate usesAddressOperand() { any() }
}

/**
 * The operand or results accesses all memory in the contiguous allocation that contains the address
 * specified by the `AddressOperand` on the same instruction.
 */
class EntireAllocationMemoryAccess extends MemoryAccessKind, TEntireAllocationMemoryAccess {
  override string toString() { result = "alloc" }

  final override predicate usesAddressOperand() { any() }
}

/**
 * The operand or result accesses all memory whose address has escaped.
 */
class EscapedMemoryAccess extends MemoryAccessKind, TEscapedMemoryAccess {
  override string toString() { result = "escaped" }
}

/**
 * The operand or result access all memory whose address has escaped, other than data on the stack
 * frame of the current function.
 */
class NonLocalMemoryAccess extends MemoryAccessKind, TNonLocalMemoryAccess {
  override string toString() { result = "nonlocal" }
}

/**
 * The operand is a Phi operand, which accesses the same memory as its
 * definition.
 */
class PhiMemoryAccess extends MemoryAccessKind, TPhiMemoryAccess {
  override string toString() { result = "phi" }
}

/**
 * The operand is a ChiTotal operand, which accesses the same memory as its
 * definition.
 */
class ChiTotalMemoryAccess extends MemoryAccessKind, TChiTotalMemoryAccess {
  override string toString() { result = "chi(total)" }
}

/**
 * The operand is a ChiPartial operand, which accesses the same memory as its
 * definition.
 */
class ChiPartialMemoryAccess extends MemoryAccessKind, TChiPartialMemoryAccess {
  override string toString() { result = "chi(partial)" }
}

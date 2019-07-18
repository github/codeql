private newtype TMemoryAccessKind =
  TIndirectMemoryAccess() or
  TIndirectMayMemoryAccess() or
  TBufferMemoryAccess() or
  TBufferMayMemoryAccess() or
  TEscapedMemoryAccess() or
  TEscapedMayMemoryAccess() or
  TPhiMemoryAccess() or
  TUnmodeledMemoryAccess() or
  TChiTotalMemoryAccess() or
  TChiPartialMemoryAccess()

/**
 * Describes the set of memory locations memory accessed by a memory operand or
 * memory result.
 */
class MemoryAccessKind extends TMemoryAccessKind {
  string toString() {
    none()
  }

  /**
   * Holds if the operand or result accesses memory pointed to by the `AddressOperand` on the
   * same instruction.
   */
  predicate usesAddressOperand() {
    none()
  }
}

/**
 * The operand or result accesses memory at the address specified by the `AddressOperand` on the
 * same instruction.
 */
class IndirectMemoryAccess extends MemoryAccessKind, TIndirectMemoryAccess {
  override string toString() {
    result = "indirect"
  }
  
  override final predicate usesAddressOperand() {
    any()
  }
}

/**
 * The operand or result may access some, all, or none of the memory at the address specified by the
 * `AddressOperand` on the same instruction.
 */
class IndirectMayMemoryAccess extends MemoryAccessKind, TIndirectMayMemoryAccess {
  override string toString() {
    result = "indirect(may)"
  }

  override final predicate usesAddressOperand() {
    any()
  }
}

/**
 * The operand or result accesses memory starting at the address specified by the `AddressOperand`
 * on the same instruction, accessing a number of consecutive elements given by the
 * `BufferSizeOperand`.
 */
class BufferMemoryAccess extends MemoryAccessKind, TBufferMemoryAccess {
  override string toString() {
    result = "buffer"
  }

  override final predicate usesAddressOperand() {
    any()
  }
}

/**
 * The operand or result may access some, all, or none of the memory starting at the address
 * specified by the `AddressOperand` on the same instruction, accessing a number of consecutive
 * elements given by the `BufferSizeOperand`.
 */
class BufferMayMemoryAccess extends MemoryAccessKind, TBufferMayMemoryAccess {
  override string toString() {
    result = "buffer(may)"
  }

  override final predicate usesAddressOperand() {
    any()
  }
}

/**
 * The operand or result accesses all memory whose address has escaped.
 */
class EscapedMemoryAccess extends MemoryAccessKind, TEscapedMemoryAccess {
  override string toString() {
    result = "escaped"
  }
}

/**
 * The operand or result may access all memory whose address has escaped.
 */
class EscapedMayMemoryAccess extends MemoryAccessKind, TEscapedMayMemoryAccess {
  override string toString() {
    result = "escaped(may)"
  }
}

/**
 * The operand is a Phi operand, which accesses the same memory as its
 * definition.
 */
class PhiMemoryAccess extends MemoryAccessKind, TPhiMemoryAccess {
  override string toString() {
    result = "phi"
  }
}

/**
 * The operand is a ChiTotal operand, which accesses the same memory as its
 * definition.
 */
class ChiTotalMemoryAccess extends MemoryAccessKind, TChiTotalMemoryAccess {
  override string toString() {
    result = "chi(total)"
  }
}

/**
 * The operand is a ChiPartial operand, which accesses the same memory as its
 * definition.
 */
class ChiPartialMemoryAccess extends MemoryAccessKind, TChiPartialMemoryAccess {
  override string toString() {
    result = "chi(partial)"
  }
}

/**
 * The operand accesses memory not modeled in SSA. Used only on the result of
 * `UnmodeledDefinition` and on the operands of `UnmodeledUse`.
 */
class UnmodeledMemoryAccess extends MemoryAccessKind, TUnmodeledMemoryAccess {
  override string toString() {
    result = "unmodeled"
  }
}

import cpp

newtype TMemoryAccessKind =
  TIndirectMemoryAccess() or
  TEscapedMemoryAccess() or
  TPhiMemoryAccess() or
  TUnmodeledMemoryAccess()

/**
 * Describes the set of memory locations memory accessed by a memory operand or
 * memory result.
 */
class MemoryAccessKind extends TMemoryAccessKind {
  abstract string toString();
}

/**
 * The operand or result accesses memory at the address specified by the
 * `LoadStoreAddressOperand` on the same instruction.
 */
class IndirectMemoryAccess extends MemoryAccessKind, TIndirectMemoryAccess {
  override string toString() {
    result = "indirect"
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
 * The operand is a Phi operand, which accesses the same memory as its
 * definition.
 */
class PhiMemoryAccess extends MemoryAccessKind, TPhiMemoryAccess {
  override string toString() {
    result = "phi"
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

/**
 * Provides a stub implementation of the required aliased SSA interface until we implement aliased
 * SSA construction for C#.
 */

private import IRFunctionBase
private import TInstruction

module Ssa {
  class MemoryLocation = boolean;

  predicate hasPhiInstruction(TRawInstruction blockStartInstr, MemoryLocation memoryLocation) {
    none()
  }

  predicate hasChiInstruction(TRawInstruction primaryInstruction) { none() }

  predicate hasUnreachedInstruction(IRFunctionBase irFunc) { none() }
}

/** DEPRECATED: Alias for Ssa */
deprecated module SSA = Ssa;

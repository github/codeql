/**
 * Provides a stub implementation of the required aliased SSA interface until we implement aliased
 * SSA construction for C#.
 */

private import IRFunctionBase
private import TInstruction

module SSA {
  class MemoryLocation = boolean;

  predicate hasPhiInstruction(
    IRFunctionBase irFunc, TRawInstruction blockStartInstr, MemoryLocation memoryLocation
  ) {
    none()
  }

  predicate hasChiInstruction(IRFunctionBase irFunc, TRawInstruction primaryInstruction) { none() }

  predicate hasUnreachedInstruction(IRFunctionBase irFunc) { none() }
}
